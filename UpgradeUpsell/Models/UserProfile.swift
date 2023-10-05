//
//  UserProfiles.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import Foundation
import FirebaseFirestoreSwift

struct UserProfile: Codable, Hashable, Identifiable {
    @DocumentID var id : String? = UUID().uuidString
    //var username: String?
    var role: String
    var fullName: String
    var email: String
    var authenticationToken: String?
    var prefrences: Prefrences?
    var userBio: String
    var profilePicture: Data?
    var favoriteProjects: [String]?
    var idCard:Data?
    let contactNumber: String
    let address: String
    
    init?(dictionary: [String: Any]) {
        guard let myUserID = dictionary["id"] as? String else {
            print(#function, "Unable to get user ID from JSON")
            return nil
        }
        
//        guard let myUsername = dictionary["username"] as? String else {
//            print(#function, "Unable to get username from JSON")
//            return nil
//        }
        
        guard let myRole = dictionary["role"] as? String else {
            print(#function, "Unable to get role from JSON")
            return nil
        }
        
        guard let myFullName = dictionary["fullName"] as? String else {
            print(#function, "Unable to get fullName from JSON")
            return nil
        }

        guard let myEmail = dictionary["email"] as? String else {
            print(#function, "Unable to get email from JSON")
            return nil
        }
        
        guard let myUserBio = dictionary["userBio"] as? String else {
            print(#function, "Unable to get userBio from JSON")
            return nil
        }

        guard let myPrefrences = dictionary["prefrences"] as? Prefrences else {
            print(#function, "Unable to get prefrences from JSON")
            return nil
        }
        
        guard let myProfilePicture = dictionary["profilePicture"] as? Data else {
            print(#function, "Unable to get profilePicture from JSON")
            return nil
        }
        
        guard let myIdCard = dictionary["idCard"] as? Data else {
            print(#function, "Unable to get idCard from JSON")
            return nil
        }
        
        guard let myContactNumber = dictionary["contactNumber"] as? String else {
            print(#function, "Unable to get contactNumber from JSON")
            return nil
        }
        
        guard let myAddress = dictionary["address"] as? String else {
            print(#function, "Unable to get address from JSON")
            return nil
        }

//        self.init(user: myName, contactNumber: myContactNumber, address: myAddress, image: myImage, friends: myFriends, numberOfEventsAttending: myNumberOfEventsAttending)
        self.init(id:myUserID, fullName: myFullName, email: myEmail, role: myRole, userBio: myUserBio, profilePicture: myProfilePicture,  prefrences: myPrefrences, contactNumber: myContactNumber, address: myAddress)
    }
    
    init(id: String, fullName:String, email: String, role: String, userBio: String, profilePicture: Data?,  prefrences: Prefrences, contactNumber: String, address: String) {
        self.id = id
        //self.username = username
        self.role = role
        self.fullName = fullName
        self.email = email
        self.prefrences = Prefrences()
        self.userBio = userBio
        //self.idCard = idCard
        self.contactNumber = contactNumber
        self.address = address
    }
    
    
    
}

