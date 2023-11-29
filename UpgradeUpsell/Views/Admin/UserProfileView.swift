//
//  UserProfileView.swift
//  UpgradeUpsell
//
//  Created by zahra SHAHIN on 2023-11-02.
//

import SwiftUI

struct UserProfileView: View {

        @Environment(\.presentationMode) var presentationMode
        
        @EnvironmentObject var authHelper: FireAuthController
        @EnvironmentObject var dbHelper: FirestoreController
    
        var UserID: String
        
        @StateObject private var photoLibraryManager = PhotoLibraryManager()
        
        @State private var name: String = ""
        @State private var bio: String = ""
        @State private var rating: Double = 4.5
        @State private var company: String = ""
        @State private var errorMsg: String? = nil
        
        @State private var showAlert = false
        
        @State private var isShowingPicker = false
        @State private var selectedImage: UIImage?
        @State private var imageData: Data?
        
        var body: some View {
            VStack(alignment: .center, spacing: 20) {
                Text("User Profile").bold().font(.title).foregroundColor(.brown)
                if let data = imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)
                }
                
                Text(name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(company)
                    .font(.headline)
                
                //RatingView(rating: rating)
                
                HStack{
                    Text("Bio:")
                        .font(.headline)
                    Spacer()
                }
                    Text(bio)
                        .font(.body)
                   
                
                if let err = errorMsg {
                    Text(err)
                        .foregroundColor(.red)
                        .font(.callout)
                }
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back")
                        .font(.headline)
                        .frame(width: 100, height: 50)
                       // .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }.buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 10)
            .onAppear(){
                self.dbHelper.getUserProfilebyUserID(userID: self.UserID){ (UserInfo, error)in
                    
                    if let error = error {
                        self.errorMsg = error.localizedDescription
                    }
                    else if let UserInfo = UserInfo {
                        self.name = UserInfo.fullName
                        self.bio = UserInfo.userBio
                        self.company = UserInfo.company ?? ""
                        self.rating = UserInfo.rating ?? 4.5
                        
                        self.errorMsg = nil
                        
                        // MARK: Show image from db
                        if let imageData = UserInfo.profilePicture as? Data {
                            self.imageData = imageData
                        } else {
                            print("Invalid image data format")
                        }
                    }
                }
            }
//            .navigationBarItems(leading: Button(action: {
//                      self.presentationMode.wrappedValue.dismiss()
//                   }) {
//                       Text(" Back ").font(.headline)
//                   })
        }
    }


