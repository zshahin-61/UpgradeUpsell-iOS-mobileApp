//
//  LogEntry.swift
//  UpgradeUpsell
//
//  Created by zahra SHAHIN on 2023-10-16.
//

import Foundation
import FirebaseFirestoreSwift

struct LogEntry : Codable, Hashable, Identifiable {
    @DocumentID var id : String? = UUID().uuidString
    var timestamp: Date
    var userID: String
    var event: String
    var details: String?
    
    
    init?(dictionary: [String: Any]) {
        
        guard let myID = dictionary["id"] as? String else {
            print(#function, "Unable to get user ID from JSON")
            return nil
        }
        
        guard let myTimestamp = dictionary["timestamp"] as? Date else {
            print(#function, "Unable to get role from JSON")
            return nil
        }
        
        guard let myUserID = dictionary["userID"] as? String else {
            print(#function, "Unable to get fullName from JSON")
            return nil
        }
        guard let myEvent = dictionary["event"] as? String else {
            print(#function, "Unable to get fullName from JSON")
            return nil
        }
        
        guard let myDetails = dictionary["details"] as? String else {
            print(#function, "Unable to get fullName from JSON")
            return nil
        }
        
        self.init(id:myID, timestamp: myTimestamp, userID: myUserID, event: myEvent, details: myDetails)
    }
    
    init(id: String, timestamp:Date, userID: String, event: String, details: String) {
        self.id = id
        self.timestamp = timestamp
        self.userID = userID
        self.event = event
        self.details = details
        
    }
   
}
