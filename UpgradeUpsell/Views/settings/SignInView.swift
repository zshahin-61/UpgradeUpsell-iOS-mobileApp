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
    
    private var isFormValid: Bool {
            return !self.emailFromUI.isEmpty && !self.passwordFromUI.isEmpty && isEmailValid()
        }
    
    var body: some View {
        VStack{
            VStack {
                Image("login")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
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
            VStack{
                //Text("Sign in")
            
                TextField("Enter your email", text: self.$emailFromUI)
                    .textInputAutocapitalization(.never)
                    .padding()
                                            .frame(width: 300, height: 50)
                                            .background(Color.black.opacity(0.05))
                                            .cornerRadius(10)
                
                if !isEmailValid() {
                       Text("Invalid email format")
                           .foregroundColor(.red)
                   }
                
                SecureField("Enter password", text: self.$passwordFromUI)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
            
            
            LazyVGrid(columns: self.gridItems){
                Button(action: {
                    self.authHelper.signIn(email: self.emailFromUI, password: self.passwordFromUI, withCompletion: { isSuccessful in
                        if (isSuccessful){

                            self.dbHelper.getUserProfile(withCompletion: {isSuccessful in
                                if( isSuccessful){
                                    
//                                    self.dbHelpergetPreferencesFromFirestore(forUserID: dbHelper.userProfile?.id, completion: <#T##(Prefrences?, Error?) -> Void#>)
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
                                        else if loginedUserRole == "Admin"{
                                            self.rootScreen = .Admin
                                        }
                                        
                                        
                                    }
                                }
                                else{
                                    self.showAlert = true
#if DEBUG
                                    print(#function, "User does not exist in user profile collection")
                                    #endif
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
                           .foregroundColor(.white)
                           .padding()
                           .background(self.isFormValid ? Color(red: 0.0, green: 0.40, blue: 0.0) : Color.gray)
                           .cornerRadius(10)
                           .opacity(self.isFormValid ? 1.0 : 0.8)
                }
                .disabled(self.emailFromUI.isEmpty || self.passwordFromUI.isEmpty || !isEmailValid() )
                .buttonStyle(CustomButtonStyle(isEnabled: !self.emailFromUI.isEmpty && !self.passwordFromUI.isEmpty && isEmailValid()))
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Sign In Failed"),
                        message: Text("Invalid email or password. Please try again."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Button(action: {
                    self.rootScreen = .SignUp
                }){
                    Text("Sign Up")
                        //.font(.title2)
                        .foregroundColor(.white)
                       // .bold()
                        .padding()
                        .background(Color(red: 0.0, green: 0.40, blue: 0.0))
                }
                .cornerRadius(8)
            }
            .padding(.top,50)
                
            }.padding()
           
            Spacer()
        }
        .scrollContentBackground(.hidden)
        .padding()
        
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
                .background(!self.isEnabled ? Color.gray : Color(red: 0.0, green: 0.40, blue: 0.0))
                .cornerRadius(8)
                .opacity(!self.isEnabled ? 0.8 : 1.0)
                //.disabled(!self.isEnabled)

        }
    }
    
}


