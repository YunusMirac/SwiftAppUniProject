//
//  MemoSpielModel.swift
//  MemoSpiel
//
//  Created by Yunus Mirac Comart on 07.06.26.
//

import Foundation

/// Generisches Memospiel-Model; die ViewModel-Schicht steuert Inhalt und Intents.
struct MemoSpielModel<KartenInhalt> where KartenInhalt: Equatable {
    private(set) var karten: Array<Karte>
    
    /// Erzeugt Kartenpaare, mischt sie und startet alle Karten verdeckt.
    init(anzahlKartenPaare: Int, kartenInhalteFabrik: (Int) -> KartenInhalt) {
        karten = []
        
        for kartenPaarIndex in 0..<max(2, anzahlKartenPaare) {
            let inhalt: KartenInhalt = kartenInhalteFabrik(kartenPaarIndex)
            // Karten starten verdeckt; istGesichtOben = false ist der Standardwert in Karte.
            karten.append(Karte(inhalt: inhalt, id: "\(kartenPaarIndex)a"))
            karten.append(Karte(inhalt: inhalt, id: "\(kartenPaarIndex)b"))
        }
        // Alle Kartenpaare nach der Erstellung durchmischen.
        karten.shuffle()
    }
    
    /// Mischt die Kartenpositionen im Array neu.
    mutating func shuffle() {
        karten.shuffle()
    }
    
    /// Index der einzigen offenen Karte; Setter verdeckt alle anderen Karten.
    private var indexDerEinzigenGewaehltenKarte: Int? {
        get { karten.indices.filter { index in karten[index].istGesichtOben }.only }
        set { karten.indices.forEach { karten[$0].istGesichtOben = (newValue == $0) } }
    }
    
    /// Verarbeitet die Auswahl einer Karte und aktualisiert den Spielzustand.
    mutating func waehle(_ karte: Karte) {
        if let indexGewaehlt = karten.firstIndex(where: { $0.id == karte.id }) {
            if !karten[indexGewaehlt].istGesichtOben && !karten[indexGewaehlt].istGeraten {
                if let indexEventuellGeratenerKarte = indexDerEinzigenGewaehltenKarte {
                    if karten[indexGewaehlt].inhalt == karten[indexEventuellGeratenerKarte].inhalt {
                        karten[indexGewaehlt].istGeraten = true
                        karten[indexEventuellGeratenerKarte].istGeraten = true
                    }
                } else {
                    indexDerEinzigenGewaehltenKarte = indexGewaehlt
                }
                karten[indexGewaehlt].istGesichtOben = true
            }
        }
    }
    
    struct Karte: Equatable, Identifiable, CustomStringConvertible {
        var description: String {
            return ("\(id): \(istGesichtOben ? "oben" : "unten"), \(istGeraten ? "geraten" : "nicht geraten")")
        }
        
        static func == (lhs: Karte, rhs: Karte) -> Bool {
            return lhs.istGesichtOben == rhs.istGesichtOben
                && lhs.istGeraten == rhs.istGeraten
                && lhs.inhalt == rhs.inhalt
        }
        
        /// true, wenn die Vorderseite sichtbar ist.
        fileprivate(set) var istGesichtOben: Bool = false
        /// true, wenn das Kartenpaar erfolgreich gefunden wurde.
        fileprivate(set) var istGeraten: Bool = false
        let inhalt: KartenInhalt
        let id: String
    }
}

extension Array {
    /// Liefert das einzige Element, falls das Array genau ein Element enthält.
    var only: Element? {
        count == 1 ? first : nil
    }
}
