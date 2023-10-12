//
//  ProjectDetailView.swift
//  UpgradeUpsell
//
//  Created by zahra SHAHIN on 2023-10-12.
//

import SwiftUI


struct DetailView: View {
    
    let selectedProject: RenovateProject // Replace with your project model

    var body: some View {
        VStack {
            
            
            
            Text("Title: \(selectedProject.title)")
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
