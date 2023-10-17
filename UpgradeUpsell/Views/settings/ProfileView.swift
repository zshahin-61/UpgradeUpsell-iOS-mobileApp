
//  Created by Created by Zahra Shahin - Golnaz Chehrazi
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authHelper: FireAuthController
    @EnvironmentObject var dbHelper: FirestoreController
    @StateObject private var photoLibraryManager = PhotoLibraryManager()
    
    @State private var email: String = ""
    @State private var addressFromUI: String = ""
    @State private var contactNumberFromUI: String = ""
    @State private var nameFromUI: String = ""
    @State private var bioFromUI: String = ""
    @State private var errorMsg: String? = nil
    @State private var companyFromUI: String = ""
    @State private var rating: Double = 4.5
    @State private var isShowingPicker = false
    @State private var selectedImage: UIImage?
    @State private var imageData: Data?
    
    @Binding var rootScreen : RootView
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Section(header: Text("Profile Picture").bold()) {
                    if let data = imageData, let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    }
                    Button(action: {
                        isShowingPicker = true
                    }) {
                        Text("Change Picture")
                    }
                }
                
                FormSection(header: "Personal Details") {
                    TextField("Full Name", text: $nameFromUI)
                    Text("Email: \(email)")
                    TextEditor(text: $bioFromUI)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                        .border(Color.gray, width: 1)
                        .padding()
                }
                
                FormSection(header: "Your Rating") {
                                    RatingView(rating: rating)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color(UIColor.systemBackground))
                                        .cornerRadius(8)
                                }

                
                FormSection(header: "Contact Information") {
                    TextField("Company", text: $companyFromUI)
                    TextField("Address", text: $addressFromUI)
                    TextField("Phone Number", text: $contactNumberFromUI)
                }
                
                if let err = errorMsg {
                    Text(err).foregroundColor(Color.red).bold()
                }
                
                Button(action: {                //Validate the data such as no mandatory inputs, password rules, etc.
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
                }) {
                                    Text("Update Profile")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                            .padding()
                        }
        .onAppear() {
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
            }}
                        .sheet(isPresented: $isShowingPicker) {
                            // Image picker view
                            if photoLibraryManager.isAuthorized {
                                ImagePickerView(selectedImage: $selectedImage)
                            } else {
                                Text("Access to the photo library is not authorized.")
                            }
                        }
                    }
                }

struct FormSection<Content: View>: View {
    var header: String
    var content: Content
    
    init(header: String, @ViewBuilder content: () -> Content) {
        self.header = header
        self.content = content()
    }
    
    var body: some View {
        Section(header: Text(header).bold()) {
            content
        }
    }
}
