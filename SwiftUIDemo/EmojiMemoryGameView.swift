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
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]){
                    ForEach(game.cards){card in
                        CardView(card: card)
                            .aspectRatio(2/3,contentMode: .fit)
                            .onTapGesture {
                                game.choose(card)
                            }
                    }
                }
            }
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
    
    let card: MemoryGame<String>.Card
    
    var body: some View{
        GeometryReader(content: { geometry in
            ZStack{
                let shape = RoundedRectangle(cornerRadius: DrwaingConstants.connerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrwaingConstants.lineWidth)
                    Text(card.content)
                        .font(font(in: geometry.size))
                }else if card.isMatched {
                    shape.opacity(0)
                }else{
                    shape.fill()
                }
                
            }
        })
    }
    
    private func font(in size: CGSize) -> Font{
        Font.system(size: min(size.width, size.height) * DrwaingConstants.fontScale)
    }
    
    private struct DrwaingConstants{
        static let connerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.8
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game)
    }
}
