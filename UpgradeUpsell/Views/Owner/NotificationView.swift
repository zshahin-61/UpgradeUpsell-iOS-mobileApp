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
    @State private var selectedNotification: Notifications?
    @State private var isDetailViewPresented = false
    
    var body: some View {
        NavigationView {
            List(notifications) { notification in
                NavigationLink(    destination: NotificationDetailView(isPresented: self.$isDetailViewPresented, notification: notification)
) {
                    HStack {
                        Image(systemName: notification.isRead ? "eye.fill" : "eye.slash.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 10)
                        Text(notification.event)
                    }
                }
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
}
