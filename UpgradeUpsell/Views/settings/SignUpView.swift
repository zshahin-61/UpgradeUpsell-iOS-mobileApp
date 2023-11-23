//
//  SignUpView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-21.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestoreSwift
import PhotosUI
import AVFoundation

struct SignUpView: View {
    @EnvironmentObject var authHelper : FireAuthController
    @EnvironmentObject var dbHelper : FirestoreController
    
    @StateObject private var photoLibraryManager = PhotoLibraryManager()
    
    @State private var emailFromUI : String = ""
    @State private var passwordFromUI : String = ""
    @State private var confirmPasswordFromUI : String = ""
    @State private var addressFromUI : String = ""
    @State private var phoneFromUI : String = ""
    @State private var fullNameFromUI : String = ""
    @State private var bioFromUI : String = ""
    @State private var companyFromUI : String = ""
    let roles = ["Owner", "Investor", "Realtor"]
    @State private var selectedRole = "Owner"
    @State private var errorMsg : String? = nil
    // track whether the alert should be shown
    @State private var showAlert = false
    @Binding var rootScreen : RootView
    
    @State private var isShowingPicker = false
    @State private var selectedImage: UIImage?
    
    //@State private var isShowingPicker = false
    @State private var isShowingCamera = false
        //@State private var selectedImage: UIImage?
    @State private var isCameraPermissionDenied = false
    
    var body: some View {
        
        VStack{
            Text("Sign up").bold().font(.title).foregroundColor(.brown)
            Form{
                ZStack(alignment: .topLeading) {
                    TextField("Enter your email", text: self.$emailFromUI)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(isEmailValid() ? Color.clear : Color.red, lineWidth: 1)
                                .background(Color.gray.opacity(0.1))
                        )
                        .cornerRadius(10)
                    
                    if !isEmailValid() {
                        Text("Invalid email format")
                            .foregroundColor(.red)
                            .padding(.top, 60) // Adjust the spacing based on your layout
                            .padding(.leading, 5) // Adjust the spacing based on your layout
                    }
                }
                
                    SecureField("Enter Password", text: self.$passwordFromUI)
                                        .textInputAutocapitalization(.never)
                                        //.textFieldStyle(.roundedBorder)
                                        .padding()
                                        .frame(width: 300, height: 50)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)

                                    SecureField("Confirm Password", text: self.$confirmPasswordFromUI)
                                        .textInputAutocapitalization(.never)
                                        .padding()
                                        .frame(width: 300, height: 50)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(( self.passwordFromUI == "" || self.confirmPasswordFromUI == "" || self.passwordFromUI == self.confirmPasswordFromUI) ? Color.clear : Color.red, lineWidth: 1)
                                        )

                if (self.passwordFromUI != "" && self.confirmPasswordFromUI != "" && self.passwordFromUI != self.confirmPasswordFromUI) {
                                        Text("Passwords do not match")
                                            .foregroundColor(.red)
                                            .padding(.top, 5)
                                    }
                
                TextField("Enter Full Name", text: $fullNameFromUI)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .autocapitalization(.words)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("I am ...")
                        .font(.headline)
                    Picker("Role", selection: $selectedRole) {
                        ForEach(roles, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                TextField("Bio", text: self.$bioFromUI)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                TextField("Address", text: self.$addressFromUI)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                TextField("Phone Number", text: self.$phoneFromUI)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                TextField("Company", text: self.$companyFromUI)
                    .textInputAutocapitalization(.words)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                VStack{
                    Text("User Profile Picture")
                    if photoLibraryManager.isAuthorized {
                        Button(action: {
                            isShowingPicker = true
                        }) {
                            Text("Select Image")
                        }
                        Button(action: {
                            isShowingCamera = true
                            checkCameraPermissions()
                        }) {
                            Text("Capture Photo")
                        }
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                        }
                    } else {
                        Button(action: {
                            photoLibraryManager.requestPermission()
                        }) {
                            Text("Request Access For Photo Library")
                        }
                    }
                }
                .sheet(isPresented: $isShowingPicker) {
                    if photoLibraryManager.isAuthorized {
                        ImagePickerView(selectedImage: $selectedImage)
                    } else {
                        Text("Access to photo library is not authorized.")
                    }
                }
            }
            .sheet(isPresented: $isShowingPicker) {
                if photoLibraryManager.isAuthorized {
                    ImagePickerView(selectedImage: $selectedImage)
                } else {
                    Text("Access to photo library is not authorized.")
                }
            }
            //}
            .autocorrectionDisabled(true)
            
            Button(action: {
                //sign up function
                if isFormValid() {
                    // Attempt to create a new user with Firebase Authentication
                    self.authHelper.signUp(email: self.emailFromUI.lowercased(), password: self.passwordFromUI, withCompletion: { isSuccessful in
                        
                        if (isSuccessful){
                            // MARK: USER IMAGE
                            var imageData :Data? = nil
                            
                            if(selectedImage != nil )
                            {
                                let image = selectedImage!
                               // let imageName = "\(UUID().uuidString).jpg"
                                
                                imageData = image.jpegData(compressionQuality: 0.1)
                            }
                            
                            guard let user = Auth.auth().currentUser else{
                                return
                            }
                            
                            let newUser : UserProfile = UserProfile(id: user.uid, fullName: self.fullNameFromUI, email: self.emailFromUI, role: selectedRole, userBio: self.bioFromUI, profilePicture: imageData, contactNumber: self.phoneFromUI, address: self.addressFromUI, rating: 0, company: companyFromUI)
                            
                            self.dbHelper.createUserProfile(newUser: newUser)
                            
                            //show to home screen
                            if self.selectedRole == "Owner" {
                                
                                self.rootScreen = .Home
                                
                            }else if self.selectedRole == "Investor" {
                                
                                self.rootScreen = .InvestorHome
                                
                            }else if self.selectedRole == "Realtor" {
                                
                                self.rootScreen = .RealtorHome
                                
                            }
                        }else{
                            // Unable to create user, show alert
                            self.errorMsg = "Unable to create user. Please try again."
                            self.showAlert = true // Set showAlert to true to trigger the alert
                            
#if DEBUG
                            print(#function, "unable to create user")
#endif
                        }
                    })
                }
            }){
                Text("Create Account")
                    .frame(maxWidth: .infinity)
                            .padding()
                            .background(self.isFormValid() ? Color(red: 0.0, green: 0.40, blue: 0.0) : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(15) // Adjust the corner radius as needed
                            .shadow(radius: 5) // Add a shadow for a raised effect
            }
            //.buttonStyle(BorderedProminentButtonStyle())
            .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to remove the default button style
            .disabled(!isFormValid())
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMsg ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(isPresented: $isCameraPermissionDenied) {
                Alert(
                    title: Text("Camera Permission Denied"),
                    message: Text("Please enable camera access in your device settings to capture a photo."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding(.top, 5)
        .navigationBarItems(
                        leading: Button(action: {
                            rootScreen = .Login
                        }) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    )
        
    }
    
// Function to check camera permissions
    func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Camera access is already granted.
            break
        case .notDetermined:
            // Camera access is not determined yet. Request permission.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    // Permission granted
                    self.isCameraPermissionDenied = false
                } else {
                    // Permission denied
                    self.isCameraPermissionDenied = true
                }
            }
        case .denied, .restricted:
            // Camera access is denied or restricted by the user or parental controls.
            self.isCameraPermissionDenied = true
        @unknown default:
            // Handle unknown cases if necessary.
            break
        }
    }

    // MARK: func for check if the form is valid
    func isEmailValid()-> Bool {
        if(emailFromUI.isEmpty)
        {
            return true
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: emailFromUI)
    }
    
    func isFormValid() -> Bool {
        // Add more validation checks if needed
        return !emailFromUI.isEmpty && isEmailValid() && !passwordFromUI.isEmpty && passwordFromUI == confirmPasswordFromUI
    }
}

struct BorderedProminentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(configuration.isPressed ? Color.green.opacity(0.8) : Color(red: 0.0, green: 0.40, blue: 0.0), lineWidth: 2)
            )
    }
}
