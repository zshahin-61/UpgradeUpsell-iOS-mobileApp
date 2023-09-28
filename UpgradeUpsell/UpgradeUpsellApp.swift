//
//  UpgradeUpsellApp.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
struct UpgradeUpsellApp: App {
    
    let authHelper = FireAuthController()
    //private var dbHelper = FirestoreController.getInstance()

    init(){
        //configure Firebase in the project
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authHelper)
        }
    }
}
