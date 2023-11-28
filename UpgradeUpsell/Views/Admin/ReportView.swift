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

        @State private var isShowingAlert = false
        @State private var alertMessage = ""
        
        
        
        var body: some View {
          VStack {
//            //sample
//                if dbHelper.userProfile == nil {
//                    Text("No user logged in")
//                } else {
//                    if isLoading {
//                        ProgressView()
//                    } else {
//                        List {
//                            ForEach(suggestions) { suggestion in
//                                VStack(alignment: .leading, spacing: 10) {
//                                    Text(suggestion.projectTitle)
//                                        .font(.title)
//                                        .bold()
//                                        .foregroundColor(Color(red: 0.0, green: 0.40, blue: 0.0))
//                                    
//                                    HStack {
//                                        Text("Offered Amount:")
//                                        Spacer()
//                                        Text(String(format: "$%.2f", suggestion.amountOffered))
//                                        Spacer()
//                                        
//                                    }
//                                  
//                                    HStack {
//                                        Text("Duration:")
//                                        Spacer()
//                                        Text("\(suggestion.durationWeeks) Weeks")
//                                    }
//
//                                    HStack {
//                                        Text("Status:")
//                                        Spacer()
//                                        Text(suggestion.status)
//                                    }
//
//                                    Text(suggestion.description)
//                                    HStack{
//                                        Button(action: {
//                                                                                let chatPermissionID = [suggestion.investorID, suggestion.ownerID].sorted().joined(separator: "_")
//
//                                                                                if let chatPermission = dbHelper.getChatPermission(id: chatPermissionID) {
//                                                                                    // Chat permission exists, check canChat status
//                                                                                    if chatPermission.canChat {
//                                                                                        // Call the function to disable chat
//                                                                                        dbHelper.createChatPermission(id: chatPermissionID, canChat: false) { error in
//                                                                                            handleChatPermissionResult(error: error)
//                                                                                        }
//                                                                                    } else {
//                                                                                        // Call the function to enable chat
//                                                                                        dbHelper.createChatPermission(user1: )(id: chatPermissionID, canChat: true) { error in
//                                                                                            handleChatPermissionResult(error: error)
//                                                                                        }
//                                                                                    }
//                                                                                } else {
//                                                                                    // Chat permission doesn't exist, create a new one and enable chat
//                                                                                    dbHelper.createChatPermission(id: chatPermissionID, canChat: true) { error in
//                                                                                        handleChatPermissionResult(error: error)
//                                                                                    }
//                                                                                }
//                                                                            }) {
//                                                                                Text(canChatButtonTitle(for: suggestion))
//                                                                            }
////                                        Button(action: {
////                                            
////                                            dbHelper.createChatPermission(user1: suggestion.ownerID, user2: suggestion.investorID, canChat: true) { error in
////                                                if let error = error {
////                                                    print("Error creating ChatPermission: \(error)")
////                                                    alertMessage = "Error creating ChatPermission: \(error)"
////                                                } else {
////                                                    alertMessage = "ChatPermission created successfully"
////                                                    print("ChatPermission created successfully")
////                                                }
////                                                
////                                                isShowingAlert = true
////                                                
////                                            }
////                                            
////                                        }) {
////                                            Text("Enable Chat")
////                                                                               }
//                                    }
//                                    
//                                }
//                                .padding(10)
//                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemBackground)))
//                                .padding(.horizontal)
//                                .listRowBackground(Color.clear)
//                            }
//                            
//                        }
//                        .padding(.vertical, 10)
//                    }
//                }
//            }
//            .alert(isPresented: $isShowingAlert) {
//                        Alert(
//                            title: Text("Alert Message"),
//                            message: Text(alertMessage),
//                            dismissButton: .default(Text("OK"))
//                        )
//                    }
//            .onAppear {
//               if let investorID = dbHelper.userProfile?.id {
//                    isLoading = true
//                    dbHelper.getAcceptedInvestmentSuggestions { (suggestions, error) in
//                        if let error = error {
//                            print("Error getting investment suggestions: \(error)")
//                        } else if let suggestions = suggestions {
//                            self.suggestions = suggestions
//                          isLoading = false
//                        }
//                    }
//               }
//            }
//
//        }
//        
//        //handleChatPermissionResult
//        private func canChatButtonTitle(for suggestion: InvestmentSuggestion) -> String {
//                let chatPermissionID = [suggestion.investorID, suggestion.ownerID].sorted().joined(separator: "_")
//                let canChat = dbHelper.getChatPermission(id: chatPermissionID)?.canChat ?? false
//                return canChat ? "Disable Chat" : "Enable Chat"
//            }
//        
//        private func handleChatPermissionResult(error: Error?) {
//                if let error = error {
//                    print("Error handling ChatPermission: \(error)")
//                    alertMessage = "Error handling ChatPermission: \(error)"
//                } else {
//                    alertMessage = "ChatPermission updated successfully"
//                    print("ChatPermission updated successfully")
//                }
//                isShowingAlert = true
//            }
//
//        //insert in notifications
//        func insertNotif(_ myOffer : InvestmentSuggestion, _ a : String){
//            
//            var flName = ""
//            if let fullName = dbHelper.userProfile?.fullName{
//                flName = fullName
//            }
//            
//            let notification = Notifications(
//                id: UUID().uuidString,
//                timestamp: Date(),
//                userID: myOffer.ownerID,
//                event: "Offer \(a)!",
//                details: "Offer $\(myOffer.amountOffered) for project titled \(myOffer.projectTitle) has been \(a) By \(flName).",
//                isRead: false,
//                projectID: myOffer.projectID
//            )
//            dbHelper.insertNotification(notification) { notificationSuccess in
//                if notificationSuccess {
//                    print("Notification inserted successfully.")
//                } else {
//                    print("Error inserting notification.")
//                }
           }
       }
//     
    }
