//
//  ChatView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-10.
//

import SwiftUI

struct ChatView: View {
    //@Environment(\.presentationMode) var presentationMode
    @State private var messageText = ""
    @EnvironmentObject var dbHelper: FirestoreController
    
    @State private var senderUserID: String = "" // Current user's ID
    var receiverUserID: String // ID of the user you're chatting with

    var body: some View {
        VStack {
            if dbHelper.messages.isEmpty {
                if dbHelper.isLoadingMessages {
                    // Loading indicator
                    ProgressView("Loading messages...")
                } else {
                    // Placeholder for no messages
                    Text("No messages yet.")
                        .foregroundColor(.secondary)
                        .italic()
                }
                
            }else {
                // Use ScrollViewReader to initialize scrollView
                ScrollViewReader { scrollView in
                    List(dbHelper.messages, id: \.id) { message in
                        ChatMessageView(message: message, isSender: message.senderId == senderUserID)
                    }//List
                    .onAppear {
                        // Initialize scrollView when the List appears
                        DispatchQueue.main.async {
                            withAnimation {
                                scrollView.scrollTo(dbHelper.messages.last?.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: dbHelper.messages) { _ in
                        // Scroll to the last message whenever new messages are added
                        DispatchQueue.main.async {
                            withAnimation {
                                scrollView.scrollTo(dbHelper.messages.last?.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            HStack {
                TextField("Type a message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 8) // Add padding to the bottom of the text field
                
                Button("Send") {
                    sendMessage()
                }
                .padding(.trailing)
            }
            .padding()
            
            .onAppear(){
                if let currentUser = dbHelper.userProfile?.id {
                    self.senderUserID = currentUser
                    self.listenForMessages()
                }
            }
            .navigationBarTitle("Chat", displayMode: .inline)
        }
    }
    
    private func listenForMessages() {
        if let currentUser = dbHelper.userProfile?.id {
            dbHelper.listenForMessages(user1: currentUser, user2: receiverUserID) { messages in
                dbHelper.messages = messages
                // Scroll to the last message whenever new messages are added
                // scrollToLastMessage()
            }
        }
    }

    private func sendMessage() {
        guard !messageText.isEmpty else { return }

        guard let sender = dbHelper.userProfile?.id else {return}
        
        let messageData = ChatMessage(id: UUID().uuidString, senderId: sender, receiverId: self.receiverUserID, content: messageText, timestamp: Date())

        self.dbHelper.sendMessage(message: messageData){(error) in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                messageText = ""
            }
        }
        
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()


struct ChatMessageView: View {
    let message: ChatMessage
    let isSender: Bool
    
    var body: some View {
        HStack {
            if isSender {
                Spacer()
            }
            
            Text("\(message.content) - \(message.timestamp, formatter: dateFormatter)")
                .padding(10)
                .background(isSender ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            
            
            if !isSender {
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
