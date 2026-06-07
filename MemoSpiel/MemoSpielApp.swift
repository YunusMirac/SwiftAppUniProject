//
//  MemoSpielApp.swift
//  MemoSpiel
//
//  Created by Yunus Mirac Comart on 10.05.26.
//

import SwiftUI

@main
struct MemoSpielApp: App {
    @StateObject var meinSpielVM = EmojiMemoSpielVM()
    var body: some Scene {
        WindowGroup {
            EmojiMemoSpielView(emojiMemoSpielVM: meinSpielVM)
        }
    }
}
