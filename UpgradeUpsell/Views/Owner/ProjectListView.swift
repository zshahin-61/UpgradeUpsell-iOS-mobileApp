//
//  ProjectOffersView.swift
//  UpgradeUpsell
//
//  Created by Created by Zahra Shahin.
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
            List {
                ForEach(userProjects) { property in
                    NavigationLink(destination: ProjectViewEdit(selectedProject: property)
                        .environmentObject(authHelper)
                        .environmentObject(self.dbHelper)) {
                            Text(property.title)
                        }
                }
                .onDelete(perform: deleteProjects)
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
            .navigationBarTitle("MyProperties")
            .padding()
        }
        .background(Color.red)
    }
 //Add status Delete
    private func deleteProjects(at offsets: IndexSet) {
        for offset in offsets {
            let project = userProjects[offset]
           // userProjects[offset].status = "deleted"
                  
            dbHelper.updateProjectStatus(project) { success in
                if success {
                    print("Project status updated to 'deleted' successfully.")
                } else {
                    print("Error updating project status.")
                }
            }
        }
    }

    
    
    //REALLY DELETED RECORD
//    private func deleteProjects(at offsets: IndexSet) {
//        for offset in offsets {
//            let project = userProjects[offset]
//
//
//
//            dbHelper.deleteProperty(project) { success in
//                if success {
//                    print("Project deleted successfully.")
//                    userProjects.remove(at: offset)
//                } else {
//                    print("Error deleting project.")
//                }
//            }
//        }
//    }
}
