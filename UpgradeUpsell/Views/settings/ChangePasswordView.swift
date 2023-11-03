//
//  ChangePassword.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-03.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @EnvironmentObject var authHelper: FireAuthController
    //@EnvironmentObject var dbHelper: FirestoreController
    
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var showAlert = false
    
    var body: some View {
        Form {
            Section {
                TextField("New Password", text: $newPassword)
                SecureField("Confirm Password", text: $confirmPassword)
            }
            
            Section {
                Button("Change Password") {
                    if newPassword == confirmPassword {
                        authHelper.changePassword(newPassword: newPassword) { error in
                            if let error = error {
                                errorMessage = error.localizedDescription
                            } else {
                                // Password changed successfully
                                showAlert = true
                                
                            }
                        }
                    } else {
                        errorMessage = "Passwords do not match."
                    }
                }
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        
        .alert(isPresented: $showAlert) {
            if errorMessage != nil {
                return Alert(title: Text("Error"), message: Text(errorMessage!), dismissButton: .default(Text("OK")))
            } else {
                return Alert(title: Text("Success"), message: Text("Password changed successfully."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
}
