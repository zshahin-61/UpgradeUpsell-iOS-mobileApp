//
//  ChatView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-10.
//

import SwiftUI
import Firebase
import FirebaseFirestore



struct ChatView: View {
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    
    @State private var messages: [ChatMessage] = []
    @State private var newMessageText: String = ""

    var reciverUserId : String
    
    var body: some View {
        VStack {
            List(messages) { message in
                Text("\(message.senderId): \(message.text)")
            }

            HStack {
                TextField("Type a message", text: $newMessageText)
                Button("Send") {
                    sendMessage()
                }
            }
            .padding()
        }
        .onAppear {
            fetchMessages()
        }
    }

    func fetchMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        // Fetch messages from Firestore based on your data model
        // Update the 'messages' array
        // Example: db.collection("messages").whereField("receiverId", isEqualTo: "currentUserId")
        //            .addSnapshotListener { (snapshot, error) in
        //                // Handle snapshot and update 'messages'
        //            }
        dbHelper.fetchMessages(between: currentUserId, and: self.reciverUserId) { messages, error in
            if let error = error {
                print("Error fetching messages: \(error.localizedDescription)")
                return
            }

            if let messages = messages {
                // Handle fetched messages
                print("Fetched messages: \(messages)")
                self.messages = messages
            }
        }
    }

    func sendMessage() {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let newMessage = ChatMessage(id: nil, senderId: currentUserId, receiverId: reciverUserId, text: "Hello!", timestamp: Date())

        dbHelper.sendMessage(newMessage: newMessage) { error in
            if let error = error {
                print("Failed to send message: \(error.localizedDescription)")
            } else {
                print("Message sent successfully.")
            }
        }
    }
}

