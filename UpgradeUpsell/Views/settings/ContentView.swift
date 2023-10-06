//
//  ContentView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authHelper : FireAuthController
    private var dbHelper = FirestoreController.getInstance()
    
    @State private var root : RootView = .Login
    
    var body: some View {
        
        NavigationView{
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
                ProfileView(rootScreen: $root).environmentObject(self.authHelper).environmentObject(self.dbHelper)
                
            case .Settings:
                SettingsView(rootScreen: $root).environmentObject(self.authHelper).environmentObject(self.dbHelper)
}
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
