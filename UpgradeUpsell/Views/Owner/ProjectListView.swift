//
//  ProjectOffersView.swift
//  UpgradeUpsell
//
//  Created by Created by Zahra Shahin on 2023-10-10.
//

import SwiftUI
import Firebase

struct ProjectListView: View {
    @EnvironmentObject var dbHelper: FirestoreController
    @EnvironmentObject var authHelper: FireAuthController
    
    @State private var userProjects: [RenovateProject] = []
    @State private var selectedProject: RenovateProject?
    @State private var isShowingPicker = false
    
    var body: some View {
        VStack {
            Text("My Properties").bold().font(.title).foregroundColor(.brown)
                List {
                    ForEach(userProjects) { property in
                        //VStack{
                        NavigationLink(destination: ProjectViewEdit(selectedProject: property)
                            .environmentObject(authHelper)
                            .environmentObject(self.dbHelper)) {
                                HStack{
                                    Text(property.title)
                                    Spacer()
                                    Text(property.status).font(.caption)
                                }
                            }
//                        HStack{
//                            Spacer()
//                            
//                            NavigationLink(destination: OffersofaPropertyView(selectedProperty: property)
//                                .environmentObject(authHelper)
//                                .environmentObject(self.dbHelper)) {
//                                    Text("See Offers")
//                                        .foregroundColor(.blue)
//                                }
//                                .padding(.leading, 100)
//                            
//                            
//                        }
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
#if DEBUG
                                print("Error fetching user projects: \(error.localizedDescription)")
                                #endif
                            }
                        }
                    }
                }
                //            .padding(.horizontal, 10)
            
        }
        .padding(.top, 10)
//        .navigationBarTitle("List My Properties")//VStack
    }
 //Add status Delete
    private func deleteProjects(at offsets: IndexSet) {
        for offset in offsets {
            let project = userProjects[offset]
           // userProjects[offset].status = "deleted"
                  
            dbHelper.updateProjectStatus(project) { success in
                if success {
#if DEBUG
                    print("Project status updated to 'deleted' successfully.")
                    #endif
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
#if DEBUG
                       print("Notification inserted successfully.")
                       #endif
                   } else {
#if DEBUG
                       print("Error inserting notification.")
                       #endif
                   }
               }
                    
                } else {
#if DEBUG
                    print("Error updating project status.")
                    #endif
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
