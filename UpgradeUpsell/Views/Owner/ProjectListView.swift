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
    @State private var showDeleteAlert = false
    @State private var selectedOffsets: IndexSet?
    
    var body: some View {
        VStack {
            Text("My Properties").bold().font(.title).foregroundColor(.brown)
            if userProjects.isEmpty {
                Text("No properties found.")
            } else {
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
                    //                    .onDelete(perform: deleteProjects)
                    .onDelete { indexSet in
                        
                        let selectedProjects = indexSet.map { userProjects[$0] }

                            guard selectedProjects.allSatisfy({ $0.status.lowercased() != "in progress" }) else {
                                // Show an alert to inform the user that a project with "In Progress" status cannot be deleted
                                showAlert(message: "Cannot delete a project with 'In Progress' status.")
                                return
                            }
                        
                        selectedOffsets = indexSet
                        showDeleteAlert = true
                    }
                }
                
                
                //            .padding(.horizontal, 10)
            }
            
        }
        .alert(isPresented: $showDeleteAlert) {
                   Alert(
                       title: Text("Confirm Deletion"),
                       message: Text("Are you sure you want to delete this property?"),
                       primaryButton: .destructive(Text("Delete")) {
                           deleteProjects()
                       },
                       secondaryButton: .cancel()
                   )
               }
        .onAppear {
            loadProjects()
        }
        .padding(.top, 10)
//        .navigationBarTitle("List My Properties")//VStack
    }
    
    //load projects
    private func loadProjects(){
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
    
 //Add status Delete
    private func deleteProjects() {
            if let selectedOffsets = selectedOffsets {
                for offset in selectedOffsets {
                    let project = userProjects[offset]

                    dbHelper.updateProjectStatus(project) { success in
                        if success {
                            loadProjects()
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
        }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Cannot Delete Project", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Assuming you are using SwiftUI within a UIKit environment (e.g., UIViewControllerRepresentable)
        // If you are using SwiftUI's Alert, you can modify the code accordingly
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
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
