//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by Atu on 2021/12/1.
//

import SwiftUI

struct EmojiMemoryGameView: View {

    
    @ObservedObject var game: EmojiMemoryGame
    
    @Namespace private var dealingNameSpace
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                gameBody
               
                HStack{
                   restart
                   Spacer()
                   shuffle
                }
                
                HStack{
                    remove
                    Spacer()
                    add
                }
                .font(.largeTitle)
                .padding(.horizontal)
            }
            deckBody
           
        }
        .padding(.horizontal)
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: EmojiMemoryGame.Card){
        dealt.insert(card.id)
    }
    
    private func isUnDealt(_ card: EmojiMemoryGame.Card) -> Bool{
        !dealt.contains(card.id)
    }
    
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation{
        var dealy = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id}){
            dealy = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(dealy)
    }
    
    private func zIndex(for card: EmojiMemoryGame.Card) -> Double{
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    var gameBody: some View{
        AspectVGrid(items: game.cards, aspectRatio: 2/3, content: {card in
            cardView(for: card)
        })
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody: some View{
        ZStack{
            ForEach(game.cards.filter(isUnDealt)){ card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(for: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            for card in game.cards{
                withAnimation(dealAnimation(for: card)){
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View{
        Button("Shuffle"){
            withAnimation{
                game.shuffle()
            }
        }
    }
    
    var restart: some View{
        Button("Restart"){
            withAnimation{
                dealt = []
                game.resatrt()
            }
        }
    }
    
    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View{
        if isUnDealt(card) || (card.isMatched && !card.isFaceUp) {
            Color.clear
        }else{
            CardView(card: card)
                .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                .padding(4)
                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                .zIndex(zIndex(for: card))
                .onTapGesture {
                    withAnimation{
                        game.choose(card)
                    }
                }
        }
    }
    
    var remove: some View{
        Button(action: {
//            if(emojiCount > 1){
//                emojiCount -= 1
//            }
        }, label: {
            Image(systemName: "minus.circle")
        })
    }
    
    var add: some View{
        Button(action: {
//            if(emojiCount < emojis.count){
//                emojiCount += 1
//            }
        }, label: {
            Image(systemName: "plus.circle")
        })
    }
    
    private struct CardConstants{
        static let color = Color.red
        static let aspectRatio: CGFloat =  2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth: CGFloat = undealtHeight * aspectRatio
    }

}

struct CardView: View {
    
    let card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View{
        GeometryReader(content: { geometry in
            ZStack{
                Group{
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear{
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)){
                                    animatedBonusRemaining = 0
                                }
                            }
                    }else{
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                    .padding(5)
                    .opacity(0.5)
                
               
                Text(card.content)
                    .rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrwaingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        })
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat{
        min(size.width, size.height) / (DrwaingConstants.fontSize / DrwaingConstants.fontScale)
    }
    
    private func font(in size: CGSize) -> Font{
        Font.system(size: min(size.width, size.height) * DrwaingConstants.fontScale)
    }
    
    private struct DrwaingConstants{
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}
