//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Вадим Буркин on 22.05.2021.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var store = ThemeStore(named: "Default")
    
    var body: some Scene {
        WindowGroup {
            ThemeChooser(store: store)
        }
    }
}
