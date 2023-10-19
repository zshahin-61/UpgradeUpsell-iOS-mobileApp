//
//  Investment.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import Foundation
import FirebaseFirestoreSwift

struct Investment: Codable, Hashable, Identifiable {
    @DocumentID var id = UUID().uuidString
    var investorID: String
    var projectID: String
    var amountInvested: Double
    var investmentDate: Date
    var status: String
    
    
    init(investmentID: String, investorID: String, projectID: String, amountInvested: Double, investmentDate: Date, status: String) {
        self.id = investmentID
        self.investorID = investorID
        self.projectID = projectID
        self.amountInvested = amountInvested
        self.investmentDate = investmentDate
        self.status = status
    }
}
