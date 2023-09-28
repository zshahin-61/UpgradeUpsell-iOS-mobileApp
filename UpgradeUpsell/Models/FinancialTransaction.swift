//
//  FinancialTransaction.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import Foundation
import FirebaseFirestoreSwift

struct FinancialTransaction: Codable , Hashable, Identifiable {
    @DocumentID var id = UUID().uuidString
    //let transactionID: String
    var transactionDate: Date
    var transactionType: String
    var transactionDescription: String
    var amount: Double
    var relatedInvestmentID: String
    var relatedUserID: String
    var status: String
    var paymentMethod: String
    var transactionReference: String
    
    init(transactionID: String, transactionDate: Date, transactionType: String, transactionDescription: String, amount: Double, relatedInvestmentID: String, relatedUserID: String, status: String, paymentMethod: String, transactionReference: String) {
        self.id = transactionID
        self.transactionDate = transactionDate
        self.transactionType = transactionType
        self.transactionDescription = transactionDescription
        self.amount = amount
        self.relatedInvestmentID = relatedInvestmentID
        self.relatedUserID = relatedUserID
        self.status = status
        self.paymentMethod = paymentMethod
        self.transactionReference = transactionReference
    }
}
