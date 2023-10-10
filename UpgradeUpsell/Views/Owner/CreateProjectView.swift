//
//  CreateProjectView.swift
//  UpgradeUpsell
//
//  Created by Created by Zahra Shahin - Golnaz Chehrazi .
//
import SwiftUI
import Firebase

struct CreateProjectView: View {
    @EnvironmentObject var dbHelper: FirestoreController
    @EnvironmentObject var authHelper: FireAuthController
    @Environment(\.presentationMode) var presentationMode

    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var lng: Double = 0.0
    @State private var lat: Double = 0.0
    @State private var category = ""
    @State private var investmentNeeded: Double = 0.0
    @State private var status = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var numberOfBedrooms = 0
    @State private var numberOfBathrooms = 0
    @State private var images: [Image] = []
    @State private var propertyType = ""
    @State private var squareFootage: Double = 0.0
    @State private var isFurnished = false

    @State private var showAlert = false

    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Section(header: Text("Property Information")) {
                        TextField("Title", text: $title)
                        TextField("Description", text: $description)
                        TextField("Location", text: $location)
                        TextField("Longitude", value: $lng, formatter: NumberFormatter())
                        TextField("Latitude", value: $lat, formatter: NumberFormatter())
                        TextField("Category", text: $category)
                        TextField("Investment Needed", value: $investmentNeeded, formatter: NumberFormatter())
                        TextField("Status", text: $status)
                    }

                    Section(header: Text("Details")) {
                        Stepper("Number of Bedrooms: \(numberOfBedrooms)", value: $numberOfBedrooms, in: 0...10)
                        Stepper("Number of Bathrooms: \(numberOfBathrooms)", value: $numberOfBathrooms, in: 0...10)
                        TextField("Property Type", text: $propertyType)
                        TextField("Square Footage", value: $squareFootage, formatter: NumberFormatter())
                        Toggle("Is Furnished", isOn: $isFurnished)
                    }

                    Section(header: Text("Dates")) {
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                    }

                    Button(action: {
                    
                        guard let userID = dbHelper.userProfile?.id else {
                            return
                        }
                        
                        let newProperty = RenovateProject(
                            projectID: UUID().uuidString,
                            title: title,
                            description: description,
                            location: location,
                            lng: lng,
                            lat: lat,
                            images: [],
                            ownerID: userID,
                            category: category,
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
                                showAlert = true
                                presentationMode.wrappedValue.dismiss()
                                resetFormFields() // Reset form fields
                            } else {
                                // Handle the case when there is an error saving the property.
                            }
                        }
                       
                    }) {
                        Text("Add Property")
                            .font(.title)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    } .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Success"),
                            message: Text("Property saved successfully"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                .padding()
                
            }
        }
    }

    private func resetFormFields() {
        title = ""
        description = ""
        location = ""
        lng = 0.0
        lat = 0.0
        category = ""
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
