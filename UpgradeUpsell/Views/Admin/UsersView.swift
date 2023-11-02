//
//  AllusersView.swift
//  UpgradeUpsell
//
//  Created by zahra SHAHIN on 2023-10-31.
//

import SwiftUI

struct UsersView: View {
    @EnvironmentObject var dbHelper: FirestoreController
    @State private var selectedRole: String = "Owner"
    @State private var filteredUsers: [UserProfile] = []
    
    let roles = ["Owner", "Investor", "Realtor", "Admin"]
    

    @State private var isShowingUserList: Bool = false
    

    var body: some View {
        VStack {
            Text("User List").bold().font(.title).foregroundColor(.blue)
                .padding(.horizontal, 10)
            
            Picker("Select Role", selection: $selectedRole) {
                ForEach(roles, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)
            
            List(filteredUsers) { user in
                VStack(alignment: .leading, spacing: 10) {
                    
                    NavigationLink(destination: UserProfileView(UserID: user.id!)) {
                        HStack {
                                                 if let imageData = user.profilePicture, let uiImage = UIImage(data: imageData) {
                                                     Image(uiImage: uiImage)
                                                         .resizable()
                                                         .frame(width: 40, height: 40)
                                                         .clipShape(Circle())
                                                 } else {
                                                     Image(systemName: "person.circle")
                                                         .resizable()
                                                         .frame(width: 40, height: 40)
                                                 }
                                                 Text(user.fullName)
                                                     .font(.title)
                                                     .bold()
                                                     .foregroundColor(Color.blue)
                                             }
                                         }
                    
                    Text("Role: \(user.role)")
                    
                    Button(action: {
                        // Implement the action to select the user
                    }) {
                        Text("Select")
                    }
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemBackground)))
                .padding(.horizontal)
                .listRowBackground(Color.clear)
            }
            .onAppear {
                fetchUsersByRole(selectedRole)
            }
            .onChange(of: selectedRole) { newRole in
                fetchUsersByRole(newRole)
            }
        }
    }

    func fetchUsersByRole(_ role: String) {
        dbHelper.getUsersByRole(role: role) { (users, error) in
            if let error = error {
                print("Error fetching users: \(error)")
            } else if let users = users {
                filteredUsers = users
            }
        }
    }
}
