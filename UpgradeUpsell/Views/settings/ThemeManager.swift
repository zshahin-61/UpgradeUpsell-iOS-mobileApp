//
//  ThemeManager.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-15.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("selectedTheme") var selectedTheme: String = "light"

    var currentTheme: ColorScheme {
        return selectedTheme == "dark" ? .dark : .light
    }

    func toggleTheme() {
        selectedTheme = selectedTheme == "light" ? "dark" : "light"
    }
}
