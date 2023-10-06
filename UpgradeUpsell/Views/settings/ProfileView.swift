
//  Created by Created by Zahra Shahin - Golnaz Chehrazi
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @EnvironmentObject var authHelper : FireAuthController
    @EnvironmentObject var dbHelper : FirestoreController
    
    @StateObject private var photoLibraryManager = PhotoLibraryManager()
    
    @State private var emailFromUI : String = ""
    @State private var addressFromUI : String = ""
    @State private var contactNumberFromUI : String = ""
    @State private var nameFromUI : String = ""
    
    @State private var errorMsg : String? = nil
    
    @State private var showAlert = false
    
    @Binding var rootScreen : RootView
    
    @State private var isShowingPicker = false
    @State private var selectedImage: UIImage?
    @State private var imageData: Data?
    
    var body: some View {
        VStack(alignment: .leading,spacing: 10){
            //Form{
            Group{
                if let data = imageData,
                   let uiImage = UIImage(data: data) {
                    if(selectedImage == nil)
                    {
                        Image(uiImage: uiImage)
                            .resizable()
                                        .frame(width: 200, height: 200)
                                        .clipShape(Circle())
                    }
                    else{
                        //
                    }
                }
                VStack{
                    //Text("Picture").bold()
                    if photoLibraryManager.isAuthorized {
                        
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        Button(action: {
                            isShowingPicker = true
                        }) {
                            Text("Change Picture")
                        }
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
                
                Text("Full Name:").bold()
                TextField("Full Name:", text: self.$nameFromUI)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                Text("eMail:").bold()
                Text(self.emailFromUI)
                
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
            //}//from
           // .autocorrectionDisabled(true)
            
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
                
                dbHelper.userProfile!.fullName = nameFromUI
                dbHelper.userProfile!.contactNumber = contactNumberFromUI
                
                self.dbHelper.updateUserProfile(userToUpdate: dbHelper.userProfile!)
                
                rootScreen = .Home
            }){
                Text("Update Profile")
            }.buttonStyle(.borderedProminent)
            
            Spacer()
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
                    self.emailFromUI = currentUser.email
                    self.addressFromUI = currentUser.address
                    self.nameFromUI = currentUser.fullName
                    
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
