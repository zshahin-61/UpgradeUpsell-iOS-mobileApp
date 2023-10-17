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
    @EnvironmentObject var authHelper: FireAuthController

    @State private var notifications: [Notifications] = []
    @State private var selectedNotification: Notifications? 

    var body: some View {
        List(notifications, id: \.id, selection: $selectedNotification) { notification in
            Text(notification.event)
            Text(notification.timestamp, style: .relative)
        }
        .onAppear {
            if let userID = self.dbHelper.userProfile?.id {
//            if let userID = self.authHelper.currentUser?.uid {
                dbHelper.getNotifications(forUserID: userID) { notifications, error in // Use the correct variable name
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
