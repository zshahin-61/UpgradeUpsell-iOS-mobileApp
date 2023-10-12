//
//  ProjectDetailView.swift
//  UpgradeUpsell
//
//  Created by zahra SHAHIN on 2023-10-12.
//

import SwiftUI


struct DetailView: View {
    
    let selectedProject: RenovateProject 
    
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var lng  = ""
    @State private var lat = ""
    @State private var category = ""
    @State private var selectedCategory = ""
    @State private var investmentNeeded = ""
    @State private var status = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var numberOfBedrooms = ""
    @State private var numberOfBathrooms = ""
    @State private var images: [Image] = []
    @State private var propertyType = ""
    @State private var squareFootage = " "
    @State private var isFurnished = false
    
    var body: some View {
        VStack {
            
            Group{
                Text("Titlle:").font(.subheadline).bold()
                
                TextField(selectedProject.title, text: self.$title).textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                
                
                //                Text("Description:").font(.subheadline).bold()
                //                TextField(selectedProject.description, text: self.$description)
                //                    .frame(minHeight: 100)
                //                    .cornerRadius(5)
                //                    .border(Color.gray, width: 0.5)
            }
            Group{
                
                Text("Description: \(selectedProject.description)")
                Text("Location: \(selectedProject.location)")
                Text("Category: \(selectedProject.category)")
                Text("Number of Bedrooms: \(selectedProject.numberOfBedrooms)")
                Text("Number of Bathrooms: \(selectedProject.numberOfBathrooms)")
                
                Text("Is Furnished: \(selectedProject.isFurnished ? "Yes" : "No")")
                Text("Square Footage: \(selectedProject.squareFootage)")
                
                if let imageData = selectedProject.images, let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                }
            }
            .navigationBarTitle("Project Detail")
        }
    }
}
