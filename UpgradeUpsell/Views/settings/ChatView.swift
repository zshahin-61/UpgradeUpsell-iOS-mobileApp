//
//  ChatView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-10.
//

import SwiftUI
//import Firebase

struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var messageText = ""
    //@State private var messages: [ChatMessage] = []
    //@EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    
    @State private var senderUserID: String = "" // Current user's ID
    var receiverUserID: String // ID of the user you're chatting with

    var body: some View {
        VStack {
            List(dbHelper.messages, id: \.id) { message in
                ChatMessageView(message: message, isSender: message.senderId == senderUserID)
            }
            .onAppear(perform: {
                listenForMessages()
            })
            
            HStack {
                TextField("Type a message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button("Send") {
                    sendMessage()
                }
                .padding(.trailing)
            }
            .padding()
            
            .onAppear(){
                if let sender = dbHelper.userProfile?.id {
                    self.senderUserID = sender
                }
            }
            .navigationBarTitle("Chat", displayMode: .inline)
        }
    }
    
    private func listenForMessages() {
        if let currnetUser = dbHelper.userProfile?.id {
            dbHelper.listenForMessages(user1: currnetUser, user2: receiverUserID){ (messages ) in
                dbHelper.messages = messages
            }
        }
            
    }

    private func sendMessage() {
        guard !messageText.isEmpty else { return }

        guard let sender = dbHelper.userProfile?.id else {return}
        
        let messageData = ChatMessage(id: nil, senderId: sender, receiverId: receiverUserID, content: messageText, timestamp: Date())

        dbHelper.sendMessage(message: messageData){(error) in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                messageText = ""
            }
        }
        
    }
}

struct ChatMessageView: View {
    let message: ChatMessage
    let isSender: Bool

    var body: some View {
        HStack {
            if isSender {
                Spacer()
            }

            Text(message.content)
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

//struct ChatMessage: Identifiable {
//    let id: String
//    let content: String
//    let senderID: String
//    let timestamp: Date
//}



