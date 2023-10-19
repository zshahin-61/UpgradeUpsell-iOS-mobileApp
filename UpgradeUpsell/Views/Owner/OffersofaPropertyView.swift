//
//  OffersofaProperty.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-10-18.
//

import Foundation
import SwiftUI

struct OffersofaPropertyView: View {
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController

    @State private var suggestions: [InvestmentSuggestion] = []
    @State private var isLoading: Bool = false
    @State private var projectTitle: String = ""
    @State private var updatedStatuses: [String] = [] // Store updated statuses
    @State private var noOffer : String = ""
    
    var selectedProperty: RenovateProject
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Offers").bold().font(.title).foregroundColor(.brown)
            List {
                if dbHelper.userProfile == nil {
                    Text("No user login")
                } else if isLoading {
                    ProgressView()
                } else {
                    
                    HStack {
                        Text("Title:").bold()
                        Spacer()
                        Text("\(projectTitle)")
                    }
                    
                    HStack{
                        Spacer()
                        Text(self.noOffer).foregroundColor(.red)
                        Spacer()
                    }
                    
                    ForEach(suggestions.indices, id: \.self) { index in
                        Section {
                            HStack {
                                Text("Offer Date:").bold()
                                Spacer()
                                Text("\(dateFormatter.string(from: suggestions[index].date ?? Date()))")
                            }
                            Group {
                                HStack {
                                    NavigationLink(destination: InvestorProfileView(investorID: suggestions[index].investorID).environmentObject(self.authHelper).environmentObject(self.dbHelper)) {
                                        Text("Investor:").bold()
                                        Spacer()
                                        Text(suggestions[index].investorFullName).foregroundColor(Color.blue) // Link to Investor Profile
                                    }
                                }
                                
                                HStack {
                                    Text("Offered amount:").bold()
                                    Spacer()
                                    Text(String(format: "%.2f", suggestions[index].amountOffered))
                                }
                                
                                HStack {
                                    Text("Duration:").bold()
                                    Spacer()
                                    Text("\(suggestions[index].durationWeeks) Weeks")
                                }
                            }
                            HStack {
                                Text("Status:").bold()
                                Spacer()
                                Picker("Status", selection: $suggestions[index].status) {
                                    Text("Pending").tag("Pending")
                                    Text("Accept").tag("Accept")
                                    Text("Declined").tag("Declined")
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            HStack {
                                Text("\(suggestions[index].description)")
                            }
                            
                        }
                        Divider()
                    }
                    
                }
            } //List

            HStack(alignment: .center) {
                Spacer()
                Button(action: {
                    saveUpdatedStatuses()
                }) {
                    Text("Save status changes")
                }.buttonStyle(.borderedProminent)
                Spacer()
            }
            .onAppear {
                if let projectID = self.selectedProperty.id {
                    self.projectTitle = self.selectedProperty.title
                    self.isLoading = true
                    self.dbHelper.getInveSuggByProjectID(projectID: projectID) { (suggestions, error) in
                        self.isLoading = false
                        if let error = error {
                            print("Error getting investment suggestions: \(error)")
                        } else if let suggestions = suggestions {
                            if(suggestions.count>0){
                                self.noOffer = ""
                                self.suggestions = suggestions
                                self.updatedStatuses = suggestions.map { $0.status }
                            }
                            else
                            {
                                self.noOffer = "NO OFFER"
                            }
                        }
                        else
                        {
                            self.noOffer = "NO OFFER"
                        }
                    }
                }
            }
            Spacer()
                .navigationTitle("Offers")
        }
    }

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // Function to save updated statuses to the database
    func saveUpdatedStatuses() {
        for (index, suggestion) in suggestions.enumerated() {
            // Check if the status has been updated
            if suggestion.status != updatedStatuses[index] {
                // Update the status in the database
                dbHelper.updateInvestmentStatus(suggestionID: suggestion.id!, newStatus: suggestion.status) { error in
                    if let error = error {
                        print("Error updating status for offer: \(error)")
                    } else {
                        // Insert a notification in Firebase
                        let notification = Notifications(
                            id: UUID().uuidString,
                            timestamp: Date(),
                            userID: suggestion.investorID,
                            event: "Project Status Change",
                            details: "Project titled '\(suggestion.projectTitle)' has been changed to \(suggestion.status).",
                            isRead: false,
                            projectID: suggestion.projectID
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
            }
        }
    }
}

