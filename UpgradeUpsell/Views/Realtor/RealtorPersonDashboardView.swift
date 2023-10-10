//
//  RealtorPersonDashboardView.swift
//  UpgradeUpsell
//
//  Created by Created by Zahra Shahin - Golnaz Chehrazi .
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

