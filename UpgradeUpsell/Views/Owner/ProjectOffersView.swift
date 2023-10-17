import Foundation
import SwiftUI

struct ProjectOffersView: View {
    
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    
    @State private var suggestions: [InvestmentSuggestion] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            List {
                if dbHelper.userProfile == nil {
                    Text("No user login")
                } else if isLoading {
                    ProgressView()
                } else {
                    ForEach(suggestions.indices, id: \.self) { index in
                        Section {
                            HStack {
                                Text("Title:").bold()
                                Spacer()
                                Text("\(suggestions[index].projectTitle)")
                            }
                            HStack {
                                Text("Offer Date:").bold()
                                Spacer()
                                Text("\(dateFormatter.string(from: suggestions[index].date ?? Date()))")
                                //Text("\(suggestions[index].date ?? Date())")
                            }
                            Group {
                                HStack {
                                    NavigationLink(destination: InvestorProfileView(investorID: suggestions[index].investorID).environmentObject(self.authHelper).environmentObject(self.dbHelper)) {
                                        Text("Investor:").bold()
                                        Spacer()
                                        Text(suggestions[index].investorFullName) // Link to Investor Profile
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
                        //.border(Color.green, width: 2)
                        //.shadow(color: Color.gray.opacity(0.5), radius: 0.5)
                        // .background(Color.gray.opacity(0.5) )
                        Divider()
                    }
                    
                }
            } //List
           // .padding()
            HStack(alignment: .center){
                Spacer()
                Button(action: {
                    // Save the updated statuses to the database for each suggestion
                    for suggestion in suggestions {
                        // Update the status in the database
                        // You need to implement the Firestore update logic here.
                        self.dbHelper.updateInvestmentStatus(suggestionID: suggestion.id!, newStatus: suggestion.status) { error in
                            if let error = error {
                                print("Error updating status for offer: \(error)")
                            }else{
                                //Insert Notification
                                
                    // Insert a notification in Firebase
                    let notification = Notifications(
                        id: UUID().uuidString,
                        timestamp: Date(),
                        userID: suggestion.investorID,
                        event: "Project Status Change",
                        details: "Project titled '\(suggestion.projectTitle)' has been Changed To \(suggestion.status).",
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
                }) {
                    Text("Save status changes")
                }.buttonStyle(.borderedProminent)
                Spacer()
            }
            .onAppear {
                if let ownerID = dbHelper.userProfile?.id {
                    self.isLoading = true
                    self.dbHelper.getInveSuggByOwnerID(ownerID: ownerID) { (suggestions, error) in
                        self.isLoading = false
                        if let error = error {
                            print("Error getting investment suggestions: \(error)")
                        } else if let suggestions = suggestions {
                            self.suggestions = suggestions
                        }
                    }
                }
            }
            Spacer()
        }
    }
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
        }()
    
  
                    
}
