//
//  RealtorPersonDashboardView.swift
//  UpgradeUpsell
//
//  Created by zahra SHAHIN on 2023-09-21.
//

import SwiftUI


struct RealtorPersonDashboardView: View {
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

struct PropertyListForRealtorView: View {
    var body: some View {
        Text("List of Properties for Sale")
    }
}

