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
    
    //@State private var emailFromUI : String = ""
    //@State private var addressFromUI : String = ""
    //@State private var contactNumberFromUI : String = ""
    @State private var nameFromUI : String = ""
    @State private var bioFromUI : String = ""
    @State private var errorMsg : String? = nil
    
    @State private var showAlert = false
    
    //@Binding var rootScreen : RootView
    
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
            Group{
                Text("Full Name:").bold()
                Text(self.nameFromUI)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
               //Text("eMail:").bold()
                //Text(self.$emailFromUI)
                Text("Bio:").bold()
                Text(self.bioFromUI)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
//                Text("Address:").bold()
//                TextField("Address", text: self.$addressFromUI)
//                    .textInputAutocapitalization(.never)
//                    .textFieldStyle(.roundedBorder)
//                Text("Phone Number:").bold()
//                TextField("Phone Number", text: self.$contactNumberFromUI)
//                    .textInputAutocapitalization(.never)
//                    .textFieldStyle(.roundedBorder)
            }
            
            //                else {
            //                    //Text("No image available")
            //                }
            
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
                        
                        //self.emailFromUI = investorInfo.email
                        //self.addressFromUI = investorInfo.address
                        self.nameFromUI = investorInfo.fullName
                        self.bioFromUI = investorInfo.userBio
                        //self.contactNumberFromUI = investorInfo.contactNumber
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
