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
    var title: String
    var description: String
    var location: String
    var lng: Double
    var lat: Double
    var images: [Data]
    var ownerID: String
    var category: String
    var investmentNeeded: Double
    var selectedInvestmentSuggestionID: String?
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
    
    init?(dictionary: [String: Any]) {
        guard let myID = dictionary["id"] as? String else {
            print(#function, "Unable to get ID from JSON")
            return nil
        }
        
        guard let myDescription = dictionary["description"] as? String else {
            print(#function, "Unable to get description from JSON")
            return nil
        }
        
        guard let myTitle = dictionary["title"] as? String else {
            print(#function, "Unable to get title from JSON")
            return nil
        }
        
        guard let myLocation = dictionary["location"] as? String else {
            print(#function, "Unable to get location from JSON")
            return nil
        }

        guard let myLng = dictionary["lng"] as? Double else {
            print(#function, "Unable to get langtitude from JSON")
            return nil
        }
        
        guard let myLat = dictionary["lat"] as? Double else {
            print(#function, "Unable to get latitude from JSON")
            return nil
        }

        guard let myImages = dictionary["images"] as? [Data] else {
            print(#function, "Unable to get images from JSON")
            return nil
        }
        
        guard let myOwnerID = dictionary["ownerID"] as? String else {
            print(#function, "Unable to get owner ID from JSON")
            return nil
        }
        
        guard let myCategory = dictionary["category"] as? String else {
            print(#function, "Unable to get category from JSON")
            return nil
        }
        
        guard let myInvestmentNeeded = dictionary["investmentNeeded"] as? Double else {
            print(#function, "Unable to get investmentNeeded from JSON")
            return nil
        }
        
        guard let myInvestmentSuggestions = dictionary["investmentSuggestions"] as? [InvestmentSuggestion] else {
            print(#function, "Unable to get address from JSON")
            return nil
        }
        
        guard let mySelectedInvestmentSuggestionID = dictionary["selectedInvestmentSuggestionID"] as? String else {
            print(#function, "Unable to get selectedInvestmentSuggestionID from JSON")
            return nil
        }
        
        guard let myInvestmentNeeded = dictionary["investmentNeeded"] as? Double else {
            print(#function, "Unable to get investmentNeeded from JSON")
            return nil
        }
        
        guard let myStatus = dictionary["status"] as? String else {
            print(#function, "Unable to get status from JSON")
            return nil
        }
        
        guard let myStartDate = dictionary["startDate"] as? Date else {
            print(#function, "Unable to get startDate from JSON")
            return nil
        }
        
        guard let myEndDate = dictionary["endDate"] as? Date else {
            print(#function, "Unable to get endDate from JSON")
            return nil
        }
        
        guard let myCreatedDate = dictionary["createdDate"] as? Date else {
            print(#function, "Unable to get createdDate from JSON")
            return nil
        }
        
        guard let myUpdatedDate = dictionary["updatedDate"] as? Date else {
            print(#function, "Unable to get updatedDate from JSON")
            return nil
        }
        
        guard let myFavoriteCount = dictionary["favoriteCount"] as? Int else {
            print(#function, "Unable to get favoriteCount from JSON")
            return nil
        }
        
        guard let myRealtorID = dictionary["realtorID"] as? String else {
            print(#function, "Unable to get realtorID from JSON")
            return nil
        }

        self.init(projectID: myID, title: myTitle, description: myDescription, location: myLocation, lng: myLng, lat: myLat, images: myImages, ownerID: myOwnerID, category: myCategory, investmentNeeded: myInvestmentNeeded, selectedInvestmentSuggestionID: mySelectedInvestmentSuggestionID, status: myStatus, startDate: myStartDate, endDate: myEndDate, createdDate: myCreatedDate, updatedDate: myUpdatedDate, favoriteCount: myFavoriteCount, realtorID: myRealtorID)
    }
    
    
    
    init(projectID: String, title: String, description: String, location: String, lng: Double, lat: Double, images: [Data], ownerID: String, category: String, investmentNeeded: Double,  selectedInvestmentSuggestionID: String, status: String, startDate: Date, endDate: Date, createdDate: Date, updatedDate: Date, favoriteCount: Int, realtorID: String) {
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
