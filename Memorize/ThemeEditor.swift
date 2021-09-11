//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Вадим Буркин on 09.09.2021.
//

import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                themeNameSection
                removeEmojisSection
                addEmojisSection
                cardCountSection
                colorPickerSection
            }
            .navigationTitle("\(theme.title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    if presentationMode.wrappedValue.isPresented {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }
    }
    
    var themeNameSection: some View {
        Section(header: Text("Theme Name").bold()) {
            TextField("", text: $theme.title)
        }
    }
    
    var removeEmojisSection: some View {
        Section(header: removeEmojisSectionHeader) {
            let emojis = theme.emojis.uniqued()
            LazyVGrid(columns: [GridItem(.adaptive(minimum: ThemeConstants.emojiFontSize))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                guard emojis.count > ThemeConstants.minimumNumberOfEmojiPairs
                                else { return }
                                theme.emojis.removeAll(where: { $0 == emoji } )
                                if theme.numberOfPairsOfCards > theme.emojis.count {
                                    theme.numberOfPairsOfCards = theme.emojis.count
                                }
                            }
                        }
                }
            }
            .font(.system(size: ThemeConstants.emojiFontSize))
        }
    }
    
    var removeEmojisSectionHeader: some View {
        HStack {
            Text("Remove Emojis").bold()
            Spacer()
            Text("Tap Emoji to Exclude").font(.footnote)
        }
    }
    
    @State private var emojisToAdd = ""
    
    var addEmojisSection: some View {
        Section(header: Text("Add Emoji").bold()) {
            TextField("Emoji", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            theme.emojis = (theme.emojis + emojis.map { String($0) })
                .filter { Character($0).isEmoji }
                .uniqued()
        }
    }
    
    var cardCountSection: some View {
        Section(header: Text("Card Count").bold()) {
            Stepper(value: $theme.numberOfPairsOfCards,
                    in: ThemeConstants.minimumNumberOfEmojiPairs...theme.emojis.count) {
                Text("\(theme.numberOfPairsOfCards) pairs")
            }
        }
    }
    
    var colorPickerSection: some View {
        Section(header: Text("Color").bold()) {
            ColorPicker("Card Color", selection: $theme.color)
        }
    }
    
    private struct ThemeConstants {
        static let minimumNumberOfEmojiPairs = 2
        static let emojiFontSize: CGFloat = 40
    }
}

// MARK: - Previews

struct ThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditor(theme: .constant(ThemeStore(named: "Preview").theme(at: 2)))
    }
}
