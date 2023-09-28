//
//  FirestoreController.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreController: ObservableObject {
    
    //    @Published var myEventsList: [MyEvent] = [MyEvent]()
        @Published var userProfile: UserProfile?
    //    @Published var myFriendsList: [UserProfile] = [UserProfile]()
    
    private let db: Firestore
    private static var shared: FirestoreController?
    
    /// COLLECTIONS LIST  /////////////
    private let COLLECTION_UsersProfile = "UsersProfile"
    private let COLLECTION_Notification = "Notification"
    private let COLLECTION_RenovateProject = "RenovateProject"
    private let COLLECTION_InvestmentSuggestion = "InvestmentSuggestions"
    private let COLLECTION_RealtorSuggestion = "RealtorSuggestions"
    private let COLLECTION_Investment = "Investment"
    private let COLLECTION_ProfitSharing = "ProfitSharing"
    private let COLLECTION_Financial = "Financial"
    private let COLLECTION_ChatMessages = "ChatMessage"
    /// END COLLECTIONS LIST //////
    
    /// Fields //////
    private let FIELD_userID = "userID"
    private let FIELD_username = "username"
    private let FIELD_role = "role"
    private let FIELD_email = "email"
    private let FIELD_authenticationToken = "authenticationToken"
    private let FIELD_preferences = "preferences"
    private let FIELD_userBio = "userBio"
    private let FIELD_profilePicture = "profilePicture"
    private let FIELD_notifications = "notifications"
    private let FIELD_favoriteProjects = "favoriteProjects"
    //////
    private let FIELD_notifID = "notifID"
    private let FIELD_title = "title"
    private let FIELD_message = "message"
    private let FIELD_date = "date"
    private let FIELD_isRead = "isRead"
    //////
    private let FIELD_projectID = "projectID"
    private let FIELD_description = "description"
    private let FIELD_location = "location"
    private let FIELD_lng = "lng"
    private let FIELD_lat = "lat"
    private let FIELD_images = "images"
    private let FIELD_ownerID = "ownerID"
    private let FIELD_category = "category"
    private let FIELD_investmentNeeded = "investmentNeeded"
    private let FIELD_InvestmentSuggestions = "InvestmentSuggestions"
    private let FIELD_selctedInvestmentSuggestionID = "selctedInvestmentSuggestionID"
    private let FIELD_status = "status"
    private let FIELD_startDate = "startDate"
    private let FIELD_endDate = "endDate"
    private let FIELD_contactInfo = "contactInfo"
    private let FIELD_createdDate = "createdDate"
    private let FIELD_updatedDate = "updatedDate"
    private let FIELD_RealtorID = "RealtorID"
    private let FIELD_buySuggestions = "buySuggestions"
    private let FIELD_selectedBuySuggestionID = "selectedBuySuggestionID"
    //////
    private let FIELD_investmentSuggestionID = "investmentSuggestionID"
    private let FIELD_investorID = "investorID"
    private let FIELD_amountOffered = "amountOffered"
    private let FIELD_durationWeeks = "durationWeeks"
    //////
    private let FIELD_buySuggestionID = "buySuggestionID"
    private let FIELD_realtorID = "realtorID"
    //////
    private let FIELD_investmentID = "investmentID"
    private let FIELD_amountInvested = "amountInvested"
    private let FIELD_investmentDate = "investmentDate"
    //////
    
    //////
    
    private var loggedInUserEmail: String = ""
    
    init(db: Firestore) {
        self.db = db
    }
    
    static func getInstance() -> FirestoreController {
        if self.shared == nil {
            self.shared = FirestoreController(db: Firestore.firestore())
        }
        return self.shared!
    }
    
    // MARK: User profile functions
    func getUserProfile(withCompletion completion: @escaping (Bool) -> Void) {
        self.loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
        print("\(self.loggedInUserEmail)")
        
        let document = db.collection(COLLECTION_UsersProfile).document(self.loggedInUserEmail)
        
        document.addSnapshotListener { (documentSnapshot, error) in
            if let document = documentSnapshot, document.exists {
                do {
                    if let userProfile = try document.data(as: UserProfile?.self) {
                        self.userProfile = userProfile
                        DispatchQueue.main.async {
                            completion(true)
                        }
                    }
                } catch {
                    print("Error decoding user profile data: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        //self.isLoginSuccessful = false
                        completion(false)
                    }
                }
            } else {
                print("Document does not exist")
                DispatchQueue.main.async {
                    //self.isLoginSuccessful = false
                    completion(false)
                }
            }
        }
    }
    
}
