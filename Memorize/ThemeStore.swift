//
//  ThemeStore.swift
//  Memorize
//
//  Created by Вадим Буркин on 08.09.2021.
//

import SwiftUI

struct Theme: Identifiable, Codable, Hashable {
    var title: String
    var emojis: [String]
    var id: Int
    var rgba: RGBAColor
    var numberOfPairsOfCards: Int
}

class ThemeStore: ObservableObject {
    let name: String
    
    @Published var themes: [Theme] = [] {
        didSet {
            storeInUserDefaults()
        }
    }
    
    private var userDefaultsKey: String {
        "Theme Store:" + name
    }
    
    private func storeInUserDefaults() {
        UserDefaults.standard.set(try? JSONEncoder().encode(themes), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults() {
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedThemes = try? JSONDecoder().decode([Theme].self, from: jsonData) {
            themes = decodedThemes
        }
    }
    
    private func templateThemes() {
        insertTheme(titled: "Halloween", emojis: ["👻", "🎃", "🕷️"], color: .orange)
        insertTheme(titled: "Christmas", emojis: ["🎅", "⛪", "🌟", "❄️", "⛄", "🎄", "🎁", "🧦"], color: .blue)
        insertTheme(titled: "Transport", emojis: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛵", "🛺", "🚔", "🚍", "🚘", "🚖", "✈️", "🚝", "🚢", "🚁"], color: .yellow, numberOfPairsOfCards: 10)
        insertTheme(titled: "NSFW", emojis: ["🍒", "🍑", "🥞", "🐱", "🍆", "🥜", "🧠", "👅"], color: .red)
        insertTheme(titled: "Sports", emojis: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🎱", "🥏", "🪀", "🏓", "🥊", "🥅", "🥌", "⛸", "🥋"], color: .purple)
        insertTheme(titled: "Animals", emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🐵"], color: .green)
    }
    
    init(named name: String) {
        self.name = name
        restoreFromUserDefaults()
        if themes.isEmpty {
            templateThemes()
        }
    }
    
    // MARK: - Intents
    
    func theme(at index: Int) -> Theme {
        let safeIndex = min(max(0, index), themes.count - 1)
        return themes[safeIndex]
    }
    
    @discardableResult
    func insertTheme(titled title: String, emojis: [String]? = nil,
                     at index: Int = 0, color: Color = .red,
                     numberOfPairsOfCards: Int? = nil) -> Theme {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme = Theme(title: title, emojis: emojis ?? [],
                          id: unique, color: color,
                          numberOfPairsOfCards: numberOfPairsOfCards ?? emojis?.count ?? 0)
        let safeIndex = max(min(0, index), themes.count)
        themes.insert(theme, at: safeIndex)
        return themes[safeIndex]
    }
    
    @discardableResult
    func removeTheme(at index: Int) -> Int {
        if themes.count > 1, themes.indices.contains(index) {
            themes.remove(at: index)
        }
        return index % themes.count
    }
}

extension Theme {
    var color: Color {
        get { Color(rgbaColor: rgba) }
        set { rgba = RGBAColor(color: newValue) }
    }
    
    fileprivate init(title: String, emojis: [String], id: Int, color: Color, numberOfPairsOfCards: Int) {
        self.title = title
        self.emojis = emojis
        self.id = id
        self.rgba = RGBAColor(color: color)
        self.numberOfPairsOfCards = numberOfPairsOfCards
    }
}
