//
//  NotificationDetailView.swift
//  UpgradeUpsell
//
//  Created by zahra SHAHIN on 2023-10-16.
//

import SwiftUI
import Firebase

struct NotificationDetailView: View {
    @EnvironmentObject var dbHelper: FirestoreController

    @Binding var isPresented: Bool
    
    var notification: Notifications

    var body: some View {
        Form {
    
//            if let currentUser = dbHelper.userProfile{
//                Text ("Name: \(currentUser.fullName)")
//            }
            Text("The Event: \(notification.event)")
            
            Text("Times: \(notification.timestamp, style: .relative)")
            
            Text("Details: \(notification.details ?? "No details available")")

            HStack{
                Button(action: {
                    markNotificationAsRead()
                }) {
                    Text(notification.isRead ? "Mark Unread" : "Mark Read")
                }

                Spacer()
                Button(action: {
                 //   deleteNotification()
                    isPresented = false
                }) {
                    Text("Delete ")
                        .padding()
                        .foregroundColor(.red)
                }
            }
          
          

        }.padding()
    }

    private func markNotificationAsRead() {
        dbHelper.markNotificationAsReadOrUnread(notification) { success in
            if success {
                print("Notification marked successfully.")
            } else {
                print("Error marking notification")
            }
        }
    }

//    private func deleteNotification() {
//        dbHelper.deleteNotification(notification) { success in
//            if success {
//                print("Notification deleted successfully.")
//            } else {
//                print("Error deleting notification.")
//            }
//        }
//    }
}

