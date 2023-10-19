//
//  InvestorProfileView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-10-16.
//

import SwiftUI

struct InvestorProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    var investorID: String
    
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
            
            RatingView(rating: rating)
            
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
        .padding()
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
        .navigationBarTitle("Investor Profile", displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
                  self.presentationMode.wrappedValue.dismiss()
               }) {
                   Text(" < Back ").font(.headline)
               })
    }
}

