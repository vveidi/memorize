//
//  Themes.swift
//  Memorize
//
//  Created by Вадим Буркин on 19.06.2021.
//

import SwiftUI

let themes = [
    Theme(title: "Halloween",
          color: .orange,
          accentColor: .black,
          emojis: ["👻", "🎃", "🕷️"],
          numberOfPairsOfCards: 47),
    Theme(title: "Christmas",
          color: .blue,
          accentColor: .black,
          emojis: ["🎅", "⛪", "🌟", "❄️", "⛄", "🎄", "🎁", "🧦"],
          numberOfPairsOfCards: 8),
    Theme(title: "Transport",
          color: .green,
          accentColor: .yellow,
          emojis: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🛺", "🚔", "🚍", "🚘", "🚖", "✈️", "🚝", "🚢", "🚁"],
          numberOfPairsOfCards: 10),
    Theme(title: "NSFW",
          color: .red,
          accentColor: .orange,
          emojis: ["🍒", "🍑", "🥞", "🐱", "🍆", "🥜", "🧠", "👅"],
          numberOfPairsOfCards: 10),
    Theme(title: "Sports",
          color: .pink,
          accentColor: .gray,
          emojis: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🎱", "🥏", "🪀", "🏓", "🥊", "🥅", "🥌", "⛸", "🥋"],
          numberOfPairsOfCards: 10),
    Theme(title: "Animals",
          color: .purple,
          accentColor: .red,
          emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🐵"],
          randomNumberOfPairsCards: true)
]

struct Theme {
    let title: String
    let color: Color
    var accentColor: Color
    var emojis: [String]
    var numberOfPairsOfCards: Int?
    var randomNumberOfPairsCards: Bool?
    
    // init with all or random number of emojis available in the theme
    init(title: String, color: Color, accentColor: Color, emojis: [String], randomNumberOfPairsCards: Bool? = false) {
        self.title = title
        self.color = color
        self.accentColor = accentColor
        self.emojis = emojis
        self.randomNumberOfPairsCards = randomNumberOfPairsCards
        
        if randomNumberOfPairsCards! {
            self.numberOfPairsOfCards = Int.random(in: 3...emojis.count)
        } else {
            self.numberOfPairsOfCards = emojis.count
        }
    }
    
    // init with a specific number of pairs of cards to show
    init(title: String, color: Color, accentColor: Color, emojis: [String], numberOfPairsOfCards: Int) {
        self.title = title
        self.color = color
        self.accentColor = accentColor
        self.emojis = emojis
        
        if emojis.count < numberOfPairsOfCards {
            self.numberOfPairsOfCards = emojis.count
        } else {
            self.numberOfPairsOfCards = numberOfPairsOfCards
        }
    }
    
}
