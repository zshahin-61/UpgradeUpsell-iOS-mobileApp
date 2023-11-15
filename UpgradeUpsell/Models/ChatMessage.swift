//
//  ChatMessage.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

//////////77777777

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Hashable, Identifiable{
    @DocumentID var id = UUID().uuidString
    var senderId: String
    var receiverId: String
    var content: String
    var timestamp: Date
    
    init?(dictionary: [String: Any]) {
        guard let myId = dictionary["id"] as? String else {
            print(#function, "Unable to get  ID from JSON")
            return nil
        }
        guard let mySenderId = dictionary["senderId"] as? String else {
            print(#function, "Unable to get  senderId from JSON")
            return nil
        }
        guard let myReceiverId = dictionary["receiverId"] as? String else {
            print(#function, "Unable to get  receiverId from JSON")
            return nil
        }
        guard let myContent = dictionary["Content"] as? String else {
            print(#function, "Unable to get  Content from JSON")
            return nil
        }
        guard let myTimestamp = dictionary["timestamp"] as? Date else {
            print(#function, "Unable to get  timestamp from JSON")
            return nil
        }
        
        self.init(id: myId, senderId: mySenderId, receiverId: myReceiverId, content: myContent, timestamp: myTimestamp)
        
    }
    
    init(id: String, senderId: String, receiverId: String, content: String, timestamp: Date) {
        //if let id = id {
            self.id = id
        //}
        self.senderId = senderId
        self.receiverId = receiverId
        self.content = content
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


