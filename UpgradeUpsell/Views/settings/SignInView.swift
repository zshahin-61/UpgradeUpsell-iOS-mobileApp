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
            
            Image("login")
                .resizable()
                .aspectRatio(contentMode: .fit)
            HStack{
                Spacer()
                Text("Upgrade & Upsell")
                    .font(.system(size: 23, weight: .heavy, design: .default))
                    .kerning(3.0) // Adjust the letter spacing as needed
                    .foregroundColor(Color(red: 0.0, green: 0.40, blue: 0.0))
                    .textCase(.uppercase)
                Spacer()
            }
            .padding(.top, 5)
            Text("Sell Your House for a Higher Price").bold()
                .padding(.top, 5)
                .padding(.bottom, 20)
           // Form{
                //Text("Sign in")
            
                TextField("Enter your email", text: self.$emailFromUI)
                    .textInputAutocapitalization(.never)
                    .padding()
                                            .frame(width: 300, height: 50)
                                            .background(Color.black.opacity(0.05))
                                            .cornerRadius(10)
                
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
                        //.font(.title2)
                        .foregroundColor(.white)
                        //.bold()
                        .padding()
                }
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
                        //.font(.title2)
                        .foregroundColor(.white)
                       // .bold()
                        .padding()
                        .background(Color(red: 0.0, green: 0.40, blue: 0.0))
                }
                .cornerRadius(8)
            }
            .padding(.top,50)
                
            //}
            //.scrollContentBackground(.hidden)
           // .autocorrectionDisabled(true)
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


