import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    
    @State private var showingDeleteAlert = false
    
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
                        Button(action: {
                            // Show a confirmation alert
                            showingDeleteAlert.toggle()
                        }) {
                            HStack {
                                Image(systemName: "multiply.circle")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .padding(5)
                                
                                Text("Delete User Account")
                                    .foregroundColor(.white)
                                    .font(.title2)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(15)
                        }
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
