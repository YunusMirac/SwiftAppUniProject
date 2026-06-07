//
//  EmojiMemoSpielVM.swift
//  MemoSpiel
//
//  Created by Yunus Mirac Comart on 07.06.26.
//

import Foundation
import SwiftUI
import Combine


class EmojiMemoSpielVM: ObservableObject {
    /// Aktuelles Thema; von außen nur lesbar, Änderung nur über neuesSpiel().
    @Published private(set) var thema: Thema
    /// Spielzustand aus dem Model; wird bei App-Start und bei neuesSpiel() neu erzeugt.
    @Published private var memoSpielModal: MemoSpielModal<String>
    
    /// Wählt beim App-Start ein zufälliges Thema und initialisiert das Model.
    init() {
        let startThema = ThemenKatalog.alle.randomElement()!
        thema = startThema
        memoSpielModal = Self.erzeugeMemoSpiel(mit: startThema)
    }
    
    /// Anzeigename des Themas; ViewModel bereitet die Daten für die View auf.
    var themaName: String {
        thema.name
    }

    // BONUS 3: Gradient als Farbe (ShapeStyle Übergabe)
    /// Übersetzt den Farb-String aus dem Model in Color oder LinearGradient als AnyShapeStyle.
    var kartenStyle: AnyShapeStyle {
        switch thema.farbe {
        case "orange": return AnyShapeStyle(Color.orange)
        case "blue": return AnyShapeStyle(Color.blue)
        case "red": return AnyShapeStyle(Color.red)
        case "green": return AnyShapeStyle(Color.green)
        case "purple": return AnyShapeStyle(Color.purple)
        case "mint": return AnyShapeStyle(Color.mint)
        case "gradient_rainbow":
            return AnyShapeStyle(LinearGradient(
                colors: [.orange, .red],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
        case "gradient_fire":
            return AnyShapeStyle(LinearGradient(
                colors: [.yellow, .orange, .red],
                startPoint: .top,
                endPoint: .bottom
            ))
        // BONUS 1: Crash-Schutz - Unbekannte Farbnamen führen zu .gray statt Absturz.
        default: return AnyShapeStyle(Color.gray)
        }
    }

    
    var karten: Array<MemoSpielModal<String>.Karte> {
        return memoSpielModal.karten
    }
    
    /// Aktuelle Punktzahl aus dem Model; ViewModel reicht sie nur read-only weiter.
    var punkte: Int {
        memoSpielModal.punkte
    }
    
    /// Erzeugt ein neues Spiel für das übergebene Thema.
    static func erzeugeMemoSpiel(mit thema: Thema) -> MemoSpielModal<String> {
        // BONUS 2: Zufällige Kartenanzahl (Optional verwendet)
        let gewuenschtePaarAnzahl: Int
        if let festeAnzahl = thema.anzahlKartenPaare {
            gewuenschtePaarAnzahl = festeAnzahl
        } else {
            gewuenschtePaarAnzahl = Int.random(in: 2...thema.emojis.count)
        }
        // BONUS 1: Crash-Schutz - Verhindert Fehler bei ungültiger Paar-Anzahl im Thema.
        // Minimum 2 Paare (Memory-Regel), Maximum so viele Paare wie Emojis verfügbar sind.
        let sicherePaarAnzahl = min(max(2, gewuenschtePaarAnzahl), thema.emojis.count)
        // Emojis zuerst mischen, dann erst die benötigte Anzahl auswählen.
        let ausgewaehlteEmojis = Array(thema.emojis.shuffled().prefix(sicherePaarAnzahl))
        return MemoSpielModal<String>(anzahlKartenPaare: sicherePaarAnzahl) { paarIndex in
            return ausgewaehlteEmojis[paarIndex]
        }
    }
    
    /// Wählt ein zufälliges Thema, das sich vom aktuellen unterscheidet.
    private static func zufaelligesAnderesThema(als aktuelles: Thema) -> Thema {
        let andereThemen = ThemenKatalog.alle.filter { $0.name != aktuelles.name }
        return andereThemen.randomElement() ?? aktuelles
    }
    
    /// Intent: Neues Spiel mit neu ausgelostem Thema und frisch erzeugtem Model.
    func neuesSpiel() {
        let neuesThema = Self.zufaelligesAnderesThema(als: thema)
        thema = neuesThema
        memoSpielModal = Self.erzeugeMemoSpiel(mit: neuesThema)
    }
    
    /// Intent: Delegiert die Spiel- und Punkte-Logik an das Model.
    func waehleKarte(_ karte: MemoSpielModal<String>.Karte) {
        var modal = memoSpielModal
        modal.waehle(karte)
        memoSpielModal = modal
    }
    
    /// Intent: Mischt die Karten im Model neu, ohne ein neues Thema zu starten.
    func mischen() {
        var modal = memoSpielModal
        modal.shuffle()
        memoSpielModal = modal
    }
}
