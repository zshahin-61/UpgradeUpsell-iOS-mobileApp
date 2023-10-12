//
//  CreateProjectView.swift
//  UpgradeUpsell
//
//  Created by Created by Zahra Shahin.
//
import SwiftUI
import Firebase
import MapKit

struct CreateProjectView: View {
    @EnvironmentObject var dbHelper: FirestoreController
    @EnvironmentObject var authHelper: FireAuthController
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var photoLibraryManager = PhotoLibraryManager()
    @State private var isShowingPicker = false
    @State private var selectedImage: UIImage?
    @State private var imageData: Data?
    
    
    
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var lng: Double = 0.0
    @State private var lat: Double = 0.0
    @State private var category = ""
    @State private var selectedCategory = "Residential"
    @State private var investmentNeeded: Double = 0.0
    @State private var status = "Released"
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var numberOfBedrooms = 0
    @State private var numberOfBathrooms = 0
    @State private var images: [Image] = []
    @State private var propertyType = ""
    @State private var squareFootage: Double = 0.0
    @State private var isFurnished = false
    
    @State private var showAlert = false
    
      var selectedProject: RenovateProject?
    
    @EnvironmentObject var locationHelper: LocationHelper
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    
    private let categories = [
        "Residential",
        "Condo",
        "Townhouse",
        "Apartment",
        "Office Space",
        "Retail Space",
        "Warehouse",
        "House",
        "Other"
    ]
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Section(header: Text("Property Information").font(.headline)) {
                        
                        HStack {
                            Text("Title").font(.subheadline).bold()
                            Spacer()
                            if let project = selectedProject {
                                TextField(project.title, text: self.$title).textInputAutocapitalization(.never)
                                    .textFieldStyle(.roundedBorder)
                            } else {
                                TextField("", text: $title).textInputAutocapitalization(.never)
                                    .textFieldStyle(.roundedBorder)
                            }
                        }
                        HStack {
                            Text("Description").font(.subheadline)
                            Spacer()
                            if let project = selectedProject {
                                TextField(project.description, text: $description)
                                           .frame(minHeight: 100)
                                           .cornerRadius(5)
                                           .border(Color.gray, width: 0.5)
                            } else {
                                // If selectedProject is nil,
                                TextEditor(text: $description)
                                    .frame(minHeight: 100)
                                    .cornerRadius(5)
                                    .border(Color.gray, width: 0.5)
                            }
                            
                           
                        }
                        HStack {
                            Text("Location    ").font(.subheadline)
                            Spacer()
                            
                            if let project = selectedProject {
                                TextField(project.location, text: $location)
                                           .frame(minHeight: 50)
                                           .cornerRadius(5)
                                           .border(Color.gray, width: 0.5)
                            } else {
                                TextEditor(text: $location)
                                    .frame(minHeight: 50)
                                    .cornerRadius(5)
                                    .border(Color.gray, width: 0.5)
                            }
                            
                           
                        }
                        // HStack {
                        //                            Text("Longitude").font(.subheadline)
                        //                            Spacer()
                        //                            TextField("", value: $lng, formatter: NumberFormatter())
                        //                        }
                        //
                        //                        HStack {
                        //                            Text("Latitude").font(.subheadline)
                        //                            Spacer()
                        //                            TextField("", value: $lat, formatter: NumberFormatter())
                        //                        }
                        
                            //HStack {
//                            Text("Category").font(.subheadline)
//                            Spacer()
//                            Picker("", selection: $selectedCategory) {
//                                ForEach(categories, id: \.self) { category in
//                                    Text(category)
//                                }
//                            }
//                        }
                        HStack {
                            Text("Category").font(.subheadline)
                            Spacer()
                            if let project = selectedProject {
                              
                         Text(selectedProject?.category ?? "No Category")
                            }
                            else{
                                Picker("", selection: $selectedCategory) {
                                    ForEach(categories, id: \.self) { category in
                                        Text(category)
                                    }
                                }
                            }
                        }

                        
                        //                        HStack {
                        //                            Text("Investment Needed").font(.subheadline)
                        //                            Spacer()
                        //                            TextField("", value: $investmentNeeded, formatter: NumberFormatter())
                        //                        }
                        
//                        HStack {
//                            Text("Status")
//                            Spacer()
//                            TextField("", text: $status)        .font(Font.custom("Helvetica Neue", size: 16).bold().italic())
//
//                        }
                       
                        HStack {
                            Text("Number of Bedrooms").font(.subheadline).bold()
                            Spacer()
                            
                            if let project = selectedProject {
                                TextField(String(project.numberOfBedrooms), value: $numberOfBedrooms, formatter: NumberFormatter())
                                    .textFieldStyle(.roundedBorder)
                               
                            } else {
                                Stepper("\(numberOfBedrooms)", value: $numberOfBedrooms, in: 0...10)
                            }
                          
                        }
                        
            
                           
                        
                        HStack {
                            Text("Number of Bathrooms:").font(.subheadline).bold()
                            Spacer()
                            
                            if let project = selectedProject {
                                TextField(String(project.numberOfBathrooms), value: $numberOfBathrooms, formatter: NumberFormatter())
                                    .textFieldStyle(.roundedBorder)
                            }  else {
                                Stepper("\(numberOfBathrooms)", value: $numberOfBathrooms, in: 0...10)
                            }
                        }
                        
                        //Image
                        VStack(alignment: .leading,spacing: 10){
                            
                            HStack{
                                if let data = imageData,
                                   let uiImage = UIImage(data: data) {
                                    if(selectedImage == nil)
                                    {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .frame(width: 150, height: 150)
                                            .clipShape(Circle())
                                    }
                                    else{
                                        //
                                    }
                                }
                                VStack{
                                    
                                    Text("Upload Images").font(.subheadline)
                                    
                                    if let project = selectedProject {
                                        if let imageData = project.images, let image = UIImage(data: imageData) {
                                            Image(uiImage: image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 150, height: 150)
                                        }
                                    }
                                    else{
                                        //
                                    }
                                    
                                    if photoLibraryManager.isAuthorized {
                                        //HStack{
                                        if let image = selectedImage {
                                            Image(uiImage: image)
                                                .resizable()
                                                .frame(width: 150, height: 150)
                                                .clipShape(Rectangle())
                                        }
                                        Button(action: {
                                            
                                            isShowingPicker = true
                                        }) {
                                            Text("Change Picture")
                                        }
                                        //}//Hstack
                                    } else {
                                        Button(action: {
                                            photoLibraryManager.requestPermission()
                                        }) {
                                            Text("Request Access For Photo Library")
                                        }
                                    }
                                }
                                .sheet(isPresented: $isShowingPicker) {
                                    if photoLibraryManager.isAuthorized {
                                        ImagePickerView(selectedImage: $selectedImage)
                                    } else {
                                        Text("Access to photo library is not authorized.")
                                    }
                                }
                            }
                        }
                        
                        
                        //                        HStack {
                        //                            Text("Property Type").font(.subheadline)
                        //                            Spacer()
                        //                            TextField("", text: $propertyType)
                        //                        }
                        
                        HStack {
                            Text("Square Footage").font(.subheadline).bold()
                            Spacer()
                            if let project = selectedProject {
                                TextField(String(project.squareFootage), value: $squareFootage, formatter: NumberFormatter())
                            } else {
                                TextField("", value: $squareFootage, formatter: NumberFormatter())
                            }
                        }

                        HStack {
                            if let project = selectedProject {
                                Toggle("Is Furnished", isOn: $isFurnished)
                                    .onAppear {
                                        isFurnished = project.isFurnished
                                    }
                            } else {
                                Toggle("Is Furnished", isOn: $isFurnished)
                            }
                        }

                        
                        //                    Section(header: Text("Dates").font(.headline)) {
                        //                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        //                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                        //                    }
                        
                    }
                    Button(action: {
                        
//                        if let project = selectedProject {
//                                // Update an existing project
//                                dbHelper.updateProperty(updatedProperty) { success in
//                                    if success {
//                                        presentationMode.wrappedValue.dismiss()
//                                        resetFormFields()
//                                    } else {
//                                        // Handle error
//                                    }
//                                }
//                        } else {}
                            if title.isEmpty || description.isEmpty || location.isEmpty || status.isEmpty {
                            showAlert = true
                            return
                        }
                        guard let userID = dbHelper.userProfile?.id else {
                            return
                        }
                        //Image
                        var imageData :Data? = nil
                        
                        if(selectedImage != nil )
                        {
                            let image = selectedImage!
                            let imageName = "\(UUID().uuidString).jpg"
                            print(imageName)
                            imageData = image.jpegData(compressionQuality: 0.1)
                        }
                        
                        let updatedProperty = RenovateProject(
                                projectID: selectedProject?.id ?? UUID().uuidString,
                                title: title,
                                description: description,
                                location: location,
                                lng: lng,
                                lat: lat,
                                images: imageData,
                                ownerID: userID,
                                category: selectedCategory,
                                investmentNeeded: investmentNeeded,
                                selectedInvestmentSuggestionID: selectedProject?.selectedInvestmentSuggestionID ?? "",
                                status: status,
                                startDate: startDate,
                                endDate: endDate,
                                numberOfBedrooms: numberOfBedrooms,
                                numberOfBathrooms: numberOfBathrooms,
                                propertyType: propertyType,
                                squareFootage: squareFootage,
                                isFurnished: isFurnished,
                                createdDate: selectedProject?.createdDate ?? Date(),
                                updatedDate: Date(),
                                favoriteCount: selectedProject?.favoriteCount ?? 0,
                                realtorID: selectedProject?.realtorID ?? ""
                            )
                        
                        let newProperty = RenovateProject(
                            projectID: UUID().uuidString,
                            title: title,
                            description: description,
                            location: location,
                            lng: lng,
                            lat: lat,
                            images: imageData,
                            ownerID: userID,
                            category: selectedCategory,
                            investmentNeeded: investmentNeeded,
                            selectedInvestmentSuggestionID: "",
                            status: status,
                            startDate: startDate,
                            endDate: endDate,
                            numberOfBedrooms: numberOfBedrooms,
                            numberOfBathrooms: numberOfBathrooms,
                            propertyType: propertyType,
                            squareFootage: squareFootage,
                            isFurnished: isFurnished,
                            createdDate: Date(),
                            updatedDate: Date(),
                            favoriteCount: 0,
                            realtorID: ""
                        )
                        
                        dbHelper.addProperty(newProperty, userID: userID) { success in
                            if success {
                                presentationMode.wrappedValue.dismiss()
                                resetFormFields()
                            } else {
                                // Handle error
                            }
                        }
                        
                    }) {
                            Text("Save")
                                .font(.headline)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 40)
                                .background(Color.brown)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Success"),
                                message: Text("Property saved successfully"),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    .padding()
                    
                }//VStack
            }//ScrollView
            
        }//NavigationView
    

        private func resetFormFields() {
            title = ""
            description = ""
            location = ""
            lng = 0.0
            lat = 0.0
            selectedCategory = "Residential"
            investmentNeeded = 0.0
            status = ""
            startDate = Date()
            endDate = Date()
            numberOfBedrooms = 0
            numberOfBathrooms = 0
            propertyType = ""
            squareFootage = 0.0
            isFurnished = false
        }
        
        
    
    
}

