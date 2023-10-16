//
//  ProjectOffersView.swift
//  UpgradeUpsell
//
//  Created by Created by Zahra Shahin - Golnaz Chehrazi .
//

import SwiftUI
import Firebase

struct ProjectListView: View {
    @EnvironmentObject var dbHelper: FirestoreController
    @EnvironmentObject var authHelper: FireAuthController

    @State private var userProjects: [RenovateProject] = []
    @State private var selectedProject: RenovateProject?

    var body: some View {
        NavigationView {


            List(userProjects) { property in
                NavigationLink(destination: ProjectViewEdit(selectedProject: property).environmentObject(authHelper).environmentObject(self.dbHelper)) {
                    Text(property.title)
                }
            }

            .onAppear {
                if let userID = self.dbHelper.userProfile?.id {
                    dbHelper.getUserProjects(userID: userID) { projects, error in
                        if let projects = projects {
                            self.userProjects = projects
                        } else if let error = error {
                            // Handle the error
                            print("Error fetching user projects: \(error.localizedDescription)")
                        }
                    }
                }
            }
            .navigationBarTitle("Your Properties")
            .padding()

        }//Navview
        .background(Color.red)

    }
}

