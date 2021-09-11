//
//  Cardify.swift
//  Memorize
//
//  Created by Вадим Буркин on 29.07.2021.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    init(isFaceUp: Bool, color: Color = .red) {
        rotation = isFaceUp ? 0 : 180
        self.color = color
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    let color: Color
    var rotation: Double // in degrees
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(color, lineWidth: DrawingConstants.lineWidth)
            } else {
                shape.fill(color)
            }
            content
                .opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
        
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
}

extension View {
    func cardify(isFaceUp: Bool, color: Color) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, color: color))
    }
}
