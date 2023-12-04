//
//  ProjectAddView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-27.
//

import SwiftUI
import Firebase
import MapKit
import Foundation
import FirebaseFirestoreSwift

struct ProjectAddView: View {
    @EnvironmentObject var dbHelper: FirestoreController
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var locationHelper: LocationHelper
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var photoLibraryManager = PhotoLibraryManager()
    
    @State private var isShowingPicker = false
    //    @State private var selectedImage: UIImage?
    //    @State private var imageData: Data?
    @State private var selectedImages: [UIImage?] = []
    
    
    @State private var title = ""
    @State private var description = ""
    @State private var address = ""
    //    @State private var location = ""
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
    
    
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.64732, longitude: -79.38279), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    
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
                Section(header: Text("Property Details")) {
                    //                Section{
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
                        
                        
                        //                        TextEditor(text: $location)
                        //                            .frame(minWidth: 10, minHeight: 50)
                        //                            .cornerRadius(5)
                        //                            .border(Color.gray, width: 0.2)
                        //                    }
                        //                    VStack {
                        TextField("Enter your address", text: $address)
                            .padding()
                            .border(Color.gray, width: 0.2)
                        
                        Button(action: {
                            
                            // Convert the address to coordinates and update the latitude and longitude
                            self.convertAddressToCoordinates()
                        }) {
                            Text("Find Location")
                        }
                        
                        MapView(latitude: lat, longitude: lng)
                    } .frame(height: 300)
                        .border(Color.gray)
                    // locationHelper.checkPermission()
                    
                    
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
                    //                                Text("Upload Images").bold()
                    //                                    .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
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
                    //                                    }.buttonStyle(.borderedProminent)
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
                    
                    // Image
                    if selectedImages.count >= 3 {
                        Text("Count Of Images: \(selectedImages.count)\nScroll right for more Images").padding().bold()
                    } else {
                        Text("Count Of Images: \(selectedImages.count)").padding().bold()
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            
                            if selectedImages.isEmpty {
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Rectangle())
                            } else {
                                // Display selected images in a horizontal stack
                                //                                ScrollView(.horizontal) {
                                //                                    HStack {
                                //                                        ForEach(selectedImages.indices, id: \.self) { index in
                                //                                            if let image = selectedImages[index] {
                                //                                                Image(uiImage: image)
                                //                                                    .resizable()
                                //                                                    .frame(width: 150, height: 150)
                                //                                                    .clipShape(Rectangle())
                                //                                            }
                                //                                        }
                                //                                    }
                                //                                }
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(selectedImages.indices, id: \.self) { index in
                                            if let image = selectedImages[index] {
                                                ZStack {
                                                    Image(uiImage: image)
                                                        .resizable()
                                                        .frame(width: 150, height: 150)
                                                        .clipShape(Rectangle())
                                                    
                                                    Button(action: {
                                                        // Remove the selected image at the given index
                                                        selectedImages.remove(at: index)
                                                    }) {
                                                        Image(systemName: "trash")
                                                            .foregroundColor(.red)
                                                    }
                                                    .padding(5)
                                                    .background(Color.white)
                                                    .clipShape(Circle())
                                                    .offset(x: 50, y: -50) // Adjust the offset for the trash icon position
                                                }
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                        VStack {
                            Text("Upload Images").bold()
                                .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.0))
                            if photoLibraryManager.isAuthorized {
                                Button(action: {
                                    isShowingPicker = true
                                }) {
                                    Text("Choose Pictures")
                                }.buttonStyle(.borderedProminent)
                            } else {
                                Button(action: {
                                    photoLibraryManager.requestPermission()
                                }) {
                                    Text("Request Access For Photo Library")
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
                if !title.isEmpty && !description.isEmpty && !address.isEmpty {
                    guard let userID = dbHelper.userProfile?.id else {
                        return
                    }
                    
                    // Create an array to store image data for all selected images
                    var imageDatas: [Data] = []
                    
                    // Check if any images are selected
                    if !selectedImages.isEmpty {
                        for image in selectedImages {
                            if let imageData = image?.jpegData(compressionQuality: 0.1) {
                                imageDatas.append(imageData)
                            }
                        }
                    }
                    
                    // Create a new property with an array of image data
                    let newProperty = RenovateProject(
                        projectID: UUID().uuidString,
                        title: title,
                        description: description,
                        location: address,
                        lng: lng,
                        lat: lat,
                        images: imageDatas,
                        ownerID: userID,
                        category: selectedCategory,
                        investmentNeeded: investmentNeeded,
                        selectedInvestmentSuggestionID: "",
                        status: "Released",
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
                    
                    self.dbHelper.addProperty(newProperty, userID: userID) { success in
                        if success {
                            sendNotificationToInvestors(newProperty, "Insert") { success in
                                if success {
                                    // Handle success
                                    print("Notifications sent successfully.")
                                    insertNotif(newProperty, "Insert")
                                    alertMessage = "Property added successfully"
                                    resetFormFields()
                                } else {
                                    // Handle failure
                                    print("Failed to send notifications.")
                                }
                            }
                        } else {
                            alertMessage = "Failed to save property. Please try again."
                        }
                        showAlert = true
                    }
                } else {
                    alertMessage = "Please Enter Title, Description, Address, and Square Footage!"
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
            .sheet(isPresented: $isShowingPicker) {
                if photoLibraryManager.isAuthorized {
                    //                      NavigationView {
                    MultiImagePickerView(sourceType: .photoLibrary) { pickedImages in
                        // Handle the picked images here and append them to your 'selectedImages' array
                        for image in pickedImages {
                            selectedImages.append(image)
                        }
                        // Dismiss the sheet
                        $isShowingPicker.wrappedValue = false
                    }
                    //                      }
                } else {
                    Text("Access to the photo library is not authorized.")
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Message! "),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        
    }//View
    
    
    private func resetFormFields() {
        title = ""
        description = ""
        address = ""
        lng = 0.0
        lat = 0.0
        selectedCategory = "Residential"
        investmentNeeded = 0.0
        status = "Released"
        startDate = Date()
        endDate = Date()
        numberOfBedrooms = 0
        numberOfBathrooms = 0
        propertyType = ""
        squareFootage = 0.0
        isFurnished = false
        // imageData = nil
        selectedImages = []
        
    }
    
    
    func insertNotif(_ project : RenovateProject, _ a : String){
        
        var flName = ""
        if let fullName = dbHelper.userProfile?.fullName{
            flName = fullName
        }
        
        let notification = Notifications(
            id: UUID().uuidString,
            timestamp: Date(),
            userID: project.ownerID,
            event: "Project \(a)!",
            details: "Project titled '\(project.title)' has been \(a) By \(flName).",
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
    }
    func convertAddressToCoordinates() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
#if DEBUG
                print("Geocoding error: \(error.localizedDescription)")
#endif
            } else if let placemark = placemarks?.first {
                self.lat = placemark.location?.coordinate.latitude ?? 0.0
                self.lng = placemark.location?.coordinate.longitude ?? 0.0
                
                
            }
        }
    }
    
    func sendNotificationToInvestors(_ project: RenovateProject, _ a: String, completion: @escaping (Bool) -> Void) {
        var flName = ""
        if let currUser = dbHelper.userProfile {
            flName = currUser.fullName
        }

        dbHelper.getUsersByRole(role: "Investor") { (investors, error) in
            if let error = error {
                print("Error getting investor users: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let investors = investors else {
                print("No investor users found.")
                completion(false)
                return
            }

            for inv in investors {
                if let userID = inv.id {
                    // Create a notification entry for each investor
                    let notification = Notifications(
                        id: UUID().uuidString, // Firestore will generate an ID
                        timestamp: Date(),
                        userID: userID,
                        event: "Project \(a)!",
                        details: "Project titled '\(project.title)' has been \(a) By \(flName).",
                        isRead: false,
                        projectID: project.id!
                    )

                    // Save the notification entry to the "notifications" collection
                    self.dbHelper.insertNotification(notification) { isSuccessful in
                        if !isSuccessful {
                            print("Notification not sent to user: \(inv.id)")
                        }
                    }
                }
            }
            
            // Notify completion after processing all investors
            completion(true)
        }
    }

    
//    func sendNotificationToInvestors(_ project : RenovateProject, _ a : String) {
//        
//        var flName =  ""
//        if let currUser = dbHelper.userProfile {
//            flName = currUser.fullName
//        }
//        
//        dbHelper.getUsersByRole(role: "Investor"){ (investors, error) in
//            if let error = error {
//                print("Error getting investor users: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let investors = investors else {
//                print("No investor users found.")
//                return
//            }
//            
//            for inv in investors {
//                if let userID = inv.id {
//                    // Create a notification entry for each investor
//                    let notification = Notifications(
//                        id: UUID().uuidString, // Firestore will generate an ID
//                        timestamp: Date(),
//                        userID: userID,
//                        event: "Project \(a)!",
//                        details: "Project titled '\(project.title)' has been \(a) By \(flName).",
//                        isRead: false,
//                        projectID: project.id!
//                    )
//                    
//                    // Save the notification entry to the "notifications" collection
//                    self.dbHelper.insertNotification(notification){isSuccesful in
//                        if(!isSuccesful){
//                            print("Notification not sent to user:  \(inv.id)")
//                        }
//                    }
//                }
//            }
//        }
//        
//    }
//    
}
