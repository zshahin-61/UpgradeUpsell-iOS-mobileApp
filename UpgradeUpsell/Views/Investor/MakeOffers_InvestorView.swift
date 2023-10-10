//
//  SwiftUIView.swift
//  UpgradeUpsell
//  Created by Created by Zahra Shahin - Golnaz Chehrazi .
//

import SwiftUI

struct MakeOffers_InvestorView: View {
    @EnvironmentObject var dbHelper: FirestoreController
    let project: RenovateProject?
        @State private var investorID = ""
        @State private var ownerID = ""
        @State private var projectID = ""
        @State private var amountOffered = 0.0
        @State private var durationWeeks = 0
        @State private var description = ""
        //@State private var status = ""

        var body: some View {
            Form {
                Group{
                    Text("Investor ID: \(investorID)")
                    Text("Owner ID: \(ownerID)")
                    Text("Project ID:\(projectID)")
                    TextField("Amount Offered", value: $amountOffered, formatter: NumberFormatter())
                    TextField("Duration in Weeks", value: $durationWeeks, formatter: NumberFormatter())
                    TextField("Description", text: $description)
                    //TextField("Status", text: $status)
                }
                Button("Submit") {
                    
                    var newOffer : InvestmentSuggestion = InvestmentSuggestion(id: UUID().uuidString, investorID: dbHelper.userProfile?.id! ?? "", ownerID: "", projectID: "", amountOffered: amountOffered, durationWeeks: durationWeeks, description: description, status: "New")
                    
                    self.dbHelper.addInvestmentSuggestion(newOffer) { error in
                        if let error = error {
                            // Handle error if needed
                            print("Error: \(error.localizedDescription)")
                        } else {
                            // Suggestion added successfully, you can navigate or show a confirmation message
                            print("Suggestion added successfully")
                        }
                    }
                }
            } // FORM
            .navigationBarTitle("Add Investment Suggestion")
        }
    }
