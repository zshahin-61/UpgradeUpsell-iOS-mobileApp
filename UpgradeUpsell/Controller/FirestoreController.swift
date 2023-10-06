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
    @Published var userProfile: UserProfile?
    
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
    private let FIELD_UP_userID = "userID"
    private let FIELD_UP_username = "username"
    private let FIELD_UP_fullName = "fullName"
    private let FIELD_UP_role = "role"
    private let FIELD_UP_email = "email"
    private let FIELD_UP_address = "address"
    private let FIELD_UP_contactNumber = "contactNumber"
    private let FIELD_UP_authenticationToken = "authenticationToken"
    private let FIELD_UP_preferences = "preferences"
    private let FIELD_UP_userBio = "userBio"
    private let FIELD_UP_profilePicture = "profilePicture"
    private let FIELD_UP_notifications = "notifications"
    private let FIELD_UP_favoriteProjects = "favoriteProjects"
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
    
    private var loggedInUserID: String = ""
    
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
        self.loggedInUserID = UserDefaults.standard.string(forKey: "KEY_ID") ?? ""
        print("\(self.loggedInUserID)")
        
        let document = db.collection(COLLECTION_UsersProfile).document(self.loggedInUserID)
        
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
    
    func createUserProfile(newUser: UserProfile){
        print(#function, "Inserting profile Info")
        self.loggedInUserID = newUser.id!
        do{
            let docRef = db.collection(COLLECTION_UsersProfile).document(newUser.id!)
            try docRef.setData([FIELD_UP_email: newUser.email,
                FIELD_UP_fullName: newUser.fullName,
                     FIELD_UP_role : newUser.role,
                              FIELD_UP_userBio: newUser.userBio,
                       FIELD_UP_profilePicture: newUser.profilePicture,
                         FIELD_UP_address: newUser.address,
                       FIELD_UP_contactNumber: newUser.contactNumber
                               ]){ error in
            }
            self.userProfile = newUser
            print(#function, "user \(newUser.fullName) successfully added to database")
        }catch let err as NSError{
            print(#function, "Unable to add user to database : \(err)")
        }//do..catch
        
    }
    
    func updateUserProfile(userToUpdate : UserProfile){
        print(#function, "Updating user profile \(userToUpdate.fullName), ID : \(userToUpdate.id)")
        
        
        //get the email address of currently logged in user
        self.loggedInUserID = UserDefaults.standard.string(forKey: "KEY_ID") ?? ""
        
        if (self.loggedInUserID.isEmpty){
            print(#function, "Logged in user's ID address not available. Can't update User Profile")
        }
        else{
            do{
                try self.db
                    .collection(COLLECTION_UsersProfile)
                    .document(userToUpdate.id!)
                    .updateData([FIELD_UP_fullName : userToUpdate.fullName,
                       FIELD_UP_contactNumber : userToUpdate.contactNumber,
                              FIELD_UP_address : userToUpdate.address,
                                  FIELD_UP_userBio : userToUpdate.userBio,
                            FIELD_UP_profilePicture: userToUpdate.profilePicture
                          ]){ error in
                        
                        if let err = error {
                            print(#function, "Unable to update user profile in database : \(err)")
                        }else{
                            print(#function, "User profile \(userToUpdate.fullName) successfully updated in database")
                        }
                    }
            }catch let err as NSError{
                print(#function, "Unable to update user profile in database : \(err)")
            }//catch
        }//else
    }
    
    
    func deleteUser(withCompletion completion: @escaping (Bool) -> Void) {
        
        //get the email address of currently logged in user
        self.loggedInUserID = UserDefaults.standard.string(forKey: "KEY_ID") ?? ""
        
        if (self.loggedInUserID.isEmpty){
            print(#function, "Logged in user's ID address not available. Can't delete USER")
            DispatchQueue.main.async {
                completion(false)
            }
        }
        else{
            do{
                try self.db
                    .collection(COLLECTION_UsersProfile)
                    .document(self.loggedInUserID)
                    .delete{ error in
                        if let err = error {
                            print(#function, "Unable to delete user from database : \(err)")
                            DispatchQueue.main.async {
                                completion(false)
                            }
                        }else{
                            print(#function, "user \(self.loggedInUserID) successfully deleted from database")
                            DispatchQueue.main.async {
                                completion(true)
                            }
                        }
                    }
            }catch let err as NSError{
                print(#function, "Unable to delete user from database : \(err)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    
}
