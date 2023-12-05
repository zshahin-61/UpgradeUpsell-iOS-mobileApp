//
//  HomeView_Realtor.swift
//  UpgradeUpsell
//
//  Created by Created by Zahra Shahin - Golnaz Chehrazi .
//

import SwiftUI

struct HomeView_Realtor: View {
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    @State private var selectedTab = 0
    
    @Binding var rootScreen: RootView 

    
    var body: some View {
        TabView() {
         
            PropertiesList_RealtorView()
            .tabItem {
                Label("View Projects", systemImage: "list.bullet.rectangle")
                //Text("View Projects")
            }
            
            NotificationRealtorView()
            //Text("Notificationssss")
            .tabItem {
                    Label("Notifications", systemImage: "bell")
                }
        }
        .navigationBarTitle("Realtor Dashboard", displayMode: .inline)
        .navigationBarItems(trailing: HStack {
            Menu{
                
                Button(action: {
                    rootScreen = .Profile
                }) {
                    Label("Profile", systemImage: "person.circle.fill")
                }
                
//                Button(action: {
//                    rootScreen = .Settings
//                }) {
//                    Label("Settings", systemImage: "gearshape.fill")
//                }
                
                Button(action: {
                    rootScreen = .ChangePassword
                }) {
                    Label("Change password", systemImage: "key.fill")
                }
                
                Button(action: {
                    self.authHelper.signOut()
                    rootScreen = .Login
                }) {
                    Label("Signout", systemImage: "lock.shield.fill")
                }
            } label: {
                Image(systemName: "ellipsis.circle.fill")
            }//Menu
        })//navigationBarItems
    }
}
 
