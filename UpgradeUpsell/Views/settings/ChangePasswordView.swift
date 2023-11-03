//
//  ChangePassword.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-03.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var showAlert = false
    @Binding var rootScreen : RootView
    @State private var role: String = "Owner"
    
    var body: some View {
        VStack{
            Form {
                Section {
                    TextField("New Password", text: $newPassword)
                    SecureField("Confirm Password", text: $confirmPassword)
                }
                
                
                HStack {
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
                    Spacer()
                    Button(action:{
                        if(self.role == "Investor"){
                            self.rootScreen = .InvestorHome
                        }else if self.role ==  "Owner"{
                            self.rootScreen = .Home
                        } else if self.role == "Realtor"
                        {
                            self.rootScreen =  .RealtorHome
                            
                        } else if self.role ==  "Admin"{
                            self.rootScreen =  .Admin
                        }
                    }){
                        Text("Back")
                    }.buttonStyle(.borderedProminent)
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
        }
        .alert(isPresented: $showAlert) {
            if errorMessage != nil {
                return Alert(title: Text("Error"), message: Text(errorMessage!), dismissButton: .default(Text("OK")))
            } else {
                return Alert(title: Text("Success"), message: Text("Password changed successfully."), dismissButton: .default(Text("OK")))
            }
        }
        
        .onAppear() {
            if let currentUser = dbHelper.userProfile{
                self.role = currentUser.role
            }
        }
        .navigationBarItems(leading: Button(action: {
            if(self.role == "Investor"){
                self.rootScreen = .InvestorHome
            }else if self.role ==  "Owner"{
                self.rootScreen = .Home
            } else if self.role == "Realtor"
            {
                self.rootScreen =  .RealtorHome
            }
            else if self.role == "Admin"
            {
                self.rootScreen =  .Admin
            }
            //self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("< Back")
        })//navigationBarItems
    }
}
//}
