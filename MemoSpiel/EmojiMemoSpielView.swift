//
//  ContentView.swift
//  MemoSpiel
//
//  Created by Yunus Mirac Comart on 10.05.26.
//

import SwiftUI

struct EmojiMemoSpielView: View {
    // Button wird gewählt und Array wird mit den Emojis befüllt.
    @State var emojis: Array<String> = []
    
    var body: some View {
        VStack {
            Text("Memospiel!").font(.largeTitle)
            //Scrollbarer View falls alle Karten nicht mehr reinpassen
            ScrollView{
                karten
            }
            kartenSteuerung
        }
        .padding()
    }
    
    var karten: some View {
        // Nutze ganze breite des Bildschirms und jede Karte soll 80 breit sein
        let columns = [GridItem(.adaptive(minimum: 85))]
        
        // Lädt nur die Karten die gerade audf dem Bildschirm zusehen sind und nimmt die Vorgaben von columns
        return LazyVGrid(columns: columns) {
            // Iteriert und erstellt für jedes Emoji eine Karte
            ForEach(0..<emojis.count, id: \.self) { index in
                CardView(content: emojis[index])
                    .font(.largeTitle) // größe
                    .aspectRatio(1, contentMode: .fit) // Sorgt für die richtige Kartenform
            }
        }
        .foregroundStyle(Color.orange)
    }
    
    var kartenSteuerung: some View {
        HStack {
            // --- BUTTON 1: TIERE ---
            // array wird 2 mal mit den selben emojis befüllt für mmoryspiel und hat eine zufällighe Reihenfolge
            Button(action: {
                emojis = (animal + animal).shuffled()
            }) {
                // untereinander
                VStack {
                    //esrstellt bild mit einem Text drunter
                    Image(systemName: "pawprint.circle.fill").font(.largeTitle)
                    Text("Tiere").font(.caption)
                }
            }
            
            Spacer()
            
            // --- BUTTON 2: TRANSPORT ---
            Button(action: {
                emojis = (transport + transport).shuffled()
            }) {
                VStack {
                    Image(systemName: "car.circle.fill").font(.largeTitle)
                    Text("Transport").font(.caption)
                }
            }
            
            Spacer()
            
            // --- BUTTON 3: FLAGGEN ---
            Button(action: {
                emojis = (flagg + flagg).shuffled()
            }) {
                VStack {
                    Image(systemName: "flag.circle.fill").font(.largeTitle)
                    Text("Flaggen").font(.caption)
                }
            }
        }
    }
}

struct CardView: View {
    let content: String
    @State var istGesichtOben: Bool = false
    var body: some View {
        ZStack {
            let basis: RoundedRectangle = RoundedRectangle(cornerRadius: 12)
            if istGesichtOben {
                basis.fill(.white)
                basis.strokeBorder(lineWidth: 2)
                
                Text(content)
            }
            else {
                RoundedRectangle(cornerRadius: 5).fill()
            }
        }.onTapGesture {
            istGesichtOben.toggle()
        }
        
    }
}

#Preview {
    EmojiMemoSpielView()
}
