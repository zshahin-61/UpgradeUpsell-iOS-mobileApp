//
//  HomeView.swift
//  UpgradeUpsell
//
//  Created by Created by Zahra Shahin - Golnaz Chehrazi .
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    @State private var selectedTab = 0
    
    @Binding var rootScreen: RootView
    
    
    var body: some View {
        TabView() {
            ProjectListView()
                .tabItem {
                    Label("View Projects", systemImage: "list.bullet.rectangle")
                    Text("View Projects")
                }
            
            ProjectAddView()
                .tabItem {
                    Label("Add Property", systemImage: "plus.circle")
                    Text("Add Property")
                }
            
            ProjectOffersView()
                .tabItem {
                    Label("View Offers", systemImage: "gift")
                    Text("View Offers")
                }
            NotificationView()
                .tabItem {
                    Label("Notifications", systemImage: "bell")
                    Text("Notifications")
                    
                }
            
            
            
            
            //                .onAppear {
            //                    UITabBar.appearance().isHidden = true // Hide the system tab bar
        }
        .navigationBarTitle("Owner Dashboard", displayMode: .inline)
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
                //Image(systemName: "ellipsis.circle.fill")
                //Image(systemName: "list.bullet.rectangle.portrait.fill")
                Image(systemName: "filemenu.and.cursorarrow")
            }//Menu
        })//navigationBarItems
    }
}
