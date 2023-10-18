//
//  NotificationView.swift
//  UpgradeUpsell
//
//  Created by zahra SHAHIN on 2023-10-16.
//

import SwiftUI
import Firebase


struct NotificationView: View {
    @EnvironmentObject var dbHelper: FirestoreController
    @State private var notifications: [Notifications] = []
//    @State private var isDetailViewPresented = false

    var body: some View {
        VStack {
            List {
                ForEach(notifications, id: \.id) { notification in
                    NavigationLink(    destination: NotificationDetailView( notification: notification),
                        label: {
                            HStack {
                                Image(systemName: notification.isRead ? "eye.fill" : "eye.slash.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(.trailing, 10)
                                Text(notification.event)
                            }
                        }
                    )
                }
                .onDelete(perform: deleteNotifications)
            }
            .onAppear {
                if let userID = self.dbHelper.userProfile?.id {
                    dbHelper.getNotifications(forUserID: userID) { notifications, error in
                        if let notifications = notifications {
                            self.notifications = notifications
                        } else if let error = error {
                            // Handle the error
                            print("Error fetching notifications: \(error.localizedDescription)")
                        }
                    }
                }
            }
            .navigationBarTitle("Notifications")
            .padding()
        }
    }

    private func deleteNotifications(at offsets: IndexSet) {
        for offset in offsets {
            let notification = notifications[offset]
            dbHelper.deleteNotification(notification) { success in
                if success {
//                    print("Notification deleted successfully.")
                    notifications.remove(at: offset)
                } else {
                    print("Error deleting notification.")
                }
            }
        }
    }
}

