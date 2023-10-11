//
//  SwiftUIView.swift
//  UpgradeUpsell
//  Created by Created by Zahra Shahin - Golnaz Chehrazi .
//

import SwiftUI

struct MakeOffers_InvestorView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var dbHelper: FirestoreController
    //@EnvironmentObject var authHelper: FireAuthController
    
    let project: RenovateProject
        
    @State private var amountOffered = "" // Removed the initial value
    @State private var durationWeeks = "" // Removed the initial value
    @State private var description = "" // Removed the initial value

        
        @State private var alertMessage = ""
        @State private var showAlert = false

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Group{
                    //Text("Investor ID: \(dbHelper.userProfile?.id!)")
                    Text("Title: \(project.title)")
                    Text("Category: \(project.category)")
                    Text("Insert date: \(project.createdDate)")
                    Text("Description: \(project.description)")
                    Text("Likes count: \(project.favoriteCount)")
                    Text("Status: \(project.status)")
                    Text("Location: \(project.location)")
                    Form{
                        TextField("Amount Offered", text: $amountOffered)
                        TextField("Duration in Weeks", text: $durationWeeks)
                        TextField("Description", text: $description)
                    }
                        //TextField("Status", text: $status)
                }
                Button("Submit") {
                    
                    var newOffer : InvestmentSuggestion = InvestmentSuggestion(id: UUID().uuidString, investorID: self.dbHelper.userProfile?.id ?? "", ownerID: project.ownerID, projectID: project.id!, amountOffered: Double(amountOffered) ?? 0.0 , durationWeeks: Int(durationWeeks) ?? 0, description: description, status: "New")
                    
                    self.dbHelper.addInvestmentSuggestion(newOffer) { error in
                        if let error = error {
                            // Handle error if needed
                            print("Error: \(error.localizedDescription)")
                            alertMessage = "Error: \(error.localizedDescription)"
                        } else {
                            // Suggestion added successfully, you can navigate or show a confirmation message
                            print("Suggestion added successfully")
                            alertMessage = "Suggestion added successfully"
                            
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        showAlert = true
                    }
                }
                Spacer()
            } // VSTACK
            .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Conversion Result"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
            .navigationBarTitle("Add an Offer")
        }
    }
