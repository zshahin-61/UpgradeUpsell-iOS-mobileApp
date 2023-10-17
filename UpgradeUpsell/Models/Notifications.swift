//
//  LogEntry.swift
//  UpgradeUpsell
//
//  Created by zahra SHAHIN on 2023-10-16.
//

import Foundation
import FirebaseFirestoreSwift

struct Notifications : Codable, Identifiable ,Hashable {
    @DocumentID var id: String? = UUID().uuidString
    var timestamp: Date
    var userID: String
    var event: String
    var details: String?
    var isRead : Bool
    var projectID : String?
    
    init?(dictionary: [String: Any]) {
        
        guard let myID = dictionary["id"] as? String else {
            print(#function, "Unable to get user ID from JSON")
            return nil
        }
        
        guard let myTimestamp = dictionary["timestamp"] as? Date else {
            print(#function, "Unable to get timestamp from JSON")
            return nil
        }
        
        guard let myUserID = dictionary["userID"] as? String else {
            print(#function, "Unable to get userID from JSON")
            return nil
        }
        guard let myEvent = dictionary["event"] as? String else {
            print(#function, "Unable to get event from JSON")
            return nil
        }
        
        guard let myDetails = dictionary["details"] as? String else {
            print(#function, "Unable to get details from JSON")
            return nil
        }
        
        guard let myisRead = dictionary["isRead"] as? Bool else {
            print(#function, "Unable to get isread from JSON")
            return nil
        }
        guard let myProjectID = dictionary["projectID"] as? String else {
            print(#function, "Unable to get projectID from JSON")
            return nil
        }
        self.init(id:myID, timestamp: myTimestamp, userID: myUserID, event: myEvent, details: myDetails , isRead: myisRead ,projectID: myProjectID)
    }
    
    init(id: String, timestamp:Date, userID: String, event: String, details: String, isRead:Bool , projectID:String) {
        self.id = id
        self.timestamp = timestamp
        self.userID = userID
        
        self.event = event
        self.details = details
        self.isRead = isRead
        self.projectID = projectID
        
    }
   
}
