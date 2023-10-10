//
//  ViewProjects_Investor.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-10-10.
//

import SwiftUI

struct ProjectsList_InvestorView: View {
    @EnvironmentObject var dbHelper: FirestoreController

    var body: some View {
Text("salam")
        //        List(dbHelper.projects) { project in
//            NavigationLink(destination: ProjectDetailView(project: project)) {
//                ProjectListItemView(project: project)
//            }
//        }
//        .navigationTitle("Renovation Projects")
//        .onAppear {
//            // Fetch renovation projects from Firestore when the view appears.
//            dbHelper.fetchRenovationProjects()
//        }
    }
}

struct ProjectListItemView: View {
    let project: RenovateProject

    var body: some View {
        VStack(alignment: .leading) {
            Text(project.title)
                .font(.headline)
            Text(project.location)
                .font(.subheadline)
            // Add any other project details you want to display
        }
    }
}

struct ProjectDetailView: View {
    let project: RenovateProject

    var body: some View {
        VStack {
            Text(project.title)
                .font(.title)
            Text(project.description)
                .font(.body)
            // Add more project details and UI components as needed
        }
        .navigationTitle(project.title)
    }
}

