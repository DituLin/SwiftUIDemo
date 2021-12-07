//
//  MemoryGame.swift
//  SwiftUIDemo
//
//  Created by Atu on 2021/12/4.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    mutating func choose(_ card: Card){
//        if let chooseIndex = indexOf(of: card){
        if let chooseIndex = cards.firstIndex(where: {$0.id == card.id }),
           !cards[chooseIndex].isFaceUp,
           !cards[chooseIndex].isMatched{
            if let potentailMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chooseIndex].content == cards[potentailMatchIndex].content {
                    cards[chooseIndex].isMatched = true
                    cards[potentailMatchIndex].isMatched = true
                }
                indexOfTheOneAndOnlyFaceUpCard = nil
            }else{
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                indexOfTheOneAndOnlyFaceUpCard = chooseIndex
            }
            cards[chooseIndex].isFaceUp.toggle()
        }
       
        print("cards = \(cards)")
    }
    
    
    func indexOf(of card: Card) -> Int? {
        for index in 0..<cards.count {
            if  cards[index].id == card.id {
                return index
            }
        }
        return nil
    }
    
    init(numberOfPairsOfCards: Int,creatContent: (Int) -> CardContent) {
        cards = Array<Card>()
        
        for pairIndex in 0..<numberOfPairsOfCards{
            let content = creatContent(pairIndex)
            cards.append(Card(content: content,id: pairIndex * 2))
            cards.append(Card(content: content,id: pairIndex * 2 + 1))
        }
    }
    
    struct Card: Identifiable{
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
        
    }
}