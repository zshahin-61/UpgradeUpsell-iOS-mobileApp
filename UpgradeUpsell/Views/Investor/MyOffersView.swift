//
//  MyOffersView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-10-10.
//

import Foundation
import SwiftUI

struct MyOffersView: View {
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController

    @State private var suggestions: [InvestmentSuggestion] = []
    @State private var isLoading: Bool = false

    var body: some View {
        //NavigationView {
            VStack {
                Text("My Offers").bold().font(.title).foregroundColor(.brown)
                    .padding(.horizontal,10)
                if dbHelper.userProfile == nil {
                    Text("No user logged in")
                } else {
                    if isLoading {
                        ProgressView()
                    } else {
                        List {
                            ForEach(suggestions) { suggestion in
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(suggestion.projectTitle)
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(Color(red: 0.0, green: 0.40, blue: 0.0))
                                    
                                    HStack {
                                        Text("Offered Amount:")
                                        Spacer()
                                        Text(String(format: "$%.2f", suggestion.amountOffered))
                                    }

                                    HStack {
                                        Text("Duration:")
                                        Spacer()
                                        Text("\(suggestion.durationWeeks) Weeks")
                                    }

                                    HStack {
                                        Text("Status:")
                                        Spacer()
                                        Text(suggestion.status)
                                    }

                                    Text(suggestion.description)
                                    
                                    Button(action: {
                                                                   deleteSuggestion(suggestion) // Call the function to delete the offer
                                                               }) {
                                                                   Text("Delete")
                                                                       .foregroundColor(.red)
                                                               }
                                }
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemBackground)))
                                .padding(.horizontal)
                                .listRowBackground(Color.clear)
                            }
                            .onDelete(perform: deleteSuggestion2)
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
            .navigationBarTitle("My Offers", displayMode: .inline)
            .onAppear {
                if let investorID = dbHelper.userProfile?.id {
                    isLoading = true
                    dbHelper.getInveSuggByInvestorID(investorID: investorID) { (suggestions, error) in
                        if let error = error {
                            print("Error getting investment suggestions: \(error)")
                        } else if let suggestions = suggestions {
                            self.suggestions = suggestions
                            isLoading = false
                        }
                    }
                }
            }
        //}//nav view
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
    
    // Function to delete an offer
    func deleteSuggestion2(at offsets: IndexSet) {
            for index in offsets {
                let suggestion = suggestions[index]
                // Implement the logic to delete the offer from your data source (e.g., Firestore)
                 dbHelper.deleteSuggestion(suggestion) { (success, error) in
                     if success {
                         // Delete was successful
                         suggestions.remove(at: index)
                         insertNotif(suggestion, "Delete")
                     } else if let error = error {
                         print("Error deleting suggestion: \(error)")
                     }
                 }
            }
        }
    
        func deleteSuggestion(_ suggestion: InvestmentSuggestion) {
            // Implement the logic to delete the offer from your data source (e.g., Firestore)
            self.dbHelper.deleteSuggestion(suggestion) { (success, error) in
                 if success {
                     // Delete was successful
                     insertNotif(suggestion, "Delete")
                     if let index = suggestions.firstIndex(where: { $0.id == suggestion.id }) {
                         suggestions.remove(at: index)
                     }
                 } else if let error = error {
                     print("Error deleting suggestion: \(error)")
                 }
             }
        }
}
