//
//  EmojiMemoryGame.swift
//  SwiftUIDemo
//
//  Created by Atu on 2021/12/4.
//

import SwiftUI



class EmojiMemoryGame: ObservableObject {
    
    static let emojis = ["✈️","🚅","🚙","🏎","🛺"]
    
    static func createMemoryGame() -> MemoryGame<String>{
        return MemoryGame<String>(numberOfPairsOfCards: 4){pairIndex in
            EmojiMemoryGame.emojis[pairIndex]
        }
    }
    
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card>{
        return model.cards
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
    
        model.choose(card)
    }
}
