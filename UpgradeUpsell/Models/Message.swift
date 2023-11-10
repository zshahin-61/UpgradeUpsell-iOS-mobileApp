//
//  Message.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import Foundation




struct Message: Identifiable, Codable, Hashable {
    let id = UUID()
    let sender: String
    let text: String
    let timestamp: Date
}
