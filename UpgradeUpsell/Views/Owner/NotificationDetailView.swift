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

//    @Binding var isPresented: Bool
    
    var notification: Notifications

    var body: some View {
        Form {
    
//            if let currentUser = dbHelper.userProfile{
//                Text ("Name: \(currentUser.fullName)")
//            }
            Text("The Event: \(notification.event)")
            
            Text("Times: \(notification.timestamp)")
            
            Text("Details: \(notification.details ?? "No details available")")

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
                Button(action: {
                    dbHelper.deleteNotification(notification) { success in
                        presentationMode.wrappedValue.dismiss()

                    }
//                  isPresented = false
                }) {
                    Text("Delete ")
                        .foregroundColor(.red)
                }
            }
        }.padding()
            .onAppear(){
                dbHelper.markNotificationAsRead(notification) { success in
//                    presentationMode.wrappedValue.dismiss()
                    
                }
            }
    }
  
}

