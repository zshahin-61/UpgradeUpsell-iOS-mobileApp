//
//  SwiftUIView.swift
//  UpgradeUpsell
//  Created by Created by Zahra Shahin - Golnaz Chehrazi .
//

import SwiftUI

struct MakeOffers_InvestorView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var dbHelper: FirestoreController
    @EnvironmentObject var authHelper: FireAuthController
    
    let project: RenovateProject
        //@State private var investorID = ""
        //@State private var ownerID = ""
        //@State private var projectID = ""
        @State private var amountOffered = ""
        @State private var durationWeeks = ""
        @State private var description = ""
        //@State private var status = ""

        var body: some View {
            Form {
                Group{
                    //Text("Investor ID: \(dbHelper.userProfile?.id!)")
                    Text("Owner ID: \(project.ownerID)")
                    Text("Project ID:\(project.category)")
                    TextField("Amount Offered", value: $amountOffered, formatter: NumberFormatter())
                    TextField("Duration in Weeks", value: $durationWeeks, formatter: NumberFormatter())
                    TextField("Description", text: $description)
                    //TextField("Status", text: $status)
                }
                Button("Submit") {
                    
                    var newOffer : InvestmentSuggestion = InvestmentSuggestion(id: UUID().uuidString, investorID: self.authHelper.user?.uid ?? "", ownerID: project.ownerID, projectID: project.id!, amountOffered: Double(amountOffered) ?? 0.0 , durationWeeks: Int(durationWeeks) ?? 0, description: description, status: "New")
                    
                    self.dbHelper.addInvestmentSuggestion(newOffer) { error in
                        if let error = error {
                            // Handle error if needed
                            print("Error: \(error.localizedDescription)")
                        } else {
                            // Suggestion added successfully, you can navigate or show a confirmation message
                            print("Suggestion added successfully")
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            } // FORM
            .navigationBarTitle("Add Investment Suggestion")
        }
    }
