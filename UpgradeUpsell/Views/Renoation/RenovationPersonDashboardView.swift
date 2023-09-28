//
//  RenovationPersonDashboardView.swift
//  UpgradeUpsell
//
//  Created by zahra SHAHIN on 2023-09-21.
//

import SwiftUI

struct RenovationPersonDashboardView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ProjectListForRenovationView()) {
                    Text("View Renovation Projects")
                }
                Text("Submit Project Offers")
                Text("Notifications")
            }
            .navigationTitle("Renovation Person Dashboard")
        }
    }
}

struct ProjectListForRenovationView: View {
    var body: some View {
        Text("List of Renovation Projects")
    }
}

