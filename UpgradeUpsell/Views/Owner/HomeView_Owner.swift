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
                
                CreateProjectView()
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
        .navigationBarTitle("Owner Dashboard", displayMode: .inline)
        .navigationBarItems(trailing: HStack {
            Button(action: {
                self.authHelper.signOut()
                rootScreen = .Login
            }) {
                //Text("Signout")
                //Image(systemName: "lock.circle.fill")
                Image(systemName: "lock.shield.fill")
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
    

