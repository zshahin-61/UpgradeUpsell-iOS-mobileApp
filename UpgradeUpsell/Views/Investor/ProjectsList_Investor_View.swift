//
//  ViewProjects_Investor.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-10-10.
//

import SwiftUI

struct ProjectsList_InvestorView: View {
    @EnvironmentObject var dbHelper: FirestoreController
    @State private var prjList: [RenovateProject] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        List(prjList) { prj in
            NavigationLink(destination: ProjectDetailView(project: prj)) {
                ProjectListItemView(project: prj)
            }
        }
        .navigationTitle("Renovation Projects")
        .onAppear {
            // Fetch investment suggestions when the view appears.
            if let role = dbHelper.userProfile?.role {
                if(role == "Investor"){
                    self.isLoading = true
                    self.dbHelper.getRenovateProjectByStatus(status: "Released") { (renovateProjects, error) in
                        self.isLoading = false
                        if let error = error {
                            print("Error getting investment suggestions: \(error)")
                        } else if let projectList = renovateProjects {
                            self.prjList = projectList
                        }
                    }
                }
            }
        }
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

