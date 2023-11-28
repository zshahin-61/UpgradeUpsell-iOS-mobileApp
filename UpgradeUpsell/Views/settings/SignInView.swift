//
//  SignInView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-21.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    
    @State private var emailFromUI: String = "zshahin.61@gmail.com"
    @State private var passwordFromUI: String = "Admin123"
    
    @Binding var rootScreen: RootView
    
    private let gridItems: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var showAlert = false
    
    private var isFormValid: Bool {
        return !self.emailFromUI.isEmpty && !self.passwordFromUI.isEmpty && isEmailValid()
    }
    
    var body: some View {
        VStack {
            Image("login")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack {
                Text("Upgrade & Upsell")
                    .font(.system(size: 23, weight: .heavy, design: .default))
                    .kerning(3.0)
                    .foregroundColor(Color(red: 0.0, green: 0.40, blue: 0.0))
                    .textCase(.uppercase)
                    .padding(.top, 5)
                
                Text("Sell Your House for a Higher Price")
                    .bold()
                    .padding(.top, 5)
                    .padding(.bottom, 20)
            }
            
            VStack {
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
                SecureField("Enter password", text: self.$passwordFromUI)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            .padding()
            
            LazyVGrid(columns: self.gridItems) {
                Button(action: {
                    self.authHelper.signIn(email: self.emailFromUI, password: self.passwordFromUI, withCompletion: { isSuccessful in
                        if isSuccessful {
                            self.dbHelper.getUserProfile(withCompletion: { isSuccessful in
                                if isSuccessful {
                                    if let loginedUserRole = dbHelper.userProfile?.role {
                                        switch loginedUserRole {
                                        case "Owner":
                                            self.rootScreen = .Home
                                        case "Investor":
                                            self.rootScreen = .InvestorHome
                                        case "Realtor":
                                            self.rootScreen = .RealtorHome
                                        case "Admin":
                                            self.rootScreen = .Admin
                                        default:
                                            break
                                        }
                                    }
                                } else {
                                    self.showAlert = true
#if DEBUG
                                    print(#function, "User does not exist in user profile collection")
#endif
                                }
                            })
                        } else {
                            self.showAlert = true
                            print(#function, "Invalid username/password")
                        }
                    })
                }) {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .padding()
                        .background(self.isFormValid ? Color(red: 0.0, green: 0.40, blue: 0.0) : Color.gray)
                        .cornerRadius(10)
                        .opacity(self.isFormValid ? 1.0 : 0.8)
                        .shadow(color: .gray, radius: 3, x: 0, y: 3)
                }
                .disabled(!self.isFormValid)
                .buttonStyle(CustomButtonStyle(isEnabled: self.isFormValid))
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Sign In Failed"),
                        message: Text("Invalid email or password. Please try again."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Button(action: {
                    self.rootScreen = .SignUp
                }) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 0.0, green: 0.40, blue: 0.0))
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 3, x: 0, y: 3)
                }
            }
            .padding(.top, 50)
            Spacer()
        }
        .scrollContentBackground(.hidden)
        .padding()
    }
    
    func isEmailValid() -> Bool {
        if(emailFromUI.isEmpty)
        {
            return true
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: emailFromUI)
    }
    
    struct CustomButtonStyle: ButtonStyle {
        let isEnabled: Bool
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundColor(.white)
                .background(!self.isEnabled ? Color.gray : Color(red: 0.0, green: 0.40, blue: 0.0))
                .cornerRadius(8)
                .opacity(!self.isEnabled ? 0.8 : 1.0)
                .shadow(color: .gray, radius: 3, x: 0, y: 3)
        }
    }
    
    
    
}



