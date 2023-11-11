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
    
    @State private var isChatEnabled: [Bool] = []
    
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
                        ForEach(suggestions.indices, id: \.self) { index in
                            VStack(alignment: .leading, spacing: 10) {
                                Section{
                                    Text(suggestions[index].projectTitle)
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(Color(red: 0.0, green: 0.40, blue: 0.0))
                                    
                                    HStack {
                                        Text("Offered Amount:")
                                        Spacer()
                                        Text(String(format: "$%.2f", suggestions[index].amountOffered))
                                    }
                                    
                                    HStack {
                                        Text("Duration:")
                                        Spacer()
                                        Text("\(suggestions[index].durationWeeks) Weeks")
                                    }
                                    
                                    HStack {
                                        Text("Status:")
                                        Spacer()
                                        Text(suggestions[index].status).foregroundColor(statusColor(for: suggestions[index].status))
                                    }
                                    
                                    Text(suggestions[index].description)
                                }//Section
                                if(suggestions[index].status != "Accept"){
                                    Button(action: {
                                        deleteSuggestion(suggestions[index]) // Call the function to delete the offer
                                    }) {
                                        Text("Delete")
                                            .foregroundColor(.red)
                                    }
                                }
                        else{
                                    //fetchChatPermissionStatus(user1: suggestion.ownerID)
                                    if(isChatEnabled[index]){
                                        
                                        NavigationLink(destination: ChatView(receiverUserID: suggestions[index].ownerID).environmentObject(dbHelper)) {
                                            Text("Chat with Owner")
                                        }
                                    } //if
                                }//else
                            }//VStack
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
                        self.isChatEnabled = Array(repeating: false, count: suggestions.count)
//                        self.isChatEnabled = suggestions.map{$0.status != "Accept"  ? false : fetchChatPermissionStatus(sugg: $0)  }
                        DispatchQueue.global().async {
                                            let chatPermissions = suggestions.map { suggestion in
                                                fetchChatPermissionStatus(sugg: suggestion) { canChat in
                                                    // This closure is called when the asynchronous call is completed
                                                    DispatchQueue.main.async {
                                                        self.isChatEnabled.append(canChat)
                                                    }
                                                }
                                            }

                                            // No need to update UI here
                                        }
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
                print("Error fetching chat permission: \(error)")
                completion(false)
                return
            }

            if let permission = permission {
                print("Chat permission fetched successfully. canChat: \(permission.canChat)")
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
