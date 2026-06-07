//
//  Thema.swift
//  MemoSpiel
//
//  Created by Yunus Mirac Comart on 07.06.26.
//

import Foundation

/// Beschreibt ein Memospiel-Thema mit Emojis, Paaranzahl und Akzentfarbe.
struct Thema {
    /// Anzeigename des Themas (z. B. „Tiere“).
    let name: String
    /// Verfügbare Emoji-Symbole für die Kartenpaare.
    let emojis: [String]
    /// Anzahl der Kartenpaare; Int = feste Anzahl, nil = zufällige Anzahl pro Spiel.
    // BONUS 2: Zufällige Kartenanzahl (Optional verwendet)
    let anzahlKartenPaare: Int?
    /// Akzentfarbe als Text, UI-unabhängig (z. B. „orange“ oder „gradient_fire“).
    let farbe: String
}

/// Sammlung aller verfügbaren Memospiel-Themen.
enum ThemenKatalog {
    /// Alle Themen; jedes neue Thema benötigt genau eine Zeile.
    static let alle: [Thema] = [
        Thema(name: "Tiere", emojis: ["🦊", "🐱", "🐻", "🐨", "🐸", "🐼", "🦁", "🐹"], anzahlKartenPaare: 4, farbe: "orange"),
        Thema(name: "Sport", emojis: ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🥏"], anzahlKartenPaare: nil, farbe: "blue"),
        Thema(name: "Fahrzeuge", emojis: ["🚗", "🚕", "🚌", "🚎", "🏎️", "🚓", "🚑", "🚒"], anzahlKartenPaare: 3, farbe: "red"),
        Thema(name: "Flaggen", emojis: ["🇩🇪", "🇫🇷", "🇮🇹", "🇪🇸", "🇬🇧", "🇯🇵", "🇺🇸", "🇧🇷"], anzahlKartenPaare: 6, farbe: "gradient_rainbow"),
        Thema(name: "Halloween", emojis: ["🎃", "👻", "🕷️", "🦇", "🧙", "🕸️", "💀", "🧛"], anzahlKartenPaare: 4, farbe: "gradient_fire"),
        Thema(name: "Natur", emojis: ["🌸", "🌻", "🌺", "🌹", "🌷", "🌼", "🍀", "🌵"], anzahlKartenPaare: nil, farbe: "mint"),
    ]
}
