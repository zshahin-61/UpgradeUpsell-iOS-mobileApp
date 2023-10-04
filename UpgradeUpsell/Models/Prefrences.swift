//
//  Prefrences.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import Foundation

struct Prefrences: Codable, Hashable {
    var notifications: Notifs
    var theme: String
    var language: String
    var fontSize: Int?

    // Static function to define default preferences
    init() {
        self.theme = "light" // Set your default theme here
        
        self.notifications = Notifs()
       // self.notifications.email = true
        self.language = "en_US"
        self.fontSize = 16
    }
}

struct Notifs: Codable, Hashable {
    var push: Bool = true
    var email: Bool = true
}
