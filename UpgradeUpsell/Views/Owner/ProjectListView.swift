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
            //Text("My Properties")
            List {
                ForEach(userProjects) { property in
                    //VStack{
                        NavigationLink(destination: ProjectViewEdit(selectedProject: property)
                            .environmentObject(authHelper)
                            .environmentObject(self.dbHelper)) {
                                Text(property.title)
                            }
                        HStack{
                            Spacer()
                           
                                NavigationLink(destination: OffersofaPropertyView(selectedProperty: property)
                                    .environmentObject(authHelper)
                                    .environmentObject(self.dbHelper)) {
                                        Text("See Offers")
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.leading, 100)
                            
                            
                        }
                    //}
                }
                .onDelete(perform: deleteProjects)
            }
            .onAppear {
                if let userID = self.dbHelper.userProfile?.id {
                    dbHelper.getUserProjectsWithStatus(userID: userID) { projects, error in
                        if let projects = projects {
                            self.userProjects = projects
                        } else if let error = error {
                            // Handle the error
                            print("Error fetching user projects: \(error.localizedDescription)")
                        }
                    }
                }
            }
            .navigationBarTitle("My Properties")
            .padding(.horizontal, 10)
        }
//        .background(Color.red)
        .padding(.horizontal, 10)
    }
 //Add status Delete
    private func deleteProjects(at offsets: IndexSet) {
        for offset in offsets {
            let project = userProjects[offset]
           // userProjects[offset].status = "deleted"
                  
            dbHelper.updateProjectStatus(project) { success in
                if success {
                    print("Project status updated to 'deleted' successfully.")
                    // Insert a notification in Firebase
               let notification = Notifications(
                id: UUID().uuidString,
                   timestamp: Date(),
                userID: project.ownerID,
                   event: "Project Deactive",
                details: "Project titled '\(project.title)' has been deleted By \(dbHelper.userProfile?.fullName).",
                   isRead: false,
                projectID: project.id!
               )

               dbHelper.insertNotification(notification) { notificationSuccess in
                   if notificationSuccess {
                       print("Notification inserted successfully.")
                   } else {
                       print("Error inserting notification.")
                   }
               }
                    
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
