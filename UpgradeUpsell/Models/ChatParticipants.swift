//
//  ChatParticipants.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-10.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatParticipants {
    let ownerID: String
    let investorID: String

    init(ownerID: String, investorID: String) {
        // Ensure the IDs are sorted alphabetically
        //let sortedIDs = [user1, user2].sorted()
        self.ownerID = ownerID
        self.investorID = investorID
    }

    // Convert the struct to a dictionary for Firestore
    var toDictionary: [String: Any] {
        return [
            "ownerID": ownerID,
            "investorID": investorID
        ]
    }
}
