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
    @State private var filteredSuggestions: [InvestmentSuggestion] = []
    @State private var isLoading: Bool = false
    
    @State private var isChatEnabled: [Bool] = []
    @State private var searchText = ""
    
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        VStack {
            Text("My Offers").bold().font(.title).foregroundColor(.brown)
                .padding(.horizontal,10)
            SearchBar(text: $searchText, placeholder: "Search by title")
            
            if dbHelper.userProfile == nil {
                Text("No user logged in")
            } else {
                if isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        ForEach(filteredSuggestions.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 5) {
                                Section{
                                    Text(filteredSuggestions[index].projectTitle)
                                        .font(.headline)
                                    //.bold()
                                        .foregroundColor(Color(red: 0.0, green: 0.40, blue: 0.0))
                                    
                                    HStack {
                                        Text("Offered Amount:")
                                        Spacer()
                                        Text(String(format: "$%.2f", filteredSuggestions[index].amountOffered))
                                    }
                                    
                                    HStack {
                                        Text("Duration:")
                                        Spacer()
                                        Text("\(filteredSuggestions[index].durationWeeks) Weeks")
                                    }
                                    
                                    HStack {
                                        Text("Status:")
                                        Spacer()
                                        Text(filteredSuggestions[index].status).foregroundColor(statusColor(for: filteredSuggestions[index].status))
                                    }
                                    
                                    Text(filteredSuggestions[index].description)
                                }//Section
                                if(filteredSuggestions[index].status != "Accept"){
                                    Button(action: {
                                        // Call the function to delete the offer
                                        showDeleteConfirmation = true
                                    }) {
                                        Text("Delete")
                                            .foregroundColor(.red)
                                    }
                                    .alert("Confirmation", isPresented: $showDeleteConfirmation) {
                                        Button("Delete", role: .destructive) {
                                            deleteSuggestion(filteredSuggestions[index])
                                            
                                        }
                                        Button("Cancel", role: .cancel) {}
                                    }
                                }
                                else{
                                    HStack {
                                        NavigationLink(destination: OwnerProfileView(ownerID: filteredSuggestions[index].ownerID).environmentObject(self.authHelper).environmentObject(self.dbHelper)) {
                                            //                                    Text("Owner:").bold()
                                            //                                    Spacer()
                                            Text("Owner Profile") .foregroundColor(.blue)// Link to Investor Profile
                                        }
                                    }
                                }//else
                            }//VStack
                            .padding(10)
                            //                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemBackground)))
                            //                            .padding(.horizontal)
                            //                            .listRowBackground(Color.clear)
                            .background(RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray, lineWidth: 1.0) // Add border
                                .background(Color(.systemBackground))).padding(.horizontal)
                                .padding(.horizontal, 5)
                        }
                        // .onDelete(perform: deleteSuggestion2)
                    }//list
                    .padding(.vertical, 5)
                }
            }
        }
        //.navigationBarTitle("My Offers", displayMode: .inline)
        .onAppear {
            loadSuggestions()
        }
        .onChange(of: searchText) { _ in
            // Update filteredSuggestions based on the search text
            filterSuggestions()
        
        }
    }
    
    //load suggestions
    private func loadSuggestions(){
        if let investorID = dbHelper.userProfile?.id {
            isLoading = true
            dbHelper.getInveSuggByInvestorID(investorID: investorID) { (suggestions, error) in
                if let error = error {
#if DEBUG
                    print("Error getting investment suggestions: \(error)")
                    #endif
                } else if let suggestions = suggestions {
                    self.suggestions = suggestions
                    filterSuggestions()
                    isLoading = false
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
        
        self.isChatEnabled = Array(repeating: false, count: filteredSuggestions.count)
        DispatchQueue.global().async {
            let chatPermissions = filteredSuggestions.map { suggestion in
                fetchChatPermissionStatus(sugg: suggestion) { canChat in
                    // This closure is called when the asynchronous call is completed
                    DispatchQueue.main.async {
                        self.isChatEnabled.append(canChat)
                    }
                }
            }
        }
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
                print("Error inserting notification.")
#endif
            }
        }
    }
    
    // Function to delete an offer
//    func deleteSuggestion2(at offsets: IndexSet) {
//        for index in offsets {
//            let suggestion = suggestions[index]
//            // Implement the logic to delete the offer from your data source (e.g., Firestore)
//            dbHelper.deleteSuggestion(suggestion) { (success, error) in
//                if success {
//                    // Delete was successful
//                    suggestions.remove(at: index)
//                    insertNotif(suggestion, "Delete")
//                } else if let error = error {
//#if DEBUG
//                    print("Error deleting suggestion: \(error)")
//                    #endif
//                }
//            }
//        }
//    }
    
    func deleteSuggestion(_ suggestion: InvestmentSuggestion) {
        // Implement the logic to delete the offer from your data source (e.g., Firestore)
        self.dbHelper.deleteSuggestion(suggestion) { (success, error) in
            if success {
                loadSuggestions()
                // Delete was successful
                insertNotif(suggestion, "Delete")
                if let index = suggestions.firstIndex(where: { $0.id == suggestion.id }) {
                    suggestions.remove(at: index)
                }
            } else if let error = error {
#if DEBUG
                print("Error deleting suggestion: \(error)")
                #endif
            }
            
        }
    }
    
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
    
    // Function to fetch chat permission status for the current user\
    private func fetchChatPermissionStatus(sugg: InvestmentSuggestion, completion: @escaping (Bool) -> Void) {
        dbHelper.fetchChatPermission(user1: sugg.ownerID, user2: sugg.investorID) { (permission, error) in
            if let error = error {
#if DEBUG
                print("Error fetching chat permission: \(error)")
                #endif
                completion(false)
                return
            }

            if let permission = permission {
#if DEBUG
                print("Chat permission fetched successfully. canChat: \(permission.canChat)")
#endif
                completion(permission.canChat)
            } else {
                completion(false)
            }
        }
    }
//    private  func fetchChatPermissionStatus(sugg: InvestmentSuggestion) -> Bool {
//        var result = false
//        dbHelper.fetchChatPermission(user1: sugg.ownerID, user2: sugg.investorID) { (permission, error) in
//            if let error = error {
//               result = false
//                print("errorrrrr:\(error)")
//                return
//            }
//
//            if let permission = permission {
//               result = permission.canChat
//                print("permission.canChat:\(permission.canChat)")
//            } else {
//                result = false
//            }
//        }
//        print("resultttttttt:\(result)")
//        return result
//    }
    
}
