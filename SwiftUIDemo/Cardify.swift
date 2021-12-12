//
//  Cardify.swift
//  SwiftUIDemo
//
//  Created by Atu on 2021/12/12.
//

import SwiftUI

struct Cardify: ViewModifier {
    
    var isFaceUp: Bool
    
    func body(content: Content) -> some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: DrwaingConstants.connerRadius)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrwaingConstants.lineWidth)
            }else{
                shape.fill()
            }
            content.opacity(isFaceUp ? 1 : 0)
            
        }
    }
    
    private struct DrwaingConstants{
        static let connerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
    }
}

extension View{
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
