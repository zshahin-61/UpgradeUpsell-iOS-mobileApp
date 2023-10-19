//
//  Review.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-10-17.
//

import Foundation
import FirebaseFirestoreSwift

struct review: Identifiable, Codable, Hashable{
    @DocumentID var id : String? = UUID().uuidString
    var investorID: String
    var investorName : String
    var revID: String
    var revName: String
    var rating: Double
    var description : String
    var date : Date
    
    init?(dictionary: [String: Any]) {
        
        guard let myID = dictionary["id"] as? String else {
            print(#function, "Unable to get id from JSON")
            return nil
        }
        
        guard let myInvID = dictionary["invID"] as? String else {
            print(#function, "Unable to get invID from JSON")
            return nil
        }
        
        guard let myInvName = dictionary["invName"] as? String else {
            print(#function, "Unable to get invName from JSON")
            return nil
        }
        guard let myRevID = dictionary["revID"] as? String else {
            print(#function, "Unable to get revID from JSON")
            return nil
        }
        
        guard let myRevName = dictionary["revName"] as? String else {
            print(#function, "Unable to get revName from JSON")
            return nil
        }
        
        guard let myDescription = dictionary["description"] as? String else {
            print(#function, "Unable to get description from JSON")
            return nil
        }
        
        guard let myRating = dictionary["rating"] as? Double else {
            print(#function, "Unable to get rating from JSON")
            return nil
        }
        guard let myDate = dictionary["date"] as? Date else {
            print(#function, "Unable to get date from JSON")
            return nil
        }
        self.init(id: myID, investorID: myInvID, investorName: myInvName, revID: myRevID, revName: myRevName, rating: myRating, description: myDescription, date: myDate)
    }
    
    
    init(id: String, investorID: String, investorName: String, revID: String, revName: String,  rating: Double, description: String, date: Date) {
        self.id = id
        self.investorID = investorID
        self.investorName = investorName
        self.revID = revID
        self.revName = revName
        self.rating = rating
        self.description = description
        self.date = date
    }
}
