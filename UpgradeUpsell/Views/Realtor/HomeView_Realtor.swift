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
         
//                        EventsListView().environmentObject(locationHelper)

            ProjectListView()
            .tabItem {
                Label("View Projects", systemImage: "list.bullet.rectangle")
                Text("View Projects")
            }
            
            ProjectViewEdit()
            .tabItem {
                Label("Add Property", systemImage: "plus.circle")
                Text("Add Property")
            }
            
            ProjectOffersView()
            .tabItem {
                Label("View Offers", systemImage: "gift")
                Text("View Offers")
            }
        
            Text("Notifications")
                .tabItem {
                    Label("Notifications", systemImage: "bell")
                }

            
            
            //                .onAppear {
            //                    UITabBar.appearance().isHidden = true // Hide the system tab bar
        }
        .navigationBarTitle("Realtor Dashboard", displayMode: .inline)
        .navigationBarItems(trailing: HStack {
            Button(action: {
                self.authHelper.signOut()
                rootScreen = .Login
            }) {
                //Image(systemName: "lock.circle.fill")
                Image(systemName: "lock.circle.fill")
            }
            
            NavigationLink(destination: ProfileView(rootScreen: $rootScreen).environmentObject(self.authHelper).environmentObject(self.dbHelper)) {
                Label("Profile", systemImage: "person.circle.fill")
            }
            
            NavigationLink(destination: SettingsView(rootScreen: $rootScreen, backRoot: .RealtorHome).environmentObject(self.authHelper).environmentObject(self.dbHelper)) {
                Image(systemName: "gearshape.fill")
            }
        })
    }
}

