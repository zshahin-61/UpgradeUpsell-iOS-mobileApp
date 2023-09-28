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

    struct Notifs: Codable, Hashable {
        var push: Bool
        var email: Bool
    }
}
//create db
