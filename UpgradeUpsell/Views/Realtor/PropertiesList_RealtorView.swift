//
//  PropertiesList_RealtorView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-30.
//

import SwiftUI

struct PropertiesList_RealtorView: View {
    @EnvironmentObject var dbHelper: FirestoreController
    @EnvironmentObject var authHelper: FireAuthController
    @State private var prjList: [RenovateProject] = []
    @State private var filteredProjects: [RenovateProject] = []
    @State private var isLoading: Bool = false
    @State private var searchText = ""
    
    var body: some View {
        VStack{
            Text("In Progress Property List").bold().font(.title).foregroundColor(.brown)
            SearchBar(text: $searchText, placeholder: "Search by title")
            List(self.filteredProjects) { prj in
                NavigationLink(destination: PropertyDetails_RealtorView(project: prj).environmentObject(dbHelper).environmentObject(authHelper)) {
                    ProjectListItemView(project: prj)
                }
            }
        }
        //.navigationTitle("Renovation Projects")
        .onAppear {
            // Fetch investment suggestions when the view appears.
            loadProjects()
        }
        .onChange(of: searchText) { _ in
            filterProjects()
        }
    }
    
    private func loadProjects(){
        if let role = dbHelper.userProfile?.role {
            if(role == "Realtor"){
                self.isLoading = true
                self.dbHelper.listenForRenovateProjects_InProgress() { (renovateProjects, error) in
                    self.isLoading = false
                    if let error = error {
#if DEBUG
                        print("Error getting investment suggestions: \(error)")
                        #endif
                    } else if let projectList = renovateProjects {
                        self.prjList = projectList
                        filterProjects()
                        
                    }
                }
            }
        }
    }
    
    private func filterProjects(){
        if searchText.isEmpty{
            self.filteredProjects = self.prjList
        }
        else{
            self.filteredProjects = self.prjList.filter {
                $0.title.localizedCaseInsensitiveContains(searchText.lowercased())
            }
        }
        self.filteredProjects.sort(by: { $0.createdDate   > $1.createdDate  })
    }
    
}

//struct ProjectListItemView: View {
//    let project: RenovateProject
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text(project.title)
//                .font(.headline)
//            Text("\(project.category), \(Text(project.location))")
//                .font(.subheadline)
//            
//        }
//    }
//}

