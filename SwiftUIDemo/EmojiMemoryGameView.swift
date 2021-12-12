//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by Atu on 2021/12/1.
//

import SwiftUI

struct EmojiMemoryGameView: View {

    
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        VStack{
            AspectVGrid(items: game.cards, aspectRatio: 2/3, content: {card in
                cardView(for: card)
            })
            .foregroundColor(.red)
            Spacer()
            HStack{
                remove
                Spacer()
                add
            }
            .font(.largeTitle)
            .padding(.horizontal)
        }
        .padding(.horizontal)
        
    }
    
    @ViewBuilder
    private func cardView(for card: EmojiMemoryGame.Card) -> some View{
        if card.isMatched && !card.isFaceUp{
            Rectangle().opacity(0)
        }else{
            CardView(card: card)
                .padding(4)
                .onTapGesture {
                    game.choose(card)
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

}

struct CardView: View {
    
    let card: EmojiMemoryGame.Card
    
    var body: some View{
        GeometryReader(content: { geometry in
            ZStack{
                Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90))
                    .padding(5).opacity(0.5)
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
