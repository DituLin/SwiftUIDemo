//
//  MemoryGame.swift
//  SwiftUIDemo
//
//  Created by Atu on 2021/12/4.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int?{
        get { cards.indices.filter({cards[$0].isFaceUp}).oneAndOnly}
        
        set {
            cards.indices.forEach{ cards[$0].isFaceUp = ($0 == newValue)}
        }
    }
       
    
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
                cards[chooseIndex].isFaceUp = true
                
            }else{
                
                indexOfTheOneAndOnlyFaceUpCard = chooseIndex
            }
            
        }
       
        print("cards = \(cards)")
    }
    
    mutating func shuffle(){
        cards.shuffle()
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
        cards.shuffle()
    }
    
    struct Card: Identifiable{
        var isFaceUp: Bool = false{
            didSet{
                if isFaceUp {
                    startUsingBonusTime()
                }else{
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false{
            didSet{
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id: Int
        
        var bonusTimeLimit: TimeInterval = 6
        
        private var faceUpTime: TimeInterval{
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            }else{
                return pastFaceUpTime
            }
        }
        
        var lastFaceUpDate: Date?
        
        var pastFaceUpTime: TimeInterval = 0
        
        var bonusTimeRemaining: TimeInterval{
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var bonusRemaining: Double{
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        var hasEarnedBonus: Bool{
            isMatched && bonusTimeRemaining > 0
        }
        
        var isConsumingBonusTime: Bool{
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        private mutating func startUsingBonusTime(){
            if isConsumingBonusTime,lastFaceUpDate == nil{
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime(){
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
        
    }
}

extension Array{
    var oneAndOnly: Element?{
        if self.count == 1{
            return self.first
        }else{
            return nil
        }
    }
}
