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
    @Environment(\.presentationMode) var presentationMode
    var notification: Notifications
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            //            if let currentUser = dbHelper.userProfile{
            //                Text ("Name: \(currentUser.fullName)")
            //            }
            
            VStack(alignment: .leading, spacing: 1) {
                Text("Event").font(.subheadline).foregroundColor(.gray)
                //   Spacer()
                Text("\(notification.event)")
            }.padding(.top, 1)
            
            
            //            let dateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "h:mm a"
            //            dateFormatter.timeZone = TimeZone(abbreviation: "EDT")
            //            let notificationTimestamp = Date()
            //            Text("Time: \(dateFormatter.string(from: notificationTimestamp))")
            VStack(alignment: .leading, spacing: 1) {
                Text("Time").font(.subheadline).foregroundColor(.gray)
                Text(" \(notification.timestamp)")
            }.padding(.top, 1)
            
            VStack(alignment: .leading, spacing: 1) {
                Text("Details").font(.subheadline).foregroundColor(.gray)
                Text(" \(notification.details ?? "No details available")")
            }.padding(.top, 1)
            //            HStack{
            //                Button(action: {
            //                    dbHelper.markNotificationAsRead(notification) { success in
            //                        presentationMode.wrappedValue.dismiss()
            //
            //                    }                }) {
            //                        Text("Mark Read")
            //                    }
            //
            //            }
            HStack{
                Spacer()
                Button(action: {
                    dbHelper.deleteNotification(notification) { success in
                        presentationMode.wrappedValue.dismiss()
                        
                    }
                }) {
                    Text("Delete ")
                        .foregroundColor(.red)
                }.padding(.top , 20)
                Spacer()
            }
            Spacer()
        }.padding()
            .onAppear(){
                self.dbHelper.markNotificationAsRead(notification) { success in
                    print("success")
                }
                
                
            }
    }
    
}

