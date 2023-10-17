//
//  InvestorProfileView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-10-16.
//

import SwiftUI

struct InvestorProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var authHelper : FireAuthController
    @EnvironmentObject var dbHelper : FirestoreController
    var investorID : String
    
    @StateObject private var photoLibraryManager = PhotoLibraryManager()
    
    @State private var name : String = ""
    @State private var bio : String = ""
    @State private var rating : Double = 4.5
    @State private var company : String = ""
    @State private var errorMsg : String? = nil
    
    @State private var showAlert = false
    
    @State private var isShowingPicker = false
    @State private var selectedImage: UIImage?
    @State private var imageData: Data?
    
    var body: some View {
        VStack(alignment: .leading,spacing: 10){
            //Form{
            
            HStack{
                if let data = imageData,
                   let uiImage = UIImage(data: data) {
                    if(selectedImage == nil)
                    {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    }
                    else{
                        //
                    }
                }
                VStack{
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                        }
                }
            }
            VStack{
                Text("Full Name:").bold()
                Text(self.name)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                Text("Comapny:").bold()
                Text(self.company)
            }
            Group{
                RatingView(rating: rating)
                Text("Bio:").bold()
                Text(self.bio)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
            
            }
            
            if let err = errorMsg{
                Text(err).foregroundColor(Color.red).bold()
            }
            //}//from
            // .autocorrectionDisabled(true)
            
            //HStack{
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("Back")
            }.buttonStyle(.borderedProminent)
            
            Spacer()
            
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        //rootScreen = .Home
                    }) {
                        Text("Back")
                    })
        }.padding()
            .onAppear(){
                self.dbHelper.getUserProfilebyUserID(userID: self.investorID){ (investorInfo, error)in
                
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
                            print("Invalid image data format")
                        }
                    }
                }
            }
    }
}
