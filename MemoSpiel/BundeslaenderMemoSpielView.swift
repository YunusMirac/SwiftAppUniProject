//
//  BundeslaenderMemoSpielView.swift
//  MemoSpiel
//
//  Created by Yunus Mirac Comart on 10.05.26.
//

import SwiftUI
import MapKit

struct BundeslaenderMemoSpielView: View {
    
    @ObservedObject var bundeslaenderMemoSpielVM: BundeslaenderMemoSpielVM
    @State private var kartenPosition: MapCameraPosition = .region(BundeslaenderMemoSpielVM.deutschlandRegion)
    
    var body: some View {
        VStack {
            Text("Lerne Deutschland kennen!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            // Karte mit BRD-Fokus; Marker kommt ausschließlich aus dem ViewModel.
            Map(position: $kartenPosition) {
                if let koordinate = bundeslaenderMemoSpielVM.markerKoordinate {
                    Marker(bundeslaenderMemoSpielVM.bundeslandName, coordinate: koordinate)
                }
            }
            .frame(height: 260)
            .onAppear {
                kartenPosition = .region(BundeslaenderMemoSpielVM.deutschlandRegion)
            }
            
            Text(bundeslaenderMemoSpielVM.bundeslandName)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.vertical, 8)
            
            karten
                .animation(.default, value: bundeslaenderMemoSpielVM.karten)
            
            HStack {
                Button("Mischen") {
                    bundeslaenderMemoSpielVM.mischen()
                }
                Button("Neues Spiel") {
                    bundeslaenderMemoSpielVM.neuesSpiel()
                }
            }
            .padding()
        }
    }
    
    /// 4x4-Spielfeld mit allen 16 Karten.
    var karten: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 4)
        
        return LazyVGrid(columns: columns, spacing: 4) {
            ForEach(bundeslaenderMemoSpielVM.karten) { karte in
                CardView(karte)
                    .aspectRatio(2/3, contentMode: .fit)
                    .onTapGesture {
                        bundeslaenderMemoSpielVM.waehleKarte(karte)
                    }
            }
        }
        .padding(.horizontal)
        .foregroundStyle(Color.orange)
    }
}

/// Stellt eine einzelne Memokarte mit Vorder- und Rückseite dar.
struct CardView: View {
    
    let karte: MemoSpielModel<Image>.Karte
    
    init(_ karte: MemoSpielModel<Image>.Karte) {
        self.karte = karte
    }
    
    var body: some View {
        ZStack {
            let basis = RoundedRectangle(cornerRadius: 12)
            Group {
                basis.fill(.white)
                basis.strokeBorder(lineWidth: 2)
                karte.inhalt
                    .scaledToFit()
                    .padding(4)
            }
            .opacity(karte.istGesichtOben ? 1 : 0)
            basis.fill().opacity(karte.istGesichtOben ? 0 : 1)
        }
        .opacity(karte.istGesichtOben || !karte.istGeraten ? 1 : 0)
    }
}

#Preview {
    BundeslaenderMemoSpielView(bundeslaenderMemoSpielVM: BundeslaenderMemoSpielVM())
}
