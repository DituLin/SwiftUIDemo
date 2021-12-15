//
//  Cardify.swift
//  SwiftUIDemo
//
//  Created by Atu on 2021/12/12.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var animatableData: Double{
        get {rotation}
        set {rotation = newValue}
    }
    
    var rotation: Double // in degrees
    
    func body(content: Content) -> some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: DrwaingConstants.connerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrwaingConstants.lineWidth)
            }else{
                shape.fill()
            }
            content.opacity(rotation < 90 ? 1 : 0)
            
        }
        .rotation3DEffect(
            Angle.degrees(rotation),
            axis: (0,1,0)
        )
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
