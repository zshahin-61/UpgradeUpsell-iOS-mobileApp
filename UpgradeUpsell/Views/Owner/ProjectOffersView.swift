import Foundation
import SwiftUI

struct ProjectOffersView: View {
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController

    @State private var suggestions: [InvestmentSuggestion] = []
    @State private var filteredSuggestions: [InvestmentSuggestion] = []
    @State private var isLoading: Bool = false
    @State private var updatedStatuses: [String] = [] // Store updated statuses
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    
    @State private var isStatusUpdated: [Bool] = []
    //@State private var hasChatPermission: [Bool] = []
    
    @State private var searchText = ""

    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Spacer()
                Text("Offers").bold().font(.title).foregroundColor(.brown)
                Spacer()
            }
            SearchBar(text: $searchText, placeholder: "Search by title")
            ScrollView {
                if dbHelper.userProfile == nil {
                    Text("No user login")
                } else if isLoading {
                    ProgressView()
                } else {
                    ForEach(filteredSuggestions.indices, id: \.self) { index in
                        Section {
                            VStack(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 1) {
                                    Text("Title").font(.subheadline).foregroundColor(.gray)
                                    //   Spacer()
                                    Text("\(filteredSuggestions[index].projectTitle)")
                                }.padding(.top, 1)
                                
                                VStack(alignment: .leading, spacing: 1) {
                                    Text("Offer Date").font(.subheadline).foregroundColor(.gray)
                                    //    Spacer()
                                    Text("\(dateFormatter.string(from: filteredSuggestions[index].date ?? Date()))")
                                }.padding(.top, 1)
                                Group {
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text("Investor").font(.subheadline).foregroundColor(.gray)
                                        NavigationLink(destination: InvestorProfileView(investorID: filteredSuggestions[index].investorID).environmentObject(self.authHelper).environmentObject(self.dbHelper)) {
                                            
                                            // Spacer()
                                            Text(filteredSuggestions[index].investorFullName) .foregroundColor(.blue)// Link to Investor Profile
                                        }
                                    }.padding(.top, 1)
                                    
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text("Investment Offer").font(.subheadline).foregroundColor(.gray)
                                        //    Spacer()
                                        Text(String(format: "%.2f", filteredSuggestions[index].amountOffered))
                                    }.padding(.top, 1)
                                    
                                    VStack(alignment: .leading, spacing: 1) {
                                        Text("Duration").font(.subheadline).foregroundColor(.gray)
                                        //    Spacer()
                                        Text("\(filteredSuggestions[index].durationWeeks) Weeks")
                                    }.padding(.top, 1)
                                }//Group
                                VStack(alignment: .leading, spacing: 1) {
                                    Text("Investor description").font(.subheadline).foregroundColor(.gray)
                                    Text("\(filteredSuggestions[index].description)")
                                }.padding(.top, 1)
                                    .padding(.bottom, 1)
                                
                                if !isStatusUpdated[index]  {
                                    // if suggestions[index].status == "Pending" {
                                    HStack {
                                        Text("Status:").font(.subheadline).foregroundColor(.gray)
                                        Spacer()
                                        Picker("Status", selection: $filteredSuggestions[index].status) {
                                            Text("Pending").tag("Pending")
                                            Text("Accept").tag("Accept")
                                            Text("Declined").tag("Declined")
                                        }
                                        .pickerStyle(SegmentedPickerStyle())
                                    }
                                } else {
                                    HStack {
                                        Text("Status:").font(.subheadline).foregroundColor(.gray)
                                        Spacer()
                                        
                                        Text(filteredSuggestions[index].status)
                                            .foregroundColor(statusColor(for: filteredSuggestions[index].status))
                                    } //hstack
                                    //                                    if(suggestions[index].status == "Accept"){
                                    //                                        HStack {
                                    //                                            Text("You can chat with the user after approved by the administrator")
                                    //                                            NavigationLink(destination: ChatView(reciverUserId: suggestions[index].investorID)) {
                                    //                                                Text("Chat with Investor")
                                    //                                            }
                                    //                                            .disabled(!isStatusUpdated[index] || !hasChatPermission[index])
                                    //                                        }
                                    //                                    } //if
                                } // esle
                                
                            }
                        }//Section
                        .padding()
                        //.border(Color.gray, width: 0.5)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.gray, lineWidth: 1.0)
                            .background(Color(.systemBackground)))
                        //.contentMargins(5)
                        .padding()
                        //.listRowInsets(EdgeInsets())
                        Divider()
                    }
                }
            }//List

            HStack(alignment: .center) {
                Spacer()
                Button(action: {
                    updateOfferStatuses()
                }) {
                    Text("Save status changes")
                }.buttonStyle(.borderedProminent)
                Spacer()
            }
            
            Spacer()
        }
        .onAppear {
            //print("i am sadddd")
            loadSuggestions()
        }
        .onChange(of: searchText) { _ in
            // Update filteredSuggestions based on the search text
            filterSuggestions()
        
        }
        .alert(isPresented: $isShowingAlert) {
                    Alert(
                        title: Text("Alert Message"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
       // .padding(.vertical, 5)
    }

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    //
    
    // load suggestions
   private func loadSuggestions (){
        if let ownerID = dbHelper.userProfile?.id {
            self.isLoading = true
            self.dbHelper.getInveSuggByOwnerID(ownerID: ownerID) { (suggestions, error) in
                self.isLoading = false
                if let error = error {
#if DEBUG
                    print("Error getting investment suggestions: \(error)")
                    #endif
                } else if let suggestions = suggestions {
                    self.suggestions = suggestions
                    filterSuggestions()
                }
            }
        }
    }
    
    //filter suggestions
    private func filterSuggestions(){
        if(!searchText.isEmpty){
            filteredSuggestions = suggestions.filter {
                $0.projectTitle.localizedCaseInsensitiveContains(searchText.lowercased())
                
            }
        }else{
            filteredSuggestions = suggestions
        }
        
        self.updatedStatuses = filteredSuggestions.map { $0.status }
       // isStatusUpdated = Array(repeating: false, count: suggestions.count)
        self.isStatusUpdated = filteredSuggestions.map { $0.status == "Pending" ? false : true }
    }
    
    // Function to save updated statuses to the database
    func updateOfferStatuses() {
        for (index, suggestion) in filteredSuggestions.enumerated() {
            // Check if the status has been updated
            if suggestion.status != updatedStatuses[index] {
                // Update the status in the database
                dbHelper.updateInvestmentStatus(suggestionID: suggestion.id!, newStatus: suggestion.status) { error in
                    if let error = error {
#if DEBUG
                        print("Error updating status for offer: \(error)")
                        #endif
                    } else {
                        isStatusUpdated[index] = true
                        if suggestion.status == "Accept" { // Check if the status is "Accept"
                            updatePropertyStatus(propertyID: suggestion.projectID, status: "In Progress")
                                            }
                        else if suggestion.status == "Pending" { // Check if the status is "Accept"
                            updatePropertyStatus(propertyID: suggestion.projectID, status: "Released")
                                            }
                        else if suggestion.status == "Declined" { // Check if the status is "Accept"
                            updatePropertyStatus(propertyID: suggestion.projectID, status: "Released")
                                            }
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
#if DEBUG
                                print("Notification inserted successfully.")
                                #endif
                            } else {
#if DEBUG
                                print("Error inserting notification.")
                                #endif
                            }
                        }
                        
                        // Set the alert message
                                               alertMessage = "Status updated successfully."
                                               isShowingAlert = true
                    }
                }
            }
        }
    }
    
    // Function to update the property status to "InProgress"
    func updatePropertyStatus(propertyID: String, status: String) {
        // Update the property status to "InProgress" in the database
        dbHelper.updatePropertyStatus(propertyID: propertyID, newStatus: status) { error in
            if let error = error {
#if DEBUG
                print("Error updating property status to InProgress: \(error)")
                #endif
            } else {
#if DEBUG
                print("Property status updated to InProgress.")
                #endif
            }
        }
    }

    // Function to fetch chat permission status for the current user
//    private  func fetchChatPermissionStatus(sugg: InvestmentSuggestion) -> Bool {
//        var result = false
//        dbHelper.fetchChatPermission(user1: sugg.ownerID, user2: sugg.investorID) { (permission, error) in
//            if let error = error {
//               result = false
//                return
//            }
//
//            if let permission = permission {
//               result = permission.canChat
//            } else {
//                result = false
//            }
//        }
//        return result
//    }
//    
    
    func statusColor(for status: String) -> Color {
        switch status {
        case "Pending":
            return .yellow
        case "Accept":
            return .green
        case "Declined":
            return .red
        default:
            return .black
        }
    }

}
