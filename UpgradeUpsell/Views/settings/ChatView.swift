//
//  ChatView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-10.
//

import SwiftUI



class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []

    func sendMessage(sender: String, text: String) {
        let newMessage = Message(sender: sender, text: text, timestamp: Date())
        messages.append(newMessage)
    }
}

struct ChatView: View {
    @State private var newMessageText = ""
    @ObservedObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            List(viewModel.messages) { message in
                Text("\(message.sender): \(message.text)")
            }
            HStack {
                TextField("Type your message", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    viewModel.sendMessage(sender: "User", text: newMessageText)
                    newMessageText = ""
                }
            }
            .padding()
        }
        .navigationTitle("Chat")
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView()
        }
    }
}
