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
            VStack(alignment: .leading, spacing: 10) {
                List {
                    if dbHelper.userProfile == nil {
                        Text("No user login")
                    } else if isLoading {
                        ProgressView()
                    } else {
                        ForEach(suggestions, id: \.id) { suggestion in
                            Section {
                                HStack {
                                    Text("Title:").bold()
                                    Spacer()
                                    Text("\(suggestion.projectTitle)")
                                }
                                Group {
//                                    HStack {
//                                        NavigationLink(destination: InvestorProfileView(investorID: suggestion.investorID).environmentObject(self.authHelper).environmentObject(self.dbHelper)) {
//                                            Text("Investor:").bold()
//                                            Spacer()
//                                            Text(suggestion.investorFullName) // Link to Investor Profile
//                                        }
//                                    }
                                    
                                    HStack {
                                        Text("Offered amount:").bold()
                                        Spacer()
                                        Text(String(format: "%.2f", suggestion.amountOffered))
                                    }
                                    
                                    HStack {
                                        Text("Duration:").bold()
                                        Spacer()
                                        Text("\(suggestion.durationWeeks) Weeks")
                                    }
                                }
                                HStack {
                                    Text("Status:").bold()
                                    Spacer()
                                    Text(suggestion.status)
                                }
                                
                                HStack {
                                    Text("\(suggestion.description)")
                                }
                            }
                        }
                    }
                }
                .padding()
                
                .onAppear {
                    print("Aryaaaaa")
                    if let investorID = dbHelper.userProfile?.id {
                        self.isLoading = true
                        print("Golnazzzzzz")
                        self.dbHelper.getInveSuggByInvestorID(investorID: investorID) { (suggestions, error) in
                            if let error = error {
                                print("Error getting investment suggestions: \(error)")
                            } else if let suggestions = suggestions {
                                self.suggestions = suggestions
                                print("Received \(suggestions.count) suggestions")
                                self.isLoading = false
                            }
                        }
                    }
                }
                Spacer()
            }
        }
    }
