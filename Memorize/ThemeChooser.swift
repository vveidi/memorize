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
    @State private var chosenTheme: Theme?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(theme: theme)) {
                        ThemeListItem(theme: theme, editMode: $editMode, chosenTheme: $chosenTheme)
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
            .popover(item: $chosenTheme) { theme in
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
        }
    }
    
    var addNewThemeButton: some View {
        Button(action: {
            chosenTheme = store.insertTheme(titled: "New Theme")
        }) {
            Image(systemName: "plus")
        }
    }
}

struct ThemeListItem: View {
    var theme: Theme
    @Binding var editMode: EditMode
    @Binding var chosenTheme: Theme?
    
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
        .gesture(editMode == .active ? tap(theme) : nil)
    }
    
    func tap(_ theme: Theme) -> some Gesture {
        TapGesture()
            .onEnded {
                chosenTheme = theme
            }
    }
}

// MARK: - Previews

struct ThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        ThemeChooser(store: ThemeStore(named: "Preview"))
    }
}
