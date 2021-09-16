//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Вадим Буркин on 09.09.2021.
//

import SwiftUI

struct ThemeChooser: View {
    @ObservedObject var store: ThemeStore
    @State private var editMode: EditMode = .inactive
    @State private var games: [Int: EmojiMemoryGame] = [:]
    @State private var editingTheme: Theme?
    @State private var activeGame: EmojiMemoryGame?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    if let game = games[theme.id] {
                        NavigationLink(destination: EmojiMemoryGameView(game: chooseActiveGame(for: theme) ?? game, activeGame: $activeGame)) {
                            ThemeListItem(theme: theme, editMode: $editMode)
                                .gesture(editMode == .active ? tap(theme) : nil)
                                .onChange(of: theme) { theme in
                                    games[theme.id] = EmojiMemoryGame(theme: theme)
                                }
                        }
                    }
                }
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
                .onMove { indexSet, newOffset in
                    store.themes.move(fromOffsets: indexSet, toOffset: newOffset)
                }
            }
            .navigationTitle("Memorize")
            .popover(item: $editingTheme) { theme in
                ThemeEditor(theme: $store.themes[theme])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    addNewThemeButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .environment(\.editMode, $editMode)
            .onAppear {
                if games.isEmpty {
                    store.themes.forEach { theme in
                        games[theme.id] = EmojiMemoryGame(theme: theme)
                    }
                }
            }
        }
    }
    
    func tap(_ theme: Theme) -> some Gesture {
        TapGesture()
            .onEnded {
                editingTheme = theme
            }
    }
    
    var addNewThemeButton: some View {
        Button(action: {
            editingTheme = store.insertTheme(titled: "New Theme")
        }) {
            Image(systemName: "plus")
        }
    }
    
    func chooseActiveGame(for theme: Theme) -> EmojiMemoryGame? {
        if let game = activeGame, game.theme == theme {
            return game
        }
        return nil
    }
}

struct ThemeListItem: View {
    var theme: Theme
    @Binding var editMode: EditMode
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(theme.title)
                .font(.title2)
                .foregroundColor(editMode == .active ? .primary : theme.color)
            HStack {
                theme.numberOfPairsOfCards == theme.emojis.count
                    ? Text("All of")
                    : Text("\(theme.numberOfPairsOfCards) pairs from")
                Text(theme.emojis.joined())
                    .lineLimit(1)
            }
        }
    }
}

// MARK: - Previews

struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser(store: ThemeStore(named: "Preview"))
    }
}
