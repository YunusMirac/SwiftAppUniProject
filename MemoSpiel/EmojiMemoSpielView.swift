//
//  ContentView.swift
//  MemoSpiel
//
//  Created by Yunus Mirac Comart on 10.05.26.
//

import SwiftUI
import Combine

struct EmojiMemoSpielView: View {
    
    @ObservedObject var emojiMemoSpielVM: EmojiMemoSpielVM
    
    var body: some View {
        VStack {
            // Themenname wird vom ViewModel bereitgestellt und oben angezeigt.
            Text(emojiMemoSpielVM.themaName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            // Punktestand wird vom ViewModel read-only bereitgestellt.
            Text("Punkte: \(emojiMemoSpielVM.punkte)")
                .font(.title2)
                .fontWeight(.semibold)
            
            ScrollView {
                karten
                    .animation(.default, value: emojiMemoSpielVM.karten)
            }
            
            HStack {
                Button("Mischen") {
                    emojiMemoSpielVM.mischen()
                }
                // Intent-Button: ruft die ViewModel-Funktion für ein komplett neues Spiel auf.
                Button("Neues Spiel") {
                    emojiMemoSpielVM.neuesSpiel()
                }
            }
            .padding()
        }
    }
    
    var karten: some View {
        // Nutze ganze breite des Bildschirms und jede Karte soll 80 breit sein
        let columns = [GridItem(.adaptive(minimum: 85), spacing: 0)]
        
        // Lädt nur die Karten, die gerade auf dem Bildschirm zu sehen sind, und nimmt die Vorgaben von columns
        return LazyVGrid(columns: columns) {
            // Iteriert und erstellt für jedes Emoji eine Karte
            ForEach(emojiMemoSpielVM.karten) {
                karte in
                // BONUS 3: Gradient als Farbe (ShapeStyle Übergabe)
                CardView(karte, kartenStyle: emojiMemoSpielVM.kartenStyle)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        emojiMemoSpielVM
                            .waehleKarte(karte)
                    }

            }
        }
    }
}

/// Stellt eine einzelne Karte dar und kümmert sich um das Zeichnen der Form.
struct CardView: View {
    
    let karte: MemoSpielModal<String>.Karte
    // BONUS 3: Gradient als Farbe (ShapeStyle Übergabe)
    let kartenStyle: AnyShapeStyle
    
    init(_ karte: MemoSpielModal<String>.Karte, kartenStyle: AnyShapeStyle) {
        self.karte = karte
        self.kartenStyle = kartenStyle
    }
    
    var body: some View {
        ZStack {
            let basis = RoundedRectangle(cornerRadius: 12)
            Group {
                basis.fill(.white)
                basis.strokeBorder(kartenStyle, lineWidth: 2)
                Text(karte.inhalt)
                    .font(.system(size:200))
                    .minimumScaleFactor(0.001)
                    .aspectRatio(1, contentMode: .fit)
                    
                
            }
            .opacity(karte.istGesichtOben ? 1 : 0)
            basis.fill(kartenStyle).opacity(karte.istGesichtOben ? 0 : 1)
            
        }
        .opacity(karte.istGesichtOben || !karte.istGeraten ? 1 : 0)
        
    }
}

#Preview {
    EmojiMemoSpielView(emojiMemoSpielVM: EmojiMemoSpielVM())
}
