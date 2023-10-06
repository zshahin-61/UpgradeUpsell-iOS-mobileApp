//
//  InvestmentSuggestion.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import Foundation
import FirebaseFirestoreSwift

struct InvestmentSuggestion: Codable, Identifiable {
    @DocumentID var id = UUID().uuidString
    var investorID: String
    var projectID: String
    var amountOffered: Double
    var durationWeeks: Int
    var description: String
    var status: String
    
    init?(dictionary: [String: Any]) {
        guard let myID = dictionary["id"] as? String else {
            print(#function, "Unable to get id from JSON")
            return nil
        }
        
        guard let myInvestorID = dictionary["investorID"] as? String else {
            print(#function, "Unable to get investorID from JSON")
            return nil
        }
        
        guard let myProjectID = dictionary["projectID"] as? String else {
            print(#function, "Unable to get projectID from JSON")
            return nil
        }
        
        guard let myAmountOffered = dictionary["amountOffered"] as? Double else {
            print(#function, "Unable to get amountOffered from JSON")
            return nil
        }
        
        guard let myDurationWeeks = dictionary["durationWeeks"] as? Int else {
            print(#function, "Unable to get durationWeeks from JSON")
            return nil
        }

        guard let myDescription = dictionary["description"] as? String else {
            print(#function, "Unable to get description from JSON")
            return nil
        }
        
        guard let myStatus = dictionary["status"] as? String else {
            print(#function, "Unable to get status from JSON")
            return nil
        }

        self.init(id: myID, investorID: myInvestorID, projectID:myProjectID, amountOffered: myAmountOffered, durationWeeks: myDurationWeeks, description: myDescription, status: myStatus)
    }
    
    
    init(id: String, investorID: String, projectID: String, amountOffered: Double, durationWeeks: Int, description: String, status: String) {
        self.id = id
        self.investorID = investorID
        self.projectID = projectID
        self.amountOffered = amountOffered
        self.durationWeeks = durationWeeks
        self.description = description
        self.status = status
    }
}
