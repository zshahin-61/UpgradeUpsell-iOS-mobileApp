
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
    
//    @Binding var rootScreen : RootView
    
    @State private var isShowingPicker = false
    @State private var selectedImage: UIImage?
    @State private var imageData: Data?
    
    var body: some View {
        VStack{
            Form{
                Text("Dear user: \(self.emailFromUI)")
                
                TextField("Name", text: self.$nameFromUI)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Address", text: self.$addressFromUI)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Phone Number", text: self.$contactNumberFromUI)
                    .textInputAutocapitalization(.never)
                    .textFieldStyle(.roundedBorder)
                
                VStack{
                    Text("User Profile Picture")
                    if photoLibraryManager.isAuthorized {
                        Button(action: {
                            isShowingPicker = true
                        }) {
                            Text("Select Image")
                        }
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
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
                
                if let data = imageData,
                   let uiImage = UIImage(data: data) {
                    if(selectedImage == nil)
                    {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    else{
                        //
                    }
                } else {
                    Text("No image available")
                }
                
                if let err = errorMsg{
                    Text(err).foregroundColor(Color.red).bold()
                }
            }
            .autocorrectionDisabled(true)
            
            //HStack{
            Button(action: {
              
                var imageData :Data? = nil
        
              
                
//                rootScreen = .Home
            }){
                Text("Update Profile")
            }.buttonStyle(.borderedProminent)
            
            Spacer()
            Button(action:{
                
            }){
//                Image(systemName: "multiply.circle").foregroundColor(Color.white)
//                Text("Delete User Account")
            }            
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {
//                        rootScreen = .Home
                    }) {
                        Text("Back")
                    })
        }.padding()
    }
}
