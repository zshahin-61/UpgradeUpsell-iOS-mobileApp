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
        @State private var filteredSuggestions: [InvestmentSuggestion] = []
        @State private var chatButtonTitles: [String] = []
        
        @State private var isLoading: Bool = false

        @State private var isShowingAlert = false
        @State private var alertMessage = ""
        
       // @State private var isChatEnabled: [Bool] = []
        @State private var searchText = ""
        
        @State private var ownerNames: [String: String] = [:]
        
        var body: some View {
            VStack {
                //sample
                Text("Accepted Offers").bold().font(.title).foregroundColor(.brown)
                    .padding(.horizontal,10)
                SearchBar(text: $searchText, placeholder: "Search by Title or Investor or Owner ")
                
                if dbHelper.userProfile == nil {
                    Text("No user logged in")
                } else {
                    if isLoading {
                        ProgressView()
                    } else {
                        ScrollView {
                            ForEach(filteredSuggestions.indices, id: \.self) { index in
                                VStack(alignment: .leading, spacing: 10) {
                                    //                                    Text(filteredSuggestions[index].projectTitle)
                                    //                                        .font(.headline)
                                    //                                    //.bold()
                                    //                                        .foregroundColor(Color(red: 0.0, green: 0.40, blue: 0.0))
                                    //
                                    //                                    HStack {
                                    //                                        Text("Investor:")
                                    //                                        Spacer()
                                    //                                        Text(filteredSuggestions[index].investorFullName)
                                    //                                        Spacer()
                                    //
                                    //                                    }
                                    //
                                    ////                                    HStack {
                                    ////                                        Text("Owner:")
                                    ////                                        Spacer()
                                    ////                                        Text(filteredSuggestions[index].investorFullName)
                                    ////                                        Spacer()
                                    ////
                                    ////                                    }
                                    //
                                    //                                    HStack {
                                    //                                        Text("Offered Amount:")
                                    //                                        Spacer()
                                    //                                        Text(String(format: "$%.2f", filteredSuggestions[index].amountOffered))
                                    //                                        Spacer()
                                    //
                                    //                                    }
                                    //
                                    //                                    HStack {
                                    //                                        Text("Duration:")
                                    //                                        Spacer()
                                    //                                        Text("\(filteredSuggestions[index].durationWeeks) Weeks")
                                    //                                    }
                                    //
                                    //                                    HStack {
                                    //                                        Text("Status:")
                                    //                                        Spacer()
                                    //                                        Text(filteredSuggestions[index].status)
                                    //                                    }
                                    //
                                    //                                    Text(filteredSuggestions[index].description)
                                    
                                    Section{
                                        Text(filteredSuggestions[index].projectTitle)
                                            .font(.headline)
                                        //.bold()
                                            .foregroundColor(Color(red: 0.0, green: 0.40, blue: 0.0))
                                        
                                        HStack {
                                            Text("Owner:")
                                            Spacer()
                                            Text(ownerNames[filteredSuggestions[index].ownerID] ?? "Unknown Owner")
                                        }
                                        
                                        HStack {
                                            Text("Investor:")
                                            Spacer()
                                            Text(filteredSuggestions[index].investorFullName)
                                        }
                                        
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
                                        
                                        Text(filteredSuggestions[index].description)
                                    }//Section
                                    
                                    HStack{
                                        Spacer()
                                        Button(action: {
                                            // Fetch the current chat permission status
                                            dbHelper.fetchChatPermission(user1: filteredSuggestions[index].ownerID, user2: filteredSuggestions[index].investorID) { (permission, error) in
                                                if let error = error {
                                                    print("Error fetching chat permission: \(error)")
                                                    // Handle the error as needed
                                                    return
                                                }
                                                
                                                // Determine the new chat permission status
                                                let newCanChat = !(permission?.canChat ?? false)
                                                
                                                // Update the chat permission
                                                dbHelper.createChatPermission(user1: filteredSuggestions[index].ownerID, user2: filteredSuggestions[index].investorID, canChat: newCanChat) { error in
                                                    if let error = error {
                                                        print("Error updating ChatPermission: \(error)")
                                                        // Handle the error as needed
                                                        alertMessage = "Error updating ChatPermission: \(error)"
                                                    } else {
                                                        // Update the button title based on the new chat permission status
                                                        DispatchQueue.main.async {
                                                            //chatButtonTitles[index] = newCanChat ? "Disable Chat" : "Enable Chat"
                                                            alertMessage = "ChatPermission updated successfully"
                                                            print("ChatPermission updated successfully")
                                                        }
                                                    }
                                                    insertNotif(filteredSuggestions[index], chatButtonTitles[index])

                                                    // Show the alert
                                                    isShowingAlert = true
                                                }
                                            }
                                        }) {
                                            Text(chatButtonTitles.indices.contains(index) ? chatButtonTitles[index] : "Enable Chat")
                                            
                                            //Text(canChatButtonTitle(for: filteredSuggestions[index]))
                                            //Text("Chattttttttt")
                                        }.buttonStyle(.borderedProminent)
                                        
                                        Spacer()
                                    }
                                }
                                //                                .padding(10)
                                //                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemBackground)))
                                //                                .padding(.horizontal)
                                //                                .listRowBackground(Color.clear)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(Color.gray, lineWidth: 1.0) // Add border
                                    .background(Color(.systemBackground))).padding(.horizontal)
                                    .padding(.horizontal, 5)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
            .alert(isPresented: $isShowingAlert) {
                        Alert(
                            title: Text("Alert Message"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
            
            .onAppear {
               loadSuggestions()
            }
            .onChange(of: searchText) { _ in
                // Update filteredSuggestions based on the search text
                filterSuggestions()
            
            }
            .onChange(of: isShowingAlert) { _ in
                // Reload data when isShowingAlert changes
                if !isShowingAlert {
                    loadSuggestions()
                }
            }
        }

        //load suggestions
        private func loadSuggestions(){
            if let investorID = dbHelper.userProfile?.id {
                 isLoading = true
                 dbHelper.getAcceptedInvestmentSuggestions { (suggestions, error) in
                     if let error = error {
                         print("Error getting investment suggestions: \(error)")
                     } else if let suggestions = suggestions {
                         self.suggestions = suggestions
                         filterSuggestions()
                         fetchOwnerNames()
                       isLoading = false
                     }
                 }
            }
        }
        
        //filter suggestions
        private func filterSuggestions(){
//            if(!searchText.isEmpty){
//                filteredSuggestions = suggestions.filter {
//                    $0.projectTitle.localizedCaseInsensitiveContains(searchText.lowercased())
//                    
//                }
//            }else{
//                filteredSuggestions = suggestions
//            }
            if !searchText.isEmpty {
                    filteredSuggestions = suggestions.filter { suggestion in
                        let titleMatch = suggestion.projectTitle.localizedCaseInsensitiveContains(searchText.lowercased())
                        let investorMatch = suggestion.investorFullName.localizedCaseInsensitiveContains(searchText.lowercased())
                        let ownerNameMatch = ownerNames[suggestion.ownerID]?.localizedCaseInsensitiveContains(searchText.lowercased()) ?? false
                        
                        return titleMatch || investorMatch || ownerNameMatch
                    }
                } else {
                    filteredSuggestions = suggestions
                }

                updateChatButtonTitles()
        }
        
        private func fetchOwnerNames() {
            let ownerIDs = Set(suggestions.map { $0.ownerID })
            
            for ownerID in ownerIDs {
                dbHelper.getUserProfilebyUserID(userID: ownerID) {(userProfile, error) in
                    if let error = error {
                        print("Error fetching user profile: \(error)")
                    } else if let userProfile = userProfile {
                        DispatchQueue.main.async {
                            self.ownerNames[ownerID] = userProfile.fullName
                        }
                    }
                }
            }
        }
        
        //insert in notifications
        func insertNotif(_ myOffer: InvestmentSuggestion, _ a: String) {
            var flName = ""
            if let fullName = dbHelper.userProfile?.fullName {
                flName = fullName
            }

            // Notification for Investor
            
            var ownerFLName = "N/A"
            if let ownerName = ownerNames[myOffer.ownerID] {
                ownerFLName = ownerName
            }
            
            let investorNotification = Notifications(
                id: UUID().uuidString,
                timestamp: Date(),
                userID: myOffer.investorID,
                event: "Chat permission updated \(a)!",
                details: "\(a)  with \(ownerFLName)  for project titled \(myOffer.projectTitle) by \(flName).",
                isRead: false,
                projectID: myOffer.projectID
            )

            dbHelper.insertNotification(investorNotification) { notificationSuccess in
                if notificationSuccess {
                    print("Investor notification inserted successfully.")
                } else {
                    print("Error inserting investor notification.")
                }
            }

            // Notification for Owner
            let ownerNotification = Notifications(
                id: UUID().uuidString,
                timestamp: Date(),
                userID: myOffer.ownerID,
                event: "Chat permission updated \(a)!",
                details: "\(a) with \(myOffer.investorFullName) for project titled \(myOffer.projectTitle) by \(flName).",
                isRead: false,
                projectID: myOffer.projectID
            )

            dbHelper.insertNotification(ownerNotification) { notificationSuccess in
                if notificationSuccess {
                    print("Owner notification inserted successfully.")
                } else {
                    print("Error inserting owner notification.")
                }
            }
        }

//        func insertNotif(_ myOffer : InvestmentSuggestion, _ a : String){
//            var flName = ""
//            if let fullName = dbHelper.userProfile?.fullName{
//                flName = fullName
//            }
//            
//            let notification = Notifications(
//                id: UUID().uuidString,
//                timestamp: Date(),
//                userID: myOffer.ownerID,
//                event: "Chat permission updated \(a)!",
//                details: "you can/cant chat by $\(myOffer.investorFullName) for project titled \(myOffer.projectTitle) has been \(a) By \(flName).",
//                isRead: false,
//                projectID: myOffer.projectID
//            )
//            dbHelper.insertNotification(notification) { notificationSuccess in
//                if notificationSuccess {
//                    print("Notification inserted successfully.")
//                } else {
//                    print("Error inserting notification.")
//                }
//            }
//        }
     
        //handleChatPermissionResult
//          private func canChatButtonTitle(for suggestion: InvestmentSuggestion) -> String {
//              var canChat = false
//              //let chatPermissionID = [suggestion.investorID, suggestion.ownerID].sorted().joined(separator: "_")
//               fetchChatPermissionStatus(sugg: suggestion){ ( chatEnabled) in
//                       //if let chatEnabled = chatEnabled{
//                       canChat = chatEnabled
//                   print("Aradddddddd\(chatEnabled)")
//                   //}
//              }
//              if canChat {
//                  return "Disable Chat"
//              }
//              else{
//                  return "Enable Chat"
//              }
//            //  return canChat ? "Disable Chat" : "Enable Chat"
//          }
        private func updateChatButtonTitles() {
                chatButtonTitles.removeAll()

                for suggestion in filteredSuggestions {
                    dbHelper.fetchChatPermission(user1: suggestion.ownerID, user2: suggestion.investorID) { (permission, error) in
                        if let error = error {
                            print("Error fetching chat permission: \(error)")
                            return
                        }

                        if let permission = permission {
                            DispatchQueue.main.async {
                                let title = permission.canChat ? "Disable Chat" : "Enable Chat"
                                self.chatButtonTitles.append(title)
                            }
                        }
                        else{
                            let title = "Enable Chat"
                            self.chatButtonTitles.append(title)
                        }
                    }
                }
            }
          
          private func handleChatPermissionResult(error: Error?) {
              if let error = error {
                  print("Error handling ChatPermission: \(error)")
                  alertMessage = "Error handling ChatPermission: \(error)"
              } else {
                  alertMessage = "ChatPermission updated successfully"
                  print("ChatPermission updated successfully")
              }
              isShowingAlert = true
          }

        // Function to fetch chat permission status for the current user\
        private func fetchChatPermissionStatus(sugg: InvestmentSuggestion, completion: @escaping (Bool) -> Void) {
            self.dbHelper.fetchChatPermission(user1: sugg.ownerID, user2: sugg.investorID) { (permission, error) in
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
        
    }
