//
//  CardView.swift
//  Memorize
//
//  Created by Вадим Буркин on 30.07.2021.
//

import SwiftUI

struct CardView: View {
    let card: EmojiMemoryGame.Card
    @ObservedObject var game: EmojiMemoryGame
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
                    }
                }
                .foregroundColor(game.theme.color)
                .padding(6)
                .opacity(0.4)
                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .padding(5)
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp, color1: game.theme.color, color2: game.theme.accentColor)
        }
    }
    
    private func scale(thatFits size: CGSize) -> CGFloat {
        guard size.width > 0 && size.height > 0 else { return 0.01 }
        return min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale: CGFloat = 0.6
        static let fontSize: CGFloat = 32
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = EmojiMemoryGame.Card(isFaceUp: true, isMatched: false, isSeen: false, content: "🐯", id: 1)
        let game = EmojiMemoryGame()
        
        CardView(card: card, game: game)
            .frame(width: 300)
            .aspectRatio(2/3, contentMode: .fit)
    }
}
