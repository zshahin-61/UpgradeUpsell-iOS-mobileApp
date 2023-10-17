
//  Created by Created by Zahra Shahin - Golnaz Chehrazi
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var authHelper : FireAuthController
    @EnvironmentObject var dbHelper : FirestoreController
    
    @StateObject private var photoLibraryManager = PhotoLibraryManager()
    
    @State private var email : String = ""
    @State private var addressFromUI : String = ""
    @State private var contactNumberFromUI : String = ""
    @State private var nameFromUI : String = ""
    @State private var bioFromUI : String = ""
    @State private var errorMsg : String? = nil
    @State private var companyFromUI : String = ""
    @State private var rating : Double = 4.5
    
    @State private var showAlert = false
    
    @Binding var rootScreen : RootView
    
    @State private var isShowingPicker = false
    @State private var selectedImage: UIImage?
    @State private var imageData: Data?
    
    var body: some View {
        VStack(alignment: .leading,spacing: 10){
            Form{
            
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
                        //Text("Picture").bold()
                        if photoLibraryManager.isAuthorized {
                            //HStack{
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            }
                            Button(action: {
                                isShowingPicker = true
                            }) {
                                Text("Change Picture")
                            }
                            //}//Hstack
                        } else {
                            Button(action: {
                                photoLibraryManager.requestPermission()
                            }) {
                                Text("Request Access For Photo Library")
                            }
                        }
                    }
                    .sheet(isPresented: $isShowingPicker) {
                        if photoLibraryManager.isAuthorized {
                            ImagePickerView(selectedImage: $selectedImage)
                        } else {
                            Text("Access to photo library is not authorized.")
                        }
                    }
                }
            VStack{
                Text("Full Name:").bold()
                TextField("Full Name:", text: self.$nameFromUI)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                Text("eMail:").bold()
                Text(self.email)
                Text("Bio:").bold()
                //                TextField("Bio", text: self.$bioFromUI)
                //                    .textInputAutocapitalization(.never)
                //                    .textFieldStyle(.roundedBorder)
                TextEditor(text: self.$bioFromUI)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                    .border(Color.gray, width: 1)
                    .padding()
            }
            VStack{
                Text("Company:").bold()
                TextField("Company:", text: self.$companyFromUI)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                Text("Address:").bold()
                TextField("Address", text: self.$addressFromUI)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                Text("Phone Number:").bold()
                TextField("Phone Number", text: self.$contactNumberFromUI)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
            }
                
//                else {
//                    //Text("No image available")
//                }
                
                if let err = errorMsg{
                    Text(err).foregroundColor(Color.red).bold()
                }
            }//from
            .scrollContentBackground(.hidden)
            .autocorrectionDisabled(true)
            
            //HStack{
            Button(action: {
                //Validate the data such as no mandatory inputs, password rules, etc.
                //
                dbHelper.userProfile!.address = addressFromUI
                //Image
                var imageData :Data? = nil
                
                if(selectedImage != nil )
                {
                    let image = selectedImage!
                    let imageName = "\(UUID().uuidString).jpg"
                    
                    imageData = image.jpegData(compressionQuality: 0.1)
                    dbHelper.userProfile!.profilePicture = imageData
                }
                
                ////////
                
                self.dbHelper.userProfile!.fullName = nameFromUI
                self.dbHelper.userProfile!.contactNumber = contactNumberFromUI
                self.dbHelper.userProfile!.userBio = bioFromUI
                self.dbHelper.userProfile!.company = companyFromUI
                
                self.dbHelper.updateUserProfile(userToUpdate: dbHelper.userProfile!)
                self.presentationMode.wrappedValue.dismiss()
                //rootScreen = .Home
            }){
                Text("Update Profile")
            }.buttonStyle(.borderedProminent)
            
            Spacer()
            
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
                        rootScreen = .Home
                    }) {
                        Text("Back")
                    })
        }.padding()
            .onAppear(){
                
                if let currentUser = dbHelper.userProfile{
                    self.email = currentUser.email
                    self.rating = currentUser.rating ?? 4.5
                    self.companyFromUI = currentUser.company ?? ""
                    self.addressFromUI = currentUser.address
                    self.nameFromUI = currentUser.fullName
                    self.bioFromUI = currentUser.userBio
                    self.contactNumberFromUI = currentUser.contactNumber
                    self.errorMsg = nil
                    
                    // MARK: Show image from db
                    if let imageData = currentUser.profilePicture as? Data {
                        self.imageData = imageData
                    } else {
                        print("Invalid image data format")
                    }
                }
            }
    }
}
