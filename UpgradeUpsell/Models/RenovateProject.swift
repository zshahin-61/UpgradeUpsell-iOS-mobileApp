//
//  RenovateProject.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import Foundation
import FirebaseFirestoreSwift

struct RenovateProject: Codable , Identifiable {
    @DocumentID var id = UUID().uuidString
    //let projectID: String
    var title: String
    var description: String
    var location: String
    var lng: Double
    var lat: Double
    var images: [String]
    var ownerID: String
    var category: String
    var investmentNeeded: Double
    var investmentSuggestions: [InvestmentSuggestion]
    var selectedInvestmentSuggestionID: String
    var status: String
    var startDate: Date
    var endDate: Date
    //let contactInfo: ContactInfo
    var createdDate: Date
    var updatedDate: Date
    var favoriteCount: Int
    var realtorID: String
    //let buySuggestions: [BuySuggestion]
    //let selectedBuySuggestionID: String
    
    init(projectID: String, title: String, description: String, location: String, lng: Double, lat: Double, images: [String], ownerID: String, category: String, investmentNeeded: Double, investmentSuggestions: [InvestmentSuggestion], selectedInvestmentSuggestionID: String, status: String, startDate: Date, endDate: Date, createdDate: Date, updatedDate: Date, favoriteCount: Int, realtorID: String) {
        self.id = projectID
        self.title = title
        self.description = description
        self.location = location
        self.lng = lng
        self.lat = lat
        self.images = images
        self.ownerID = ownerID
        self.category = category
        self.investmentNeeded = investmentNeeded
        self.investmentSuggestions = investmentSuggestions
        self.selectedInvestmentSuggestionID = selectedInvestmentSuggestionID
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.favoriteCount = favoriteCount
        self.realtorID = realtorID
    }
    
    
}
