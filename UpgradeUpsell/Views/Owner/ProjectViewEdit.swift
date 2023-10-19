//
//  CreateProjectView.swift
//  UpgradeUpsell
//
//  Created by Created by Zahra Shahin 2023-10-14.
//
import SwiftUI
import Firebase
import MapKit

struct ProjectViewEdit: View {
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
    
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    var selectedProject: RenovateProject?
    
    @EnvironmentObject var locationHelper: LocationHelper
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    
    // status: Delete show but deactive by owner be onwer and didnot show on the list | all offer will be decline
    
    private let categories = [
        "Residential",
        "Condo",
        "Bungalow",
        "Apartment",
        "Office Space",
        "Cottage or Cabin",
        "Beach House",
        "House",
        "Townhouse",
        "Other"
    ]
    
    
    var body: some View {
        VStack{
            Text("Property Details").bold().font(.title).foregroundColor(.brown)
            
            Form {
                //Section(header: Text("Property Details")) {
                Section{
                    VStack {
                        HStack {
                            Text("Title")
                                .bold()
                                .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
                            Spacer()
                        }
                        
                        TextEditor(text: $title)
                            .frame(minHeight: 70)
                            .cornerRadius(5)
                            .border(Color.gray, width: 0.2)
                        
                    }
                    VStack {
                        
                        HStack {
                            Text("Description")
                                .bold()
                                .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
                            
                            Spacer()
                        }
                        TextEditor(text: $description)
                            .frame(minHeight: 70)
                            .cornerRadius(5)
                            .border(Color.gray, width: 0.2)
                        
                    }
                    
                    VStack {
                        
                        HStack {
                            Text("Address")
                                .bold()
                                .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
                            
                            Spacer()
                        }
                        
                        TextEditor(text: $location)
                            .frame(minWidth: 10, minHeight: 50)
                            .cornerRadius(5)
                            .border(Color.gray, width: 0.2)
                    }
                    HStack {
                        Text("Category").bold()
                            .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
                        
                        Spacer()
                        Picker("", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                Text(category)
                            }
                        }
                    }
                    VStack {
                        HStack {
                            Text("Number of Bedrooms")
                                .bold()
                                .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
                            
                            Spacer()
                        }
                        
                        Stepper("\(numberOfBedrooms)", value: $numberOfBedrooms, in: 0...10)
                    }
                    VStack {
                        HStack {
                            Text("Number of Bathrooms")
                                .bold()
                                .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
                            
                            Spacer()
                        }
                        
                        Stepper("\(numberOfBathrooms)", value: $numberOfBathrooms, in: 0...10)
                    }
                    // Image
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            if let data = imageData, let uiImage = UIImage(data: data) {
                                if selectedImage == nil {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .frame(width: 150, height: 150)
                                        .clipShape(Rectangle())
                                } else {
                                    //
                                }
                            }
                            VStack {
                                Text("Upload Images").font(.subheadline)
                                if photoLibraryManager.isAuthorized {
                                    if let image = selectedImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 150, height: 150)
                                            .clipShape(Rectangle())
                                    }
                                    Button(action: {
                                        isShowingPicker = true
                                    }) {
                                        Text("Choose Picture")
                                    }
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
                        
                        HStack {
                            Text("Square Footage")
                                .bold()
                                .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
                            
                            Spacer()
                        }
                        
                        TextField("", value: $squareFootage, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .frame(minWidth: 10, minHeight: 50)
                            .cornerRadius(5)
                            .border(Color.gray, width: 0.2)
                        
                        
                    }
                    HStack {
                        Toggle("Is Furnished", isOn: $isFurnished)
                            .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
                            .bold()// Dark green color
                    }
                    VStack {
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                            .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
                            .bold()// Dark green color
                        Spacer()
                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                            .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
                            .bold()// Dark green color
                    }
                    
                }//section
            }//.padding(.top, 2)//form
            
            Button(action: {
                if selectedProject != nil {
                    // If selectedProject is not nil
                    updateProperty()
                    resetFormFields()
                } else {
                    // If selectedProject is nil
                    if !title.isEmpty && !description.isEmpty && !location.isEmpty  {
                        
                        //                                insertProperty()
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
                        
                        // Create a new property
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
                        
                        
                        self.dbHelper.addProperty(newProperty, userID: userID)
                        { success in
                            if success {
                                insertNotif(newProperty, "Insert")
                                alertMessage = "Property added successfully"
                                resetFormFields()
                                
                            } else {
                                alertMessage = "Failed to save property. Please try again."
                            }
                            showAlert = true
                            
                        }
                        
                        
                        
                    } else {
                        alertMessage = "Please Enter Title $ Desciption & Address and ScoreFootage!"
                    }
                    showAlert = true
                    
                }
            }) {
                Text("Save")
                    .font(.headline)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 100)
                    .background(Color(red: 0.0, green: 0.40, blue: 0.0))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            
            .onAppear() {
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
                    
                    // MARK: Show image from db
                    if let imageData = currentProject.images as? Data {
                        self.imageData = imageData
                    } else {
                        print("Invalid image data format")
                    }
                } else {
                    resetFormFields()
                }
            } //onApperar
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Message! "),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        //            .padding()
        //.navigationBarTitle("Update a Property")//VStack
    }//View
    
    
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
        imageData = nil
        selectedImage = nil
        
    }
    
    //    private func insertProperty() {
    //        guard let userID = dbHelper.userProfile?.id else {
    //            return
    //        }
    //        //Image
    //        var imageData :Data? = nil
    //
    //        if(selectedImage != nil )
    //        {
    //            let image = selectedImage!
    //            let imageName = "\(UUID().uuidString).jpg"
    //            print(imageName)
    //            imageData = image.jpegData(compressionQuality: 0.1)
    //        }
    //
    //        // Create a new property
    //        let newProperty = RenovateProject(
    //            projectID: UUID().uuidString,
    //            title: title,
    //            description: description,
    //            location: location,
    //            lng: lng,
    //            lat: lat,
    //            images: imageData,
    //            ownerID: userID,
    //            category: selectedCategory,
    //            investmentNeeded: investmentNeeded,
    //            selectedInvestmentSuggestionID: "",
    //            status: status,
    //            startDate: startDate,
    //            endDate: endDate,
    //            numberOfBedrooms: numberOfBedrooms,
    //            numberOfBathrooms: numberOfBathrooms,
    //            propertyType: propertyType,
    //            squareFootage: squareFootage,
    //            isFurnished: isFurnished,
    //            createdDate: Date(),
    //            updatedDate: Date(),
    //            favoriteCount: 0,
    //            realtorID: ""
    //        )
    //
    //
    //        self.dbHelper.addProperty(newProperty, userID: userID)
    //        { success in
    //            if success {
    //                insertNotif(newProperty, "Insert")
    //                alertMessage = "Property added successfully"
    //                resetFormFields()
    //
    //            } else {
    //                alertMessage = "Failed to save property. Please try again."
    //            }
    //            showAlert = true
    //
    //        }
    //    }
    
    private func updateProperty() {
        guard let userID = dbHelper.userProfile?.id else {
            return
        }
        
        if selectedImage != nil {
            let image = selectedImage!
            imageData = image.jpegData(compressionQuality: 0.1)
        }
        
        // Update the startDate and endDate from the DatePicker selections
        let updatedProperty = RenovateProject(
            projectID: selectedProject?.id ?? UUID().uuidString,
            title: title,
            description: description,
            location: location,
            lng: lng,
            lat: lat,
            images : imageData,
            ownerID: userID,
            category: selectedCategory,
            investmentNeeded: investmentNeeded,
            selectedInvestmentSuggestionID: selectedProject?.selectedInvestmentSuggestionID ?? "",
            status: status,
            startDate: startDate,
            endDate: endDate,
            numberOfBedrooms: numberOfBedrooms,
            numberOfBathrooms: numberOfBedrooms,
            propertyType: propertyType,
            squareFootage: squareFootage,
            isFurnished: isFurnished,
            createdDate: selectedProject?.createdDate ?? Date(),
            updatedDate: Date(),
            favoriteCount: selectedProject?.favoriteCount ?? 0,
            realtorID: selectedProject?.realtorID ?? ""
        )
        
        dbHelper.updateProperty(updatedProperty) { success in
            if success {
                
                insertNotif(updatedProperty, "Update")
                alertMessage = "Property Update successfully"
                resetFormFields()
                presentationMode.wrappedValue.dismiss()
                
            } else {
                alertMessage = "Failed to Update property. Please try again."
            }
            showAlert = true
            
        }
    }
    
    func insertNotif(_ project : RenovateProject, _ a : String){
        
        let notification = Notifications(
            id: UUID().uuidString,
            timestamp: Date(),
            userID: project.ownerID,
            event: "Project \(a)!",
            details: "Project titled '\(project.title)' has been \(a) By \(dbHelper.userProfile?.fullName).",
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
    }
    
}

