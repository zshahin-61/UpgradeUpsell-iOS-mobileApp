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

    @State private var previousOffer: InvestmentSuggestion?
    @State private var preStatus:String = ""
    
   // @State private var shouldDismissView = false
    
    var body: some View {
        VStack{
            Text("Make an Offer").bold().font(.title).foregroundColor(.brown)
            Form {
                Section(header: Text("Property Information").font(.headline)) {
                    VStack(alignment: .leading, spacing: 2){
                        Text("Title: ").font(.subheadline)
                        Text("\(project.title)")
                    }.padding(2)
                    VStack(alignment: .leading, spacing: 2){
                        Text("Category: ").font(.subheadline)
                        Text("\(project.category)")
                    }.padding(2)
                    VStack(alignment: .leading, spacing: 2){
                        Text("Released date: ").font(.subheadline)
                        Text("\(formattedDate(from: project.createdDate))")
                    }.padding(2)
                    VStack(alignment: .leading, spacing: 2){
                        HStack{
                            Text("Need to be done between: ").font(.subheadline)
                            Spacer()
                        }
                        HStack{
                            Text(" \(formattedDate(from: project.startDate))")
                            Text("  to  \(formattedDate(from: project.endDate))")
                        }
                    }.padding(2)
                    
                    Section {
                        if let images = project.images{
                            if !images.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(images, id: \.self) { image in
                                            if let uiImage = UIImage(data: image) {
                                                Image(uiImage:  uiImage)
                                                    .resizable()
                                                    //.aspectRatio(contentMode: .fit)
                                                    .frame(width: 200, height: 200) // Set a fixed size
                                            }
                                        }
                                    }
                                }
                            } else {
                                Text("No images available")
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 2){
                        HStack{
                            Text("Owner Description:").font(.subheadline)
                            Spacer()
                        }
                        Text("\(project.description)")
                    }.padding(2)
                    
//                    HStack{
//                        Text("Likes: ").bold()
//                        Text("\(project.favoriteCount)")
//                        Spacer()
//                        Text("Status: ").bold()
//                        Text("\(project.status)")
//                    }
                    VStack(alignment: .leading, spacing: 2){
                        Text("Location: ").font(.subheadline)
                        Text("\(project.location)")
                    }.padding(2)
                    
                    MapView(latitude: propertyLatitude, longitude: propertyLongitude)
                        .frame(height: 200)
                    
                }
                
                Section(header: Text("Make an Offer").font(.headline) ) {
//                    TextField("Amount Offered", text: $amountOffered)
//                        .frame(minWidth: 30, maxWidth: .infinity)
//                        .border(.gray , width: 0.5)
//                       // .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .keyboardType(.decimalPad)
//                        //.padding()
                    
                    if(!preStatus.isEmpty){
                        VStack{
                            Text("Status: \(preStatus)")
                        }
                    }
                    
                    VStack {
                        TextField("Amount Offered", text: $amountOffered)
                            .keyboardType(.decimalPad)
                    }
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)) // Adjust the values based on your preference
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    
                    VStack {
                        TextField("Duration in Weeks", text: $durationWeeks)
                            .keyboardType(.numberPad)
                    }
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)) // Adjust the values based on your preference
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    
                    Text("Description:")
                    VStack {
                        TextEditor(text: $description)
                            .frame(height: 200)
                           // .keyboardType(.numberPad)
                    }
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)) // Adjust the values based on your preference
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    
//                    TextEditor(text: $description)
//                        .frame(height: 200)
//                        .cornerRadius(5)
//                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 0.2))
                        //.padding()
                }//.background(Color.cyan)
            } .background(Color.gray.opacity(0.1))// Form
            Section {
                Button("Submit") {
                    guard let currUser = self.dbHelper.userProfile else{
                        return
                    }
                    if validateForm() {
                        if let previousOffer = self.previousOffer{
                            var offerTopUpdate = previousOffer
                            offerTopUpdate.amountOffered = Double(self.amountOffered) ?? 0.0
                            offerTopUpdate.durationWeeks = Int(durationWeeks) ?? 0
                            offerTopUpdate.description = self.description
                            offerTopUpdate.status = "Pending"
                            offerTopUpdate.date = Date()
                            self.dbHelper.updateInvestmentSuggestion(offerTopUpdate) { error in
                                if let error = error {
                                    // Handle the error (e.g., show an alert)
                                    print("Error updating investment suggestion: \(error.localizedDescription)")
                                    alertMessage = "Error updating investment suggestion: \(error.localizedDescription)"
                                    showAlert = true
                                } else {
                                    insertNotif(offerTopUpdate, "update")
                                    // Update successful
                                    print("Investment suggestion updated successfully")
                                    //alertMessage = "Investment suggestion updated successfully"
                                    showAlert = false
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                
                            }
                        }
                        else{
                            let newOffer = InvestmentSuggestion(
                                id: UUID().uuidString,
                                investorID: currUser.id ?? "",
                                investorFullName: currUser.fullName,
                                ownerID: project.ownerID,
                                projectID: project.id ?? "",
                                projectTitle: project.title,
                                amountOffered: Double(amountOffered) ?? 0.0,
                                durationWeeks: Int(durationWeeks) ?? 0,
                                description: description,
                                status: "Pending",
                                date: Date()
                            )
                            self.dbHelper.addInvestmentSuggestion(newOffer) { error in
                                if let error = error {
                                    alertMessage = "Error: \(error.localizedDescription)"
                                    //  shouldDismissView = false
                                    showAlert = true
                                } else {
                                    insertNotif(newOffer, "Insert")
                                    alertMessage = "Your offer added successfully"
                                    //  shouldDismissView = true
                                    showAlert = false
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                //showAlert = true
                            }
                        }
                    }else{
                            showAlert = true
                        }//if valid form
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

                guard let investorID = dbHelper.userProfile?.id else { return }
                print("xxxxxxxx")
                print(investorID)
                print(project.id!)

                dbHelper.getPreviousOffer(investorID: investorID, projectID: project.id ?? "") { previousOfferData in
                        if let previousOfferData = previousOfferData {
                            self.previousOffer = previousOfferData
                            
                            self.amountOffered = String(previousOfferData.amountOffered)
                            self.durationWeeks =  String(previousOfferData.durationWeeks)
                            self.description = previousOfferData.description
                            self.preStatus = previousOfferData.status
                            
                        }
                    }
                
            }
            
        }
        
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Result"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
                //{
                    //self.showAlert = false
                    //if shouldDismissView  && !alertMessage.lowercased().contains("error") {
                      //  self.presentationMode.wrappedValue.dismiss()
                   // }
                //}
            )
        }
        //.navigationBarTitle("Add an Offer")
    }

    //insert in notifications
    func insertNotif(_ myOffer : InvestmentSuggestion, _ a : String){
        
        var flName = ""
        if let fullName = dbHelper.userProfile?.fullName{
            flName = fullName
        }
        
        let notification = Notifications(
            id: UUID().uuidString,
            timestamp: Date(),
            userID: myOffer.ownerID,
            event: "Offer \(a)!",
            details: "Offer $\(myOffer.amountOffered) for project titled \(myOffer.projectTitle) has been \(a) By \(flName).",
            isRead: false,
            projectID: myOffer.projectID
        )
        dbHelper.insertNotification(notification) { notificationSuccess in
            if notificationSuccess {
#if DEBUG
                print("Notification inserted successfully.")
                #endif
            } else {
#if DEBUG
                //alertMessage = "Error inserting notification."
                print("Error inserting notification.")
                #endif
            }
        }
    }
    
    // Function to validate the form
        func validateForm() -> Bool {
            var isValid = true
            var validationMessage = ""

            // Validate amountOffered
            if amountOffered.isEmpty || Double(amountOffered) == nil || Double(amountOffered)! <= 0 {
                isValid = false
                validationMessage += "Please enter a valid amount offered.\n"
            }

            // Validate durationWeeks
            if durationWeeks.isEmpty || Int(durationWeeks) == nil || Int(durationWeeks)! <= 0 {
                isValid = false
                validationMessage += "Please enter a valid duration in weeks.\n"
            }

            // Validate description
            if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                isValid = false
                validationMessage += "Please enter a description.\n"
            }
            if(validationMessage != ""){
                
                alertMessage = "Error: " + validationMessage
            }
            return isValid
        }
    
    func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}
