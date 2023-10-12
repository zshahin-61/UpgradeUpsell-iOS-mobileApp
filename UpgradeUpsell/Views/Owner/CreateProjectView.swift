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
                        
                        VStack {
                            Text("Title").bold()
                            Spacer()
                            TextField("", text: $title).textInputAutocapitalization(.never)
                                .textFieldStyle(.roundedBorder)
                         
                        }
                        VStack {
                            Text("Description").bold()
                            Spacer()
                            TextEditor(text: $description)
                                .frame(minHeight: 70)
                                .cornerRadius(5)
                                .border(Color.gray, width: 0.5)
                            
                        }
                        VStack {
                            
                            Text("Address ").bold()
                            Spacer()
                            TextEditor(text: $location)
                                .frame(minWidth: 10, minHeight: 50)
                                .cornerRadius(5)
                                .border(Color.gray, width: 0.5)
                        }
//                        HStack{
//                            // google map
//
//                            Text("Location    ").font(.subheadline)
//                            Spacer()
//                        }
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
                            Text("Category").bold()
                            Spacer()
                            Picker("", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) { category in
                                    Text(category)
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
                        
                        VStack {
                            Text("Number of Bedrooms").bold()
                            Spacer()
                            Stepper("\(numberOfBedrooms)", value: $numberOfBedrooms, in: 0...10)
                            
                        }
                        
                        VStack {
                            Text("Number of Bathrooms:").bold()
                            Spacer()
                            Stepper("\(numberOfBathrooms)", value: $numberOfBathrooms, in: 0...10)

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
                                            .clipShape(Rectangle())
                                    }
                                    else{
                                        //
                                    }
                                }
                                VStack{
                                    
                                    Text("Upload Images").font(.subheadline)
                 
                                    
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
                        
                        
                        VStack {
                            Text("Square Footage").bold()
                            Spacer()
                        
                            TextField("", value: $squareFootage, formatter: NumberFormatter())
                        }
                        
                        HStack {
                            
                            Toggle("Is Furnished", isOn: $isFurnished)
                        }
                        VStack{
                            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                            Spacer()

                            DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                        }
                        
                    }
                    Button(action: {
                        
                        guard let userID = dbHelper.userProfile?.id else {
                            return
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
                                                if let project = selectedProject {
                                                        // Update an existing project
                                                        dbHelper.updateProperty(updatedProperty) { success in
                                                            if success {
                                                                presentationMode.wrappedValue.dismiss()
                                                                resetFormFields()
                                                            } else {
                                                                // Handle error
                                                            }
                                                        }
                                                } else {}
//                        if title.isEmpty || description.isEmpty || location.isEmpty || status.isEmpty {
//                            showAlert = true
//                            return
//                        }
                      
                        //Image
                        var imageData :Data? = nil
                        
                        if(selectedImage != nil )
                        {
                            let image = selectedImage!
                            let imageName = "\(UUID().uuidString).jpg"
                            print(imageName)
                            imageData = image.jpegData(compressionQuality: 0.1)
                        }
                        
                       
                        
//                        let newProperty = RenovateProject(
//                            projectID: UUID().uuidString,
//                            title: title,
//                            description: description,
//                            location: location,
//                            lng: lng,
//                            lat: lat,
//                            images: imageData,
//                            ownerID: userID,
//                            category: selectedCategory,
//                            investmentNeeded: investmentNeeded,
//                            selectedInvestmentSuggestionID: "",
//                            status: status,
//                            startDate: startDate,
//                            endDate: endDate,
//                            numberOfBedrooms: numberOfBedrooms,
//                            numberOfBathrooms: numberOfBathrooms,
//                            propertyType: propertyType,
//                            squareFootage: squareFootage,
//                            isFurnished: isFurnished,
//                            createdDate: Date(),
//                            updatedDate: Date(),
//                            favoriteCount: 0,
//                            realtorID: ""
//                        )
                        
                        dbHelper.addProperty(updatedProperty, userID: userID) { success in
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
                .onAppear(){
                    
                    if let currentProject = selectedProject {
                        self.title = currentProject.title
                        self.description = currentProject.description
                        self.selectedCategory = currentProject.category
                        self.location = currentProject.location
                        self.lng = currentProject.lng
                        self.lat = currentProject.lat
                        self.investmentNeeded = currentProject.investmentNeeded
                        self.status = currentProject.status
                        self.startDate = currentProject.startDate
                        self.endDate = currentProject.endDate
                        self.numberOfBedrooms = currentProject.numberOfBedrooms
                        self.numberOfBathrooms = currentProject.numberOfBathrooms
                        self.propertyType = currentProject.propertyType
                        self.squareFootage = currentProject.squareFootage
                        self.isFurnished = currentProject.isFurnished
                        
                
//                                                    self.errorMsg = nil
                        
                        // MARK: Show image from db
                        if let imageData = currentProject.images as? Data {
                            self.imageData = imageData
                        } else {
                            print("Invalid image data format")
                        }
                    }
                }
                
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

