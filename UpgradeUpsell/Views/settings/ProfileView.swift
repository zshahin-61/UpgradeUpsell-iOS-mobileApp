
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
    @State private var role: String = "Owner"
    
    
    @Binding var rootScreen : RootView
    //var backRoot: RootView
    
    var body: some View {
        //ScrollView {
        VStack(alignment: .leading) {
            HStack{
                Spacer()
                Text("Profile").bold().font(.title).foregroundColor(.brown)
                Spacer()
            }
            Form{
                //Section(header: Text("Profile").bold()) {
                VStack{
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
                //}
                
                FormSection(header: "Personal Details") {
                    TextField("Full Name", text: $nameFromUI)
                        .padding(.horizontal, 10)
                        .frame(width: 280, height: 30)
                        .border(Color.gray, width: 1)
                    
                    
                    Text("Email: \(email)")
                    
                    TextEditor(text: $bioFromUI)
                    //                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
                        .frame(width: 280, height: 100)
                        .border(Color.gray, width: 1)
                    //.padding()
                }
                
                if self.role == "Investor" || self.role == "Realtor"{
                    FormSection(header: "Your Rating") {
                        RatingView(rating: rating)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(8)
                    }
                }
                
                FormSection(header: "Contact Information") {
                    TextField("Company", text: $companyFromUI)
                        .padding(.horizontal, 10)
                        .frame(width: 280, height: 30)
                        .border(Color.gray, width: 1)
                    
                    TextField("Address", text: $addressFromUI)
                        .padding(.horizontal, 10)
                        .frame(width: 280, height: 30)
                        .border(Color.gray, width: 1)
                    
                    TextField("Phone Number", text: $contactNumberFromUI)
                        .padding(.horizontal, 10)
                        .frame(width: 280, height: 30)
                        .border(Color.gray, width: 1)
                }
                
                if let err = errorMsg {
                    Text(err).foregroundColor(Color.red).bold()
                }
            }
            HStack{
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
                    //self.presentationMode.wrappedValue.dismiss()
                    
                    if let loginedUserRole = dbHelper.userProfile?.role{
                        if loginedUserRole == "Owner"{
                            self.rootScreen = .Home
                        }
                        else if loginedUserRole == "Investor"{
                            self.rootScreen = .InvestorHome
                        }
                        else if loginedUserRole == "Realtor"{
                            self.rootScreen = .RealtorHome
                        }
                        else if loginedUserRole == "Admin"{
                            self.rootScreen = .Admin
                        }
                    }else
                    {
                        self.rootScreen = .Home
                    }
                    
                    //rootScreen = .Home
                }) {
                    Text("Update Profile")
                    //.font(.headline)
                    //.frame(maxWidth: .infinity)
                    //.padding()
                    //.background(Color.green)
                    //.foregroundColor(.white)
                    // .cornerRadius(8)
                }.buttonStyle(.borderedProminent)
                Spacer()
                Button(action:{
                    if(self.role == "Investor"){
                        self.rootScreen = .InvestorHome
                    }else if self.role ==  "Owner"{
                        self.rootScreen = .Home
                    } else if self.role == "Realtor"
                    {
                        self.rootScreen =  .RealtorHome
                    
                    } else if self.role ==  "Admin"{
                        self.rootScreen =  .Admin
                    }
                }){
                    Text("Back")
                }.buttonStyle(.borderedProminent)
            }
            Spacer()
        }
        
        .padding(.horizontal, 10)
        // }
        
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
                self.role = currentUser.role
                if let company = currentUser.company{
                    self.companyFromUI = company
                }
                // MARK: Show image from db
                if let imageData = currentUser.profilePicture as? Data {
                    self.imageData = imageData
                } else {
#if DEBUG
                    print("Invalid image data format")
                    #endif
                }
            }}
        
        .navigationBarItems(leading: Button(action: {
            if(self.role == "Investor"){
                self.rootScreen = .InvestorHome
            }else if self.role ==  "Owner"{
                self.rootScreen = .Home
            } else if self.role == "Realtor"
            {
                self.rootScreen =  .RealtorHome
            }
            else if self.role == "Admin"
            {
                self.rootScreen =  .Admin
            }
            //self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("< Back")
        })
        .sheet(isPresented: $isShowingPicker) {
            // Image picker view
            if photoLibraryManager.isAuthorized {
                ImagePickerView(selectedImage: $selectedImage)
            } else {
                Text("Access to the photo library is not authorized.")
            }
        }
    Spacer()
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
