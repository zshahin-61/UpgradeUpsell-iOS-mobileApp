//
//  ChatParticipants.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-10.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatPermission {
    let user1: String
    let user2: String
    let canChat: Bool

    init(user1: String, user2: String, canChat: Bool) {
        self.user1 = user1
        self.user2 = user2
        self.canChat = canChat
    }

    init?(documentData: [String: Any]) {
        guard
            let user1 = documentData["user1"] as? String,
            let user2 = documentData["user2"] as? String,
            let canChat = documentData["canChat"] as? Bool
        else {
            return nil
        }

        self.user1 = user1
        self.user2 = user2
        self.canChat = canChat
    }

    var documentID: String {
        return [user1, user2].sorted().joined(separator: "_")
    }

    var asDictionary: [String: Any] {
        return [
            "user1": user1,
            "user2": user2,
            "canChat": canChat
        ]
    }
}
