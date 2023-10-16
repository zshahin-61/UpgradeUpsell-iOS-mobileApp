//
//  InvestmentSuggestion.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import Foundation
import FirebaseFirestoreSwift

struct InvestmentSuggestion: Codable, Hashable,Identifiable {
    @DocumentID var id = UUID().uuidString
    var investorID: String
    var investorFullName: String
    var ownerID:String
    var projectID: String
    var projectTitle: String
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
        
        let myInvestorFullName = dictionary["investorFullName"] as? String ?? "" 
        
        guard let myOwnerID = dictionary["ownerID"] as? String else {
            print(#function, "Unable to get ownerID from JSON")
            return nil
        }
        
        guard let myProjectID = dictionary["projectID"] as? String else {
            print(#function, "Unable to get projectID from JSON")
            return nil
        }
        
        guard let myProjectTitle = dictionary["projectTitle"] as? String else {
            print(#function, "Unable to get projectTitle from JSON")
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

        self.init(id: myID, investorID: myInvestorID, investorFullName: myInvestorFullName, ownerID: myOwnerID, projectID:myProjectID, projectTitle: myProjectTitle, amountOffered: myAmountOffered, durationWeeks: myDurationWeeks, description: myDescription, status: myStatus)
    }
    
    init(id: String, investorID: String, investorFullName: String, ownerID: String, projectID: String, projectTitle: String, amountOffered: Double, durationWeeks: Int, description: String, status: String) {
        self.id = id
        self.investorID = investorID
        self.investorFullName = investorFullName
        self.ownerID = ownerID
        self.projectID = projectID
        self.projectTitle = projectTitle
        self.amountOffered = amountOffered
        self.durationWeeks = durationWeeks
        self.description = description
        self.status = status
    }
}
