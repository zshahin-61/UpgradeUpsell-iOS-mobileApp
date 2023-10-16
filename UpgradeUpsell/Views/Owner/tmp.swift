////
////  CreateProjectView.swift
////  UpgradeUpsell
////
////  Created by Created by Zahra Shahin.
////
//
//    
//    
//    
//    @State private var title = ""
//    @State private var description = ""
//    @State private var location = ""
//    @State private var lng: Double = 0.0
//    @State private var lat: Double = 0.0
//    @State private var category = ""
//    @State private var selectedCategory = "Residential"
//    @State private var investmentNeeded: Double = 0.0
//    @State private var status = "Released"
//    @State private var startDate = Date()
//    @State private var endDate = Date()
//    @State private var numberOfBedrooms = 0
//    @State private var numberOfBathrooms = 0
//    @State private var images: [Image] = []
//    @State private var propertyType = ""
//    @State private var squareFootage: Double = 0.0
//    @State private var isFurnished = false
//    
//    @State private var showAlert = false
//    
//    var selectedProject: RenovateProject?
//    
//    @EnvironmentObject var locationHelper: LocationHelper
//    
//    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//    
//    
//    // status: Delete show but deactive by owner be onwer and didnot show on the list | all offer will be decline
//    
//    private let categories = [
//        "Residential",
//        "Condo",
//        "Townhouse",
//        "Apartment",
//        "Office Space",
//        "Retail Space",
//        "Warehouse",
//        "House",
//        "Other"
//    ]
//    
//    
//    var body: some View {
//        NavigationView {
//            //   ScrollView {
//            Form {
//                Section(header: Text("")) {
//                    VStack {
//                               HStack {
//                                   Text("Title")
//                                       .bold()
//                                       .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
//                                   Spacer()
//                               }
//                        
//                        TextEditor(text: $title)
//                            .frame(minHeight: 70)
//                            .cornerRadius(5)
//                            .border(Color.gray, width: 0.2)
//        
//                           }
//                    VStack {
//                        
//                        HStack {
//                            Text("Description")
//                                .bold()
//                                .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
//
//                            Spacer()
//                        }
//                        TextEditor(text: $description)
//                            .frame(minHeight: 70)
//                            .cornerRadius(5)
//                            .border(Color.gray, width: 0.2)
//                        
//                    }
//                    
//                    VStack {
//                        
//                        HStack {
//                            Text("Address")
//                                .bold()
//                                .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
//
//                            Spacer()
//                        }
//                     
//                        TextEditor(text: $location)
//                            .frame(minWidth: 10, minHeight: 50)
//                            .cornerRadius(5)
//                            .border(Color.gray, width: 0.2)
//                    }
//                    HStack {
//                        Text("Category").bold()
//                            .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
//
//                        Spacer()
//                        Picker("", selection: $selectedCategory) {
//                            ForEach(categories, id: \.self) { category in
//                                Text(category)
//                            }
//                        }
//                    }
//                    VStack {
//                        HStack {
//                            Text("Number of Bedrooms")
//                                .bold()
//                                .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
//
//                            Spacer()
//                        }
//   
//                        Stepper("\(numberOfBedrooms)", value: $numberOfBedrooms, in: 0...10)
//                    }
//                    VStack {
//                        HStack {
//                            Text("Number of Bathrooms")
//                                .bold()
//                                .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
//
//                            Spacer()
//                        }
//      
//                        Stepper("\(numberOfBathrooms)", value: $numberOfBathrooms, in: 0...10)
//                    }
//                    // Image
//                    VStack(alignment: .leading, spacing: 10) {
//                        HStack {
//                            if let data = imageData, let uiImage = UIImage(data: data) {
//                                if selectedImage == nil {
//                                    Image(uiImage: uiImage)
//                                        .resizable()
//                                        .frame(width: 150, height: 150)
//                                        .clipShape(Rectangle())
//                                } else {
//                                    //
//                                }
//                            }
//                            VStack {
//                                Text("Upload Images").font(.subheadline)
//                                if photoLibraryManager.isAuthorized {
//                                    if let image = selectedImage {
//                                        Image(uiImage: image)
//                                            .resizable()
//                                            .frame(width: 150, height: 150)
//                                            .clipShape(Rectangle())
//                                    }
//                                    Button(action: {
//                                        isShowingPicker = true
//                                    }) {
//                                        Text("Choose Picture")
//                                    }
//                                } else {
//                                    Button(action: {
//                                        photoLibraryManager.requestPermission()
//                                    }) {
//                                        Text("Request Access For Photo Library")
//                                    }
//                                }
//                            }
//                            .sheet(isPresented: $isShowingPicker) {
//                                if photoLibraryManager.isAuthorized {
//                                    ImagePickerView(selectedImage: $selectedImage)
//                                } else {
//                                    Text("Access to photo library is not authorized.")
//                                }
//                            }
//                        }
//                    }
//                    VStack {
//                        
//                        HStack {
//                            Text("Square Footage")
//                                .bold()
//                                .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
//
//                            Spacer()
//                        }
//                                        
//                        TextField("", value: $squareFootage, formatter: NumberFormatter())
//                            .keyboardType(.numberPad)
//                            .frame(minWidth: 10, minHeight: 50)
//                            .cornerRadius(5)
//                            .border(Color.gray, width: 0.2)
//
//                        
//                    }
//                    HStack {
//                        Toggle("Is Furnished", isOn: $isFurnished)
//                            .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
//                            .bold()// Dark green color
//                    }
//                    VStack {
//                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
//                            .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
//                            .bold()// Dark green color
//                        Spacer()
//                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
//                            .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
//                            .bold()// Dark green color
//                    }
//
//                } //Form
//                
//                HStack {
//                  
//                Spacer()
//                
//                Button(action: {
//                    if selectedProject != nil {
//                        // If selectedProject is not nil, it's an update operation
//                        updateProperty()
//                        resetFormFields()
//                    } else {
//                        // If selectedProject is nil, it's an insert operation
//                        insertProperty()
//                        resetFormFields()
//                    }
//                }) {
//                    Text("Save")
//                        .font(.headline)
//                        .padding(.vertical, 10)
//                        .padding(.horizontal, 100)
//                        .background(Color(red: 0.0, green: 0.40, blue: 0.0))
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .alert(isPresented: $showAlert) {
//                    Alert(
//                        title: Text("Success"),
//                        message: Text("Property saved successfully"),
//                        dismissButton: .default(Text("OK"))
//                    )
//                }
//                    Spacer()
//                }
//            }              //Form
////            .background(Color.green)
//            .padding()
//            .onAppear() {
//                if let currentProject = selectedProject {
//                    self.title = currentProject.title
//                    self.description = currentProject.description
//                    self.selectedCategory = currentProject.category
//                    self.location = currentProject.location
//                    self.lng = currentProject.lng
//                    self.lat = currentProject.lat
//                    self.investmentNeeded = currentProject.investmentNeeded
//                    self.status = currentProject.status
//                    self.startDate = currentProject.startDate
//                    self.endDate = currentProject.endDate
//                    self.numberOfBedrooms = currentProject.numberOfBedrooms
//                    self.numberOfBathrooms = currentProject.numberOfBathrooms
//                    self.propertyType = currentProject.propertyType
//                    self.squareFootage = currentProject.squareFootage
//                    self.isFurnished = currentProject.isFurnished
//                    
//                    // MARK: Show image from db
//                    if let imageData = currentProject.images as? Data {
//                        self.imageData = imageData
//                    } else {
//                        print("Invalid image data format")
//                    }
//                } else {
//                    resetFormFields()
//                }
//            } //onApperar
//            
//            //}//scroll
//        }//NavigationView
//        .navigationBarTitle("Information")
//        
//    }//View
//    
//    
//    private func resetFormFields() {
//        title = ""
//        description = ""
//        location = ""
//        lng = 0.0
//        lat = 0.0
//        selectedCategory = "Residential"
//        investmentNeeded = 0.0
//        status = ""
//        startDate = Date()
//        endDate = Date()
//        numberOfBedrooms = 0
//        numberOfBathrooms = 0
//        propertyType = ""
//        squareFootage = 0.0
//        isFurnished = false
//        imageData = nil
//        
//    }
//    
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
//        dbHelper.addProperty(newProperty, userID: userID) { success in
//            if success {
//                presentationMode.wrappedValue.dismiss()
//                resetFormFields()
//            } else {
//            }
//        }
//    }
//    
//    private func updateProperty() {
//        guard let userID = dbHelper.userProfile?.id else {
//            return
//        }
//        
//        if selectedImage != nil {
//            let image = selectedImage!
//            imageData = image.jpegData(compressionQuality: 0.1)
//        }
//        
//        // Update the startDate and endDate from the DatePicker selections
//        let updatedProperty = RenovateProject(
//            projectID: selectedProject?.id ?? UUID().uuidString,
//            title: title,
//            description: description,
//            location: location,
//            lng: lng,
//            lat: lat,
//            images : imageData,
//            ownerID: userID,
//            category: selectedCategory,
//            investmentNeeded: investmentNeeded,
//            selectedInvestmentSuggestionID: selectedProject?.selectedInvestmentSuggestionID ?? "",
//            status: status,
//            startDate: startDate,
//            endDate: endDate,
//            numberOfBedrooms: numberOfBedrooms,
//            numberOfBathrooms: numberOfBedrooms,
//            propertyType: propertyType,
//            squareFootage: squareFootage,
//            isFurnished: isFurnished,
//            createdDate: selectedProject?.createdDate ?? Date(),
//            updatedDate: Date(),
//            favoriteCount: selectedProject?.favoriteCount ?? 0,
//            realtorID: selectedProject?.realtorID ?? ""
//        )
//        
//        dbHelper.updateProperty(updatedProperty) { success in
//            if success {
//                presentationMode.wrappedValue.dismiss()
//                resetFormFields()
//            } else {
//            }
//        }
//    }
//    
//    
//}
//
