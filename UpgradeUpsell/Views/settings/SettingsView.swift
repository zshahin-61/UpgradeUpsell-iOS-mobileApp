import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    
    @State private var pushNotifFromUI = false
       @State private var notificationsEmail = false
       @State private var themeFromUI = "light"
       @State private var langFromUI = "en-us"
       @State private var fontSizeFromUI = 14
    
    @State private var showingDeleteAlert = false
    @Binding var rootScreen : RootView
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Preferences")) {
                        
                                                
                                                Picker("Theme", selection: $themeFromUI) {
                                                    Text("Light").tag("light")
                                                    Text("Dark").tag("dark")
                                                }
                                                
                                                Picker("Language", selection: $langFromUI) {
                                                    Text("English").tag("en_US")
                                                    Text("Spanish").tag("es_ES")
                                                    // Add more languages here as needed
                                                }
                                                
                                                Stepper("Font Size: \(fontSizeFromUI)", value: $fontSizeFromUI, in: 12...24)
                    }
                    
                    Section(header: Text("Notifications")) {
                        Toggle(isOn: $pushNotifFromUI , label: {
                                                    Text("Push Notifications")
                                                })
                                                
                                                Toggle(isOn: $notificationsEmail, label: {
                                                    Text("Email Notifications")
                                                })
                    }
                    
                    Section(header: Text("Account Settings")) {
                        Button(action:{
                            
                            showingDeleteAlert = true
                            
                            // TODO: before delete checking other collections has data of this user
                            
                           
                        }){
                            Image(systemName: "multiply.circle").foregroundColor(Color.white)
                            Text("Delete User Account")
                        }.padding(5).font(.title2).foregroundColor(Color.white)//
                            .buttonBorderShape(.roundedRectangle(radius: 15)).buttonStyle(.bordered).background(Color.red)
                        
                    }
                }//Form
            }
            .navigationTitle("Settings")
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Confirm Delete"),
                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    // Delete account logic here
                    self.dbHelper.deleteUser(withCompletion: { isSuccessful in
                        if (isSuccessful){
                            self.authHelper.deleteAccountFromAuth(withCompletion: { isSuccessful2 in
                                if (isSuccessful2){
                                    //sign out using Auth
                                    self.authHelper.signOut()
                                    
                                    //self.selectedLink = 1
                                    //dismiss current screen and show login screen
                                    self.rootScreen = .Login
                                }
                            }
                            )}
                    })
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct DeleteAccountView: View {
    var body: some View {
        VStack {
            Text("Are you sure you want to delete your account?")
                .font(.headline)
                .padding()
            
            Button(action: {
                // Perform the account deletion
            }) {
                Text("Delete Account")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationTitle("Delete Account")
    }
}
