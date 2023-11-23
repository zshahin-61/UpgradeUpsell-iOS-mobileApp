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


//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//    FirebaseApp.configure()
//      
//    
//  }
//}




@main
struct UpgradeUpsellApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let authHelper = FireAuthController()
    @StateObject private var themeManager = ThemeManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
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
                .preferredColorScheme(themeManager.currentTheme)
                                .environmentObject(themeManager)
                //.background(BackgroundView()) // Apply the gradient background
            
            
        }
    }
}

