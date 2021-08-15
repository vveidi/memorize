//
//  Cardify.swift
//  Memorize
//
//  Created by Вадим Буркин on 29.07.2021.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    init(isFaceUp: Bool, color1: Color = .red, color2: Color = .blue) {
        rotation = isFaceUp ? 0 : 180
        self.color1 = color1
        self.color2 = color2
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    let color1: Color
    let color2: Color
    var rotation: Double // in degrees
    
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(color1, lineWidth: DrawingConstants.lineWidth)
            } else {
                shape.fill(LinearGradient(gradient: Gradient(colors: [color1, color2]),
                                          startPoint: .topLeading,
                                          endPoint: .bottomTrailing))
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
    func cardify(isFaceUp: Bool, color1: Color, color2: Color) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, color1: color1, color2: color2))
    }
}
