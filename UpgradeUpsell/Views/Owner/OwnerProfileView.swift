//
//  OwnerProfileView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-11.
//

import SwiftUI

struct OwnerProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    var ownerID: String
    
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
    
    @State private var isChatEnabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack{
                Spacer()
                Text("Owner Profile").bold().font(.title).foregroundColor(.brown)
                Spacer()
            }
            HStack{
                Spacer()
                VStack{
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
                }
                Spacer()
            }
            //Text(company)
                //.font(.headline)
            
           // RatingView(rating: rating)
            
            //HStack{
               // Text("Bio")
                 //   .font(.headline)
              //  Spacer()
            //}
                Text(bio)
                .font(.body).padding()
               
            
            if let err = errorMsg {
                Text(err)
                    .foregroundColor(.red)
                    .font(.callout)
            }
            HStack{
                if(isChatEnabled){
                                                      // HStack {
                                                         //  Text("You can chat with the user after approved by the administrator")
                    NavigationLink(destination: ChatView(receiverUserID: ownerID).environmentObject(dbHelper)) {
                                                               Text("Chat with Investor")
                    }
                                                   //        .disabled(!isStatusUpdated[index] || !hasChatPermission[index])
                                                      // }
                                                   } //if
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
//                    HStack {
//                            Image(systemName: "arrow.left.circle.fill") // Add your icon system name
//                                .imageScale(.large)
                            Text("Back")
                                .font(.headline)
                                .frame(width: 100, height: 50)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        //}
                }.buttonStyle(.borderedProminent)
            }
            Spacer()
        }
        .padding(.horizontal, 10)
        .onAppear(){
            self.dbHelper.getUserProfilebyUserID(userID: self.ownerID){ (investorInfo, error)in
                
                if let error = error {
                    self.errorMsg = error.localizedDescription
                }
                else if let investorInfo = investorInfo {
                    self.name = investorInfo.fullName
                    self.bio = investorInfo.userBio
                    self.company = investorInfo.company ?? ""
                    self.rating = investorInfo.rating ?? 4.5
                    
                    self.errorMsg = nil
                    
                    // MARK: Show image from db
                    if let imageData = investorInfo.profilePicture as? Data {
                        self.imageData = imageData
                    } else {
#if DEBUG
                        print("Invalid image data format")
                        #endif
                    }
                    
                    fetchChatPermissionStatus()
                    
                }
            }
        }
       // .navigationBarTitle("Investor Profile", displayMode: .inline)
       // .navigationBarItems(leading: Button(action: {
                  //self.presentationMode.wrappedValue.dismiss()
             //  }) {
//                   Image(systemName: "arrow.left.circle.fill") // Add your icon system name
//                   //                                .imageScale(.large)
         //          Text(" < Back ").font(.headline)
//                   Label(
//                           title: { Text("Back").font(.headline) },
//                           icon: { Image(systemName: "arrow.left.circle.fill") }
//                       )
            //   })
    }
    
    private func fetchChatPermissionStatus()  {
        if let currentUser = dbHelper.userProfile?.id {
            dbHelper.fetchChatPermission(user1: ownerID, user2: currentUser) { (permission, error) in
                if let error = error {
#if DEBUG
                    print("Error fetching chat permission: \(error)")
                    #endif
                    isChatEnabled =  false
                }
                
                if let permission = permission {
                    isChatEnabled = permission.canChat
                }
            }
        }
        else{
            isChatEnabled = false
        }
    }
}

