//
//  HomeView_Admin.swift
//  UpgradeUpsell
//
//  Created by zahra SHAHIN on 2023-10-31.
//

import SwiftUI
import Foundation

struct HomeView_Admin: View {
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    @State private var selectedTab = 0
    
    @Binding var rootScreen: RootView

//    func generateUUID() -> String {
//                return UUID().uuidString
//            }
    
    
    var body: some View {

        //----------

        //let generatedUUID = generateUUID()
        //Text("Generated UUID: \(generatedUUID)")
        //-------
        TabView() {
         
            UsersView() 
                  .tabItem {
                      Label("View Users", systemImage: "person.2.fill")
                      Text("View Users")
                  }
            ReportView()
                .tabItem {
                    Label("View Report", systemImage: "chart.bar.fill")
                    Text("View Report")
                }

        
            NotificationView()
                .tabItem {
                    Label("Notifications", systemImage: "bell")
                    Text("Notifications")
                    
                }

            
            
            //                .onAppear {
            //                    UITabBar.appearance().isHidden = true // Hide the system tab bar
        }
        .navigationBarTitle("Admin Dashboard", displayMode: .inline)
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

