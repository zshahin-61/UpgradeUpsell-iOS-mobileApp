//
//  SignUpView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-21.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authHelper : FireAuthController
    @EnvironmentObject var dbHelper : FirestoreController
    
    @StateObject private var photoLibraryManager = PhotoLibraryManager()
    
    @State private var emailFromUI : String = ""
    @State private var passwordFromUI : String = ""
    @State private var confirmPasswordFromUI : String = ""
    @State private var addressFromUI : String = ""
    @State private var phoneFromUI : String = ""
    @State private var nameFromUI : String = ""
    @State private var errorMsg : String? = nil
    
    @Binding var rootScreen : RootView
    
    @State private var isShowingPicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        
        VStack{
//            Form{
//                TextField("Enter Email", text: self.$emailFromUI)
//                    .textInputAutocapitalization(.never)
//                    .textFieldStyle(.roundedBorder)
//
//                SecureField("Enter Password", text: self.$passwordFromUI)
//                    .textInputAutocapitalization(.never)
//                    .textFieldStyle(.roundedBorder)
//
//                SecureField("Confirm Password", text: self.$confirmPasswordFromUI)
//                    .textInputAutocapitalization(.never)
//                    .textFieldStyle(.roundedBorder)
//
//                TextField("Name", text: self.$nameFromUI)
//                    .textInputAutocapitalization(.never)
//                    .textFieldStyle(.roundedBorder)
//
//                TextField("Address", text: self.$addressFromUI)
//                    .textInputAutocapitalization(.never)
//                    .textFieldStyle(.roundedBorder)
//
//                TextField("Phone Number", text: self.$phoneFromUI)
//                    .textInputAutocapitalization(.never)
//                    .textFieldStyle(.roundedBorder)
//
//                VStack{
//                  Text("User Profile Picture")
//                    if photoLibraryManager.isAuthorized {
//                                Button(action: {
//                                    isShowingPicker = true
//                                }) {
//                                    Text("Select Image")
//                                }
//                                if let image = selectedImage {
//                                    Image(uiImage: image)
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                }
//                            } else {
//                                Button(action: {
//                                    photoLibraryManager.requestPermission()
//                                }) {
//                                    Text("Request Access For Photo Library")
//                                }
//                            }
//                        }
//                .sheet(isPresented: $isShowingPicker) {
//                            if photoLibraryManager.isAuthorized {
//                                ImagePickerView(selectedImage: $selectedImage)
//                            } else {
//                                Text("Access to photo library is not authorized.")
//                            }
//                        }
//            }
//            .autocorrectionDisabled(true)
//
            Button(action: {
                //sign up function
            }){
                Text("Create Account")
            }.buttonStyle(.borderedProminent)
                .disabled(self.passwordFromUI != self.confirmPasswordFromUI || self.emailFromUI.isEmpty || self.passwordFromUI.isEmpty || self.confirmPasswordFromUI.isEmpty || !isEmailValid())
            
                .navigationBarTitle("Sign Up", displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(action: {
                        rootScreen = .Login
                    }) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    })
        }
    }
    
    // MARK: func for check if the form is valid
    func isEmailValid()-> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: emailFromUI)
    }
}



