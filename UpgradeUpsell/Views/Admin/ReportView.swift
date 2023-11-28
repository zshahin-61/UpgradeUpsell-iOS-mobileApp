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
        
        @State private var isLoading: Bool = false

        @State private var isShowingAlert = false
        @State private var alertMessage = ""
        
        @State private var isChatEnabled: [Bool] = []
        @State private var searchText = ""
        
        var body: some View {
            VStack {
            //sample
                Text("My Offers").bold().font(.title).foregroundColor(.brown)
                    .padding(.horizontal,10)
                SearchBar(text: $searchText, placeholder: "Search by title")
                
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
                                        .font(.headline)
                                        //.bold()
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
                                            
                                            dbHelper.createChatPermission(user1: suggestion.ownerID, user2: suggestion.investorID, canChat: true) { error in
                                                if let error = error {
                                                    print("Error creating ChatPermission: \(error)")
                                                    alertMessage = "Error creating ChatPermission: \(error)"
                                                } else {
                                                    alertMessage = "ChatPermission created successfully"
                                                    print("ChatPermission created successfully")
                                                }
                                                
                                                isShowingAlert = true
                                                
                                            }
                                            
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
                    print("Notification inserted successfully.")
                } else {
                    print("Error inserting notification.")
                }
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
        
    }
