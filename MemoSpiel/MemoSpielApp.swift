//
//  MemoSpielApp.swift
//  MemoSpiel
//
//  Created by Yunus Mirac Comart on 10.05.26.
//

import SwiftUI

@main
struct MemoSpielApp: App {
    @StateObject var meinSpielVM = BundeslaenderMemoSpielVM()
    var body: some Scene {
        WindowGroup {
            BundeslaenderMemoSpielView(bundeslaenderMemoSpielVM: meinSpielVM)
        }
    }
}
