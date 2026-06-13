//
//  OrtungContentView.swift
//  MemoSpiel
//
//  Created by Yunus Mirac Comart on 13.06.26.
//

import SwiftUI
import MapKit

/// Demo-View aus Vorlesung 6 zur Geräte-Ortung.
struct ContentView: View {
    @StateObject var ortungsUmgebungVM = OrtungsUmgebungVM()
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        VStack {
            Text(ortungsUmgebungVM.locationString)
            Map(position: $cameraPosition)
        }
    }
}

#Preview {
    ContentView()
}
