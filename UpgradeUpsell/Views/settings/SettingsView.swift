import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    
    @State private var showingDeleteAlert = false
    @Binding var rootScreen : RootView
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Preferences")) {
                        // Add preference settings here
                        Text("Preference 1")
                        Text("Preference 2")
                    }
                    
                    Section(header: Text("Notifications")) {
                        // Add notification settings here
                        Text("Notification 1")
                        Text("Notification 2")
                    }
                    
                    Section(header: Text("Account Settings")) {
                        Button(action:{
                            // TODO: before delete checking other collections has data of this user
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
                        }){
                            Image(systemName: "multiply.circle").foregroundColor(Color.white)
                            Text("Delete User Account")
                        }.padding(5).font(.title2).foregroundColor(Color.white)//
                            .buttonBorderShape(.roundedRectangle(radius: 15)).buttonStyle(.bordered).background(Color.red)
                        
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Confirm Delete"),
                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    // Delete account logic here
//                    authHelper.deleteAccount()
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
