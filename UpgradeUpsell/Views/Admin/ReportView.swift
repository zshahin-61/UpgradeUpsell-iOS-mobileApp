//
//  ReportView.swift
//  UpgradeUpsell
//
//  Created by zahra SHAHIN on 2023-10-31.
//

    import SwiftUI

    struct ReportView: View {
       
        @EnvironmentObject var authHelper: FireAuthController
        @EnvironmentObject var dbHelper: FirestoreController

        @State private var suggestions: [InvestmentSuggestion] = []
        @State private var isLoading: Bool = false

        
        var body: some View {
            VStack {
            //sample
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
                                        Spacer()
                                        
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
                                    HStack{
                                                                             
                                        Button(action: {
                                            //  deleteSuggestion(suggestion)
                                        }) {
                                            Text("Enable Chat")
                                                                               }
                                    }
                                    
                                }
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemBackground)))
                                .padding(.horizontal)
                                .listRowBackground(Color.clear)
                            }
                            
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
            .onAppear {
               if let investorID = dbHelper.userProfile?.id {
                    isLoading = true
                    dbHelper.getAcceptedInvestmentSuggestions { (suggestions, error) in
                        if let error = error {
                            print("Error getting investment suggestions: \(error)")
                        } else if let suggestions = suggestions {
                            self.suggestions = suggestions
                          isLoading = false
                        }
                    }
               }
            }

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
     
    }
