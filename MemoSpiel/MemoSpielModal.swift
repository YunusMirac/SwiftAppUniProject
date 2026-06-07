//
//  MemoSpielModal.swift
//  MemoSpiel
//
//  Created by Yunus Mirac Comart on 07.06.26.
//

import Foundation

struct MemoSpielModal<KartenInhalt> where KartenInhalt: Equatable {
    private(set) var karten: Array<Karte>
    /// Aktuelle Punktzahl; startet bei 0 und darf auch negativ werden.
    private(set) var punkte: Int = 0
    /// IDs von Karten, die einmal aufgedeckt und wieder verdeckt wurden.
    private var geseheneKarten: Set<String> = []
    
    init(anzahlKartenPaare: Int, kartenInhalteFabrik: (Int) -> KartenInhalt) {
        karten = []
        
        for kartenPaarIndex in 0..<max(2, anzahlKartenPaare) {
            let inhalt: KartenInhalt = kartenInhalteFabrik(kartenPaarIndex)
            // Karten starten verdeckt; istGesichtOben = false ist der Standardwert in Karte.
            karten.append(Karte(inhalt: inhalt, id: "\(kartenPaarIndex)a"))
            karten.append(Karte(inhalt: inhalt, id: "\(kartenPaarIndex)b"))
        }
        // Erzeugte Kartenpaare nach der Erstellung durchmischen.
        karten.shuffle()
    }
    
    /// Mischt die Kartenpositionen im Model neu, ohne ein neues Thema zu starten.
    mutating func shuffle() {
        karten.shuffle()
    }
    
    var indexDerEinzigenGewaehltenKarte: Int? {
        get { karten.indices.filter {index in karten[index].istGesichtOben}.only }
        
        set { karten.indices.forEach {karten[$0].istGesichtOben = (newValue == $0)} }
    }
    
    mutating func waehle(_ karte: Karte) {
        if let indexGewaehlt = karten.firstIndex(where: {$0.id == karte.id} ) {
            if !karten[indexGewaehlt].istGesichtOben && !karten[indexGewaehlt].istGeraten {
                if let indexEventuellGeratenerKarte = indexDerEinzigenGewaehltenKarte {
                    if karten[indexGewaehlt].inhalt == karten[indexEventuellGeratenerKarte].inhalt {
                        // Übereinstimmung: Paar gefunden, +2 Punkte.
                        karten[indexGewaehlt].istGeraten = true
                        karten[indexEventuellGeratenerKarte].istGeraten = true
                        punkte += 2
                    } else {
                        // Fehlpaarung: -1 Punkt pro beteiligter Karte, die bereits gesehen wurde.
                        if geseheneKarten.contains(karten[indexEventuellGeratenerKarte].id) {
                            punkte -= 1
                        }
                        if geseheneKarten.contains(karten[indexGewaehlt].id) {
                            punkte -= 1
                        }
                    }
                } else {
                    // Dritte Karte: offene, nicht geratene Karten werden verdeckt und als gesehen markiert.
                    for index in karten.indices {
                        if karten[index].istGesichtOben && !karten[index].istGeraten {
                            geseheneKarten.insert(karten[index].id)
                        }
                    }
                    indexDerEinzigenGewaehltenKarte = indexGewaehlt
                }
                karten[indexGewaehlt].istGesichtOben = true
            }
        }
    }
    
    struct Karte: Equatable, Identifiable, CustomStringConvertible {
        var description: String {
            return ("\(id): \(inhalt), \(istGesichtOben ? "oben": "unten"), \(istGeraten ? "geraten": "nicht geraten")")
        }
        
        static func == (lhs: Karte, rhs: Karte) -> Bool {
            return lhs.istGesichtOben == rhs.istGesichtOben && lhs.istGeraten == rhs.istGeraten && lhs.inhalt == rhs.inhalt
        }
        
        var istGesichtOben: Bool = false
        var istGeraten: Bool = false
        var inhalt: KartenInhalt
        var id: String
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
