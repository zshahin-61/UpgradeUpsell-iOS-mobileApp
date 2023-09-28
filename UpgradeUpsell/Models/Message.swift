//
//  Message.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import Foundation

struct Message: Codable, Hashable {
    let senderID: String
    let content: String
    let timeStamp: Date
}
