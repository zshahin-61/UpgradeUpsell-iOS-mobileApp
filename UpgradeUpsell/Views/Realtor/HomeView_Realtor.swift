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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}


