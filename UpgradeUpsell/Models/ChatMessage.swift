//
//  ChatMessage.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Hashable, Identifiable{
    @DocumentID var id = UUID().uuidString
    var senderId: String
    var receiverId: String
    var text: String
    var timestamp: Date
    
    init(id : String?, senderId: String, receiverId: String, text: String, timestamp: Date) {
        if let id = id {
            self.id = id
        }
        self.senderId = senderId
        self.receiverId = receiverId
        self.text = text
        self.timestamp = timestamp
    }
}


//struct ChatMessage: Codable, Hashable , Identifiable {
//    @DocumentID var id = UUID().uuidString
//    //let chatID: String
//    var participants: [String]
//    var messages: [Message]
//    var timeStamp: Date
//    
//    init(id: String , participants: [String], messages: [Message], timeStamp: Date) {
//        self.id = id
//        self.participants = participants
//        self.messages = messages
//        self.timeStamp = timeStamp
//    }
//    
//}


