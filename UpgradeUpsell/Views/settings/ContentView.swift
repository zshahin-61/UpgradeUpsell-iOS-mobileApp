//
//  ContentView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authHelper: FireAuthController
    private var dbHelper = FirestoreController.getInstance()

    @State private var root: RootView = .Login

    var body: some View {
        ZStack { // Add a ZStack to create the background
            //LinearGradient(gradient: Gradient(colors: [Color.blue, Color.gray, Color.green]), startPoint: .top, endPoint: .bottom)
           // Color(.systemBackground)
           //   .ignoresSafeArea() // Ignore safe area edges for the background
//            Color.blue
//                                .ignoresSafeArea()
//                            Circle()
//                                .scale(1.7)
//                                .foregroundColor(.white.opacity(0.15))
//                            Circle()
//                                .scale(1.35)
//                                .foregroundColor(.white)
            NavigationView {
                switch root {
                case .Login:
                    SignInView(rootScreen: $root).environmentObject(authHelper).environmentObject(self.dbHelper)
                case .Home:
                    HomeView(rootScreen: $root).environmentObject(authHelper).environmentObject(self.dbHelper)
                case .InvestorHome:
                    HomeView_Investor(rootScreen: $root).environmentObject(authHelper).environmentObject(self.dbHelper)
                case .RealtorHome:
                    HomeView_Realtor(rootScreen: $root).environmentObject(authHelper).environmentObject(self.dbHelper)
                case .SignUp:
                    SignUpView(rootScreen: $root).environmentObject(self.authHelper).environmentObject(self.dbHelper)
                case .Profile:
                    //switch dbHelper.userProfile?.role
                    ProfileView(rootScreen: $root).environmentObject(self.authHelper).environmentObject(self.dbHelper)
                case .Settings:
                    SettingsView(rootScreen: $root, backRoot: .Home).environmentObject(self.authHelper).environmentObject(self.dbHelper)
                }
            }.padding()
        }
        .scrollContentBackground(.hidden) // backcolor Gray
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
