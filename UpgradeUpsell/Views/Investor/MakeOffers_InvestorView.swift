//
//  SwiftUIView.swift
//  UpgradeUpsell
//  Created by Created by Zahra Shahin - Golnaz Chehrazi .
//

import SwiftUI
import MapKit

struct MakeOffers_InvestorView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dbHelper: FirestoreController

    let project: RenovateProject

    @State private var amountOffered = ""
    @State private var durationWeeks = ""
    @State private var description = ""

    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var propertyLatitude: Double = 0.0
    @State private var propertyLongitude: Double = 0.0

    var body: some View {
        VStack{
            Text("Make an Offer").bold().font(.title).foregroundColor(.brown)
            Form {
                Section(header: Text("Property Information").font(.headline)) {
                    HStack{
                        Text("Title: ").bold()
                        Text("\(project.title)")}
                    HStack{
                        Text("Category: ").bold()
                        Text("\(project.category)")
                    }
                    HStack{
                        Text("Released date: ").bold()
                        Text("\(formattedDate(from: project.createdDate))")
                    }
                    VStack{
                        HStack{
                            Text("Need to be done between: ").bold()
                            Spacer()
                        }
                        HStack{
                            Text(" \(formattedDate(from: project.startDate))")
                            Text("   to    \(formattedDate(from: project.endDate))")
                        }
                    }
                    VStack{
                        HStack{
                            Text("Description: ").bold()
                            Spacer()
                        }
                        Text("\(project.description)")
                    }
                    HStack{
                        Text("Likes: ").bold()
                        Text("\(project.favoriteCount)")
                        Spacer()
                        Text("Status: ").bold()
                        Text("\(project.status)")
                    }
                    HStack{
                        Text("Location: ").bold()
                        Text("\(project.location)")
                    }
                    MapView(latitude: propertyLatitude, longitude: propertyLongitude)
                    .frame(height: 200)
                    
                }
                
                Section(header: Text("Make an Offer").font(.headline)) {
                    TextField("Amount Offered", text: $amountOffered).textFieldStyle(.roundedBorder)
                    TextField("Duration in Weeks", text: $durationWeeks).textFieldStyle(.roundedBorder)
                    Text("Description:")
                    TextEditor(text: $description)
                        .frame(height: 200)
                        .border(Color.gray, width: 1)
                }
            }
            Section {
                Button("Submit") {
                    let newOffer = InvestmentSuggestion(
                        id: UUID().uuidString,
                        investorID: self.dbHelper.userProfile?.id ?? "",
                        investorFullName: self.dbHelper.userProfile?.fullName ?? "",
                        ownerID: project.ownerID,
                        projectID: project.id!,
                        projectTitle: project.title,
                        amountOffered: Double(amountOffered) ?? 0.0,
                        durationWeeks: Int(durationWeeks) ?? 0,
                        description: description,
                        status: "New",
                        date: Date()
                    )
                    
                    self.dbHelper.addInvestmentSuggestion(newOffer) { error in
                        if let error = error {
                            alertMessage = "Error: \(error.localizedDescription)"
                        } else {
                            insertNotif(newOffer, "Insert")
                            alertMessage = "Your offer added successfully"
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        showAlert = true
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        
            .onAppear {
                        // Retrieve the latitude and longitude values from your database for the property
                        // For example, if you have a property object with lat and lng properties:
                         propertyLatitude = project.lat
                         propertyLongitude = project.lng

                if propertyLatitude == 0.0 && propertyLongitude == 0.0 {
                        let geocoder = CLGeocoder()
                        geocoder.geocodeAddressString(project.location) { placemarks, error in
                            if let placemark = placemarks?.first, let location = placemark.location {
                                propertyLatitude = location.coordinate.latitude
                                propertyLongitude = location.coordinate.longitude
                            }
                        }
                    }
                        // For testing, you can set sample coordinates like this:
                        //propertyLatitude = 37.7749 // Replace with the actual latitude
                        //propertyLongitude = -122.4194 // Replace with the actual longitude
                    }

        }
        
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Result"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        //.navigationBarTitle("Add an Offer")
    }

    //insert in notifications
    func insertNotif(_ myOffer : InvestmentSuggestion, _ a : String){
        
        let notification = Notifications(
            id: UUID().uuidString,
            timestamp: Date(),
            userID: myOffer.ownerID,
            event: "Offer \(a)!",
            details: "Offer $\(myOffer.amountOffered) for project titled \(myOffer.projectTitle) has been \(a) By \(dbHelper.userProfile?.fullName).",
            isRead: false,
            projectID: myOffer.projectID
        )
        dbHelper.insertNotification(notification) { notificationSuccess in
            if notificationSuccess {
                print("Notification inserted successfully.")
            } else {
                print("Error inserting notification.")
            }
        }
    }
    
    
    func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}
