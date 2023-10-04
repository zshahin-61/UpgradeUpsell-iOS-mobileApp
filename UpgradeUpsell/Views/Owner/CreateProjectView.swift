import SwiftUI

struct CreateProjectView: View {
    @State private var propertyTitle = ""
    @State private var propertyType = ""
    @State private var propertyDescription = ""
    @State private var streetAddress = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var bedrooms = ""
    @State private var bathrooms = ""
    @State private var propertySize = ""
    @State private var price = ""
    @State private var contactName = ""
    @State private var contactEmail = ""
    @State private var contactPhone = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Property Information")) {
                    TextField("Property Title", text: $propertyTitle)
                    TextField("Property Type", text: $propertyType)
                    TextField("Street Address", text: $streetAddress)
                    TextField("City", text: $city)
                    TextField("State/Province", text: $state)
                    TextField("ZIP/Postal Code", text: $zipCode)
                    TextField("Number of Bedrooms", text: $bedrooms)
                    TextField("Number of Bathrooms", text: $bathrooms)
                    TextField("Property Size", text: $propertySize)
                    TextField("Price", text: $price)
                }
                
                Section(header: Text("Property Description")) {
                    TextEditor(text: $propertyDescription)
                        .frame(height: 100)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(5)
                }
                
                Section(header: Text("Contact Information")) {
                    TextField("Name", text: $contactName)
                    TextField("Email", text: $contactEmail)
                    TextField("Phone", text: $contactPhone)
                }
                
                Section {
                    Button(action: {
                        // Save the property information to your database
                        // You can add validation and saving logic here
                    }) {
                        Text("Submit Property")
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            .navigationTitle("Add Property")
        }
    }
}

struct CreateProjectView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProjectView()
    }
}
