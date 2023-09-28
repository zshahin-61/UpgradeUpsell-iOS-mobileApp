//
//  InvestmentSuggestion.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import Foundation
import FirebaseFirestoreSwift

struct InvestmentSuggestion: Codable {
    var investmentSuggestionID: String
    var investorID: String
    var amountOffered: Double
    var durationWeeks: Int
    var description: String
    var status: String
    
    init(investmentSuggestionID: String, investorID: String, amountOffered: Double, durationWeeks: Int, description: String, status: String) {
        self.investmentSuggestionID = investmentSuggestionID
        self.investorID = investorID
        self.amountOffered = amountOffered
        self.durationWeeks = durationWeeks
        self.description = description
        self.status = status
    }
}
