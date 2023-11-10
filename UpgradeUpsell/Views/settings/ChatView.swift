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
        // Fetch messages from Firestore based on your data model
        // Update the 'messages' array
        // Example: db.collection("messages").whereField("receiverId", isEqualTo: "currentUserId")
        //            .addSnapshotListener { (snapshot, error) in
        //                // Handle snapshot and update 'messages'
        //            }
    }

    func sendMessage() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }

        // Send a new message to Firestore
        // Example: db.collection("messages").addDocument(data: [
        //            "senderId": currentUserId,
        //            "receiverId": "otherUserId",
        //            "text": newMessageText,
        //            "timestamp": Timestamp()
        //        ])
        
        // Clear the input field after sending the message
        newMessageText = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

