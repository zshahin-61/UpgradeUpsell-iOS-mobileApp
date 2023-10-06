//
//  HomeView_Realtor.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-10-04.
//

import SwiftUI

struct HomeView_Realtor: View {
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    @State private var selectedTab = 0
    
    @Binding var rootScreen: RootView 
    
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                NavigationLink(destination: CreateProjectView()) {
                    Text("List of Selling Properties")
                }
                .tabItem {
                    Label("List of Selling Properties", systemImage: "plus.circle")
                }
                .tag(0)
                
                NavigationLink(destination: ProjectListView()) {
                    Text("Saved Properties")
                }
                .tabItem {
                    Label("Saved Properties", systemImage: "list.bullet.rectangle")
                }
                .tag(1)
                
                NavigationLink(destination: ProjectOffersView()) {
                    Text("Offers")
                }
                .tabItem {
                    Label("Offers", systemImage: "gift")
                }
                .tag(2)
                
                Text("Notifications")
                    .tabItem {
                        Label("Notifications", systemImage: "bell")
                    }
                    .tag(3)
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
                Image(systemName: "person.circle.fill")
            }
            
            NavigationLink(destination: SettingsView(rootScreen: $rootScreen).environmentObject(self.authHelper).environmentObject(self.dbHelper)) {
                Image(systemName: "gearshape.fill")
            }
        })
    }
}

