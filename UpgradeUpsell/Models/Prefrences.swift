//
//  Prefrences.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import Foundation
import FirebaseFirestoreSwift

struct Prefrences: Codable, Hashable, Identifiable {
    @DocumentID var id : String? = UUID().uuidString
    var theme: String
    var language: String
    var fontSize: Int = 14
    var pushNotif: Bool = true
    var emailNotif: Bool = true

    init?(dictionary: [String: Any]) {
        guard let myID = dictionary["id"] as? String else {
            print(#function, "Unable to get user ID from JSON")
            return nil
        }
        
        guard let myTheme = dictionary["theme"] as? String else {
            print(#function, "Unable to get theme from JSON")
            return nil
        }
        
        guard let myLanguage = dictionary["language"] as? String else {
            print(#function, "Unable to get language from JSON")
            return nil
        }
        
        guard let myFontSize = dictionary["fontSize"] as? Int else {
            print(#function, "Unable to get fontSize from JSON")
            return nil
        }
        
        guard let myPushNotif = dictionary["pushNotif"] as? Bool else {
            print(#function, "Unable to get userBio from JSON")
            return nil
        }
        
        guard let myEmailNotif = dictionary["emailNotif"] as? Bool else {
            print(#function, "Unable to get idCard from JSON")
            return nil
        }
        
        self.init(id: myID, fontSize: myFontSize, theme: myTheme, language: myLanguage, pushNotif: myPushNotif, emailNotif: myEmailNotif)
    }
    
    
    init(id: String, fontSize: Int, theme: String, language: String, pushNotif: Bool, emailNotif: Bool) {
        self.id = id
        self.fontSize = fontSize
        self.theme = theme
        self.language = language
        self.fontSize = fontSize
        self.pushNotif = pushNotif
        self.emailNotif = emailNotif
    }
}
