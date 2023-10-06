//
//  HomeView_Investor.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-10-04.
//

import SwiftUI

struct HomeView_Investor: View {
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    @State private var selectedTab = 0
    
    @Binding var rootScreen: RootView
    
    //let userName = "Golnaz"
    //let userFamily = "Cherazi"
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                NavigationLink(destination: CreateProjectView()) {
                    Text("Projects")
                }
                .tabItem {
                    Label("Projects", systemImage: "plus.circle")
                }
                .tag(0)
                
                NavigationLink(destination: ProjectListView()) {
                    Text("Saved Projects")
                }
                .tabItem {
                    Label("Saved Projects", systemImage: "list.bullet.rectangle")
                }
                .tag(1)
                
                NavigationLink(destination: ProjectOffersView()) {
                    Text("My Offers")
                }
                .tabItem {
                    Label("My Offers", systemImage: "gift")
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
        .navigationBarTitle("Investor Dashboard", displayMode: .inline)
        .navigationBarItems(trailing: HStack {
            Button(action: {
                self.authHelper.signOut()
                rootScreen = .Login
            }) {
                //Image(systemName: "lock.circle.fill")
                Image(systemName: "lock.shield.fill")
            }
            
            NavigationLink(destination: ProfileView()) {
                Image(systemName: "person.circle.fill")
            }
            
            NavigationLink(destination: SettingsView()) {
                Image(systemName: "gearshape.fill")
            }
        })
    }
}
