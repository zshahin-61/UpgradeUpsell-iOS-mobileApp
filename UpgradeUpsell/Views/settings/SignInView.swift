//
//  SignInView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-21.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authHelper : FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    
    @State private var emailFromUI : String = "g.chehrazi@gmail.com"
    @State private var passwordFromUI : String = "Admin123"
    
    @Binding var rootScreen : RootView
    
    private let gridItems : [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var showAlert = false
    
    var body: some View {
        
        VStack{
            Text("Upgrade & Upsell").bold()
            Image("login")
                       .resizable()
                       .aspectRatio(contentMode: .fit)
            Text("Sell Your House for a Higher Price").bold()
            Form{
                //Text("Sign in")
                TextField("Enter Email", text: self.$emailFromUI)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Enter Password", text: self.$passwordFromUI)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
            }
            .autocorrectionDisabled(true)
            
            LazyVGrid(columns: self.gridItems){
                Button(action: {
                    self.authHelper.signIn(email: self.emailFromUI, password: self.passwordFromUI, withCompletion: { isSuccessful in
                        if (isSuccessful){

                            self.dbHelper.getUserProfile(withCompletion: {isSuccessful in
                                if( isSuccessful){
                                    // MARK: check role of user and forward to their screens
                                    if let loginedUserRole = dbHelper.userProfile?.role{
                                        if loginedUserRole == "Owner"{
                                            self.rootScreen = .Home
                                        }
                                        else if loginedUserRole == "Investor"{
                                            self.rootScreen = .InvestorHome
                                        }
                                        else if loginedUserRole == "Realtor"{
                                            self.rootScreen = .RealtorHome
                                        }
                                        
                                        
                                    }
                                }
                                else{
                                    self.showAlert = true
                                    print(#function, "User does not exist in user profile collection")
                                }
                            })

                            
                        }else{
                            //show the alert with invalid username/password prompt
                            self.showAlert = true
                            print(#function, "invalid username/password")
                        }
                    })
                }){
                    Text("Sign In")
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                        .padding()
                    
                    
                }
                //.background(Color.blue)
                .disabled(self.emailFromUI.isEmpty || self.passwordFromUI.isEmpty || !isEmailValid() )
                .buttonStyle(CustomButtonStyle(isEnabled: !self.emailFromUI.isEmpty && !self.passwordFromUI.isEmpty && isEmailValid()))
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Alert Title"),
                        message: Text("invalid username/password"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Button(action: {
                    self.rootScreen = .SignUp
                }){
                    Text("Sign Up")
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                        .padding()
                        .background(Color.blue)
                }
                .cornerRadius(8)
            }
        }
    }
    
    // MARK: func for check if the form is valid
    func isEmailValid()-> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: emailFromUI)
    }
    
    struct CustomButtonStyle: ButtonStyle {
        let isEnabled: Bool
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                //.padding()
                .foregroundColor(.white)
                .background(!self.isEnabled ? Color.gray : Color.blue)
                .cornerRadius(8)
                .opacity(!self.isEnabled ? 0.8 : 1.0)
                //.disabled(!self.isEnabled)
        }
    }
    
}


