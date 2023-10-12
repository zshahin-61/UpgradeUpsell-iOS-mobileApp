//
//  RenovateProject.swift
//  UpgradeUpsell
//
//  Created by Zahra Shahin on 2023-09-20.
//

import Foundation
import FirebaseFirestoreSwift

struct RenovateProject: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var title: String
    var description: String
    var location: String
    var lng: Double
    var lat: Double
    var images: Data?
    var ownerID: String
    var category: String
    var investmentNeeded: Double
    var selectedInvestmentSuggestionID: String?
    var status: String
    var startDate: Date
    var endDate: Date
    var numberOfBedrooms: Int
    var numberOfBathrooms: Int
    var propertyType: String
    var squareFootage: Double
    var isFurnished: Bool
    var createdDate: Date
    var updatedDate: Date
    var favoriteCount: Int
    var realtorID: String

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

        guard let myImages = dictionary["images"] as? Data else {
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

        guard let mySelectedInvestmentSuggestionID = dictionary["selectedInvestmentSuggestionID"] as? String else {
            print(#function, "Unable to get selectedInvestmentSuggestionID from JSON")
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

        guard let myNumberOfBedrooms = dictionary["numberOfBedrooms"] as? Int else {
            print(#function, "Unable to get numberOfBedrooms from JSON")
            return nil
        }

        guard let myNumberOfBathrooms = dictionary["numberOfBathrooms"] as? Int else {
            print(#function, "Unable to get numberOfBathrooms from JSON")
            return nil
        }

        guard let myPropertyType = dictionary["propertyType"] as? String else {
            print(#function, "Unable to get propertyType from JSON")
            return nil
        }

        guard let mySquareFootage = dictionary["squareFootage"] as? Double else {
            print(#function, "Unable to get squareFootage from JSON")
            return nil
        }

        guard let myIsFurnished = dictionary["isFurnished"] as? Bool else {
            print(#function, "Unable to get isFurnished from JSON")
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

        self.init(projectID: myID, title: myTitle, description: myDescription, location: myLocation, lng: myLng, lat: myLat, images: myImages, ownerID: myOwnerID, category: myCategory, investmentNeeded: myInvestmentNeeded, selectedInvestmentSuggestionID: mySelectedInvestmentSuggestionID, status: myStatus, startDate: myStartDate, endDate: myEndDate, numberOfBedrooms: myNumberOfBedrooms, numberOfBathrooms: myNumberOfBathrooms, propertyType: myPropertyType, squareFootage: mySquareFootage, isFurnished: myIsFurnished, createdDate: myCreatedDate, updatedDate: myUpdatedDate, favoriteCount: myFavoriteCount, realtorID: myRealtorID)
    }

    init(projectID: String, title: String, description: String, location: String, lng: Double, lat: Double, images: Data?, ownerID: String, category: String, investmentNeeded: Double, selectedInvestmentSuggestionID: String?, status: String, startDate: Date, endDate: Date, numberOfBedrooms: Int, numberOfBathrooms: Int, propertyType: String, squareFootage: Double, isFurnished: Bool, createdDate: Date, updatedDate: Date, favoriteCount: Int, realtorID: String) {
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
        self.numberOfBedrooms = numberOfBedrooms
        self.numberOfBathrooms = numberOfBathrooms
        self.propertyType = propertyType
        self.squareFootage = squareFootage
        self.isFurnished = isFurnished
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.favoriteCount = favoriteCount
        self.realtorID = realtorID
    }
}
