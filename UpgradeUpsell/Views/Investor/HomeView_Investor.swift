//
//  HomeView_Investor.swift
//  UpgradeUpsell
//
//  Created by Created by Zahra Shahin - Golnaz Chehrazi .
//

import SwiftUI

struct HomeView_Investor: View {
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    @State private var selectedTab = 0
    
    @Binding var rootScreen: RootView
    
    var body: some View {
        TabView() {
         
//                        EventsListView().environmentObject(locationHelper)

            ProjectsList_InvestorView()
            .tabItem {
                Label("View Projects", systemImage: "list.bullet.rectangle")
                Text("View Projects")
            }
            
//            MakeOffers_InvestorView(project: nil)
//            .tabItem {
//                Label("Make Offer", systemImage: "plus.circle")
//                Text("Make Offer")
//            }
            
            MyOffersView()
            .tabItem {
                Label("My Offers", systemImage: "gift")
                Text("My Offers")
            }
            
            NotificationView()
                .tabItem {
                    Label("Notifications", systemImage: "bell")
                    Text("Notifications")
                }

            
            
            //                .onAppear {
            //                    UITabBar.appearance().isHidden = true // Hide the system tab bar
        }
        .navigationBarTitle("Investor Dashboard", displayMode: .inline)
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
