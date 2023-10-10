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
    
    var body: some View {
        NavigationView {
            List(userProjects) { property in
                NavigationLink(destination: CreateProjectView()) {
                    Text(property.title)
                }
            }
            .onAppear {
                if let userID = authHelper.user?.uid {
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
        }
    }
}

struct PropertyDetailView: View {
    var property: RenovateProject
    
    var body: some View {
        // Display property details here using the 'property' variable
        Text("Property Title: \(property.title)")
        // Add more property details as needed
    }
}

struct ProjectListView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListView()
    }
}
