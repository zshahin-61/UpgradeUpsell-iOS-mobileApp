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
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
                    .environmentObject(authHelper)
                    .accentColor(Color(red: 0.0, green: 0.40, blue: 0.0))
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.green, Color.white]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()
                    )
                //.background(BackgroundView()) // Apply the gradient background
            }
        }
    }
}

