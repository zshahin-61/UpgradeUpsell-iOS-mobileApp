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
            VStack {
                NavigationLink(destination: PropertyListForRealtorView()) {
                    Text("View Properties for Sale")
                }
                Text("Submit Purchase Offers")
                Text("Notifications")
            }
            .navigationTitle("Realtor Person Dashboard")
        }
    }
}

