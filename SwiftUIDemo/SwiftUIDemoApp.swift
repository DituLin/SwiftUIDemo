//
//  SwiftUIDemoApp.swift
//  SwiftUIDemo
//
//  Created by Atu on 2021/12/1.
//

import SwiftUI

@main
struct SwiftUIDemoApp: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
