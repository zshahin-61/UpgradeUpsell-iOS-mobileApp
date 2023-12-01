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
    @State private var prevMsg: ChatMessage? = nil // Change from let to var
    @State private var messages: [ChatMessage] = []
    @State private var isLoadingMessages = false
    
    var body: some View {
        VStack {
            Text("Chat").bold().font(.title).foregroundColor(.brown)
            if messages.isEmpty {
                if isLoadingMessages {
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
                    List {
                                    ForEach(Array(messages.enumerated()), id: \.element.id) { index, message in
                                        if index>0{
                                            ChatMessageView(message: message, isSender: message.senderId == senderUserID, prvMsg: messages[index - 1])
                                        }
                                        else{
                                            ChatMessageView(message: message, isSender: message.senderId == senderUserID, prvMsg: nil)
                                        }
                                    }
                                }//List
                    .onAppear {
                        // Initialize scrollView when the List appears
                        DispatchQueue.main.async {
                            withAnimation {
                                scrollView.scrollTo(messages.last?.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: messages) { _ in
                        // Scroll to the last message whenever new messages are added
                        DispatchQueue.main.async {
                            withAnimation {
                                scrollView.scrollTo(messages.last?.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            HStack {
                TextField("Type a message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 8).autocorrectionDisabled() // Add padding to the bottom of the text field
                
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
            //.navigationBarTitle("Chat", displayMode: .inline)
        }
    }
    
    private func listenForMessages() {
        if let currentUser = dbHelper.userProfile?.id {
            isLoadingMessages = true
            dbHelper.listenForMessages(user1: currentUser, user2: receiverUserID) { messages in
                self.messages = messages
                isLoadingMessages = false
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
#if DEBUG
                print("Error adding document: \(error.localizedDescription)")
                #endif
            } else {
                messageText = ""
            }
        }
        
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
}()

private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }

struct ChatMessageView: View {
    let message: ChatMessage
    let isSender: Bool
    let prvMsg: ChatMessage?
    var body: some View {
        VStack{
            if let prvMsg =  prvMsg {
                if(formatDate(prvMsg.timestamp) != formatDate(message.timestamp)){
                    //Text(formatDate(prvMsg.timestamp)).foregroundColor(.red)
                    Text(formatDate(message.timestamp))
                }
                
            }
            else{
                Text(formatDate(message.timestamp))
            }
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
}
