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
        //dbHelper.fetchMessagesbySenderIDReciverID(: cu)
    }

    func sendMessage() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        var msgToSend = ChatMessage(id:nil, senderId: currentUserId, receiverId: "", text: newMessageText, timestamp: Date())
        dbHelper.sendMessage(newMessage: msgToSend)
        
        
        // Clear the input field after sending the message
        newMessageText = ""
    }
}

