import SwiftUI
import Firebase

struct CreateProjectView: View {
    @EnvironmentObject var dbHelper: FirestoreController
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var lng: Double = 0.0
    @State private var lat: Double = 0.0
    @State private var ownerID = ""
    @State private var category = ""
    @State private var investmentNeeded: Double = 0.0
    @State private var status = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                Section(header: Text("Property Information")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    TextField("Location", text: $location)
                    TextField("Longitude", value: $lng, formatter: NumberFormatter())
                    TextField("Latitude", value: $lat, formatter: NumberFormatter())
                    TextField("Owner ID", text: $ownerID)
                    TextField("Category", text: $category)
                    TextField("Investment Needed", value: $investmentNeeded, formatter: NumberFormatter())
                    TextField("Status", text: $status)
                }
                VStack {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                
                Section {
                    Button(action: {
                        // Create a RenovateProject object with the input data
                        let newProperty = RenovateProject(
                            title: title,
                            description: description,
                            location: location,
                            lng: lng,
                            lat: lat,
                            images: [], // Add images as needed
                            ownerID: ownerID,
                            category: category,
                            investmentNeeded: investmentNeeded,
                            selectedInvestmentSuggestionID: "", // Provide a valid value for selectedInvestmentSuggestionID
                            status: status,
                            startDate: startDate,
                            endDate: endDate,
                            createdDate: Date(),
                            updatedDate: Date(),
                            favoriteCount: 0,
                            realtorID: "" // Set the realtorID as needed
                        )
                        
                        // Save the property to Firestore
                        dbHelper.addProperty(newProperty, userID: ownerID) { success in
                            if success {
                                // Property saved successfully
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }) {
                        Text("Add Property")
                    }

                }
            }
            .navigationBarTitle("Add Property")
        }
    }
}

struct CreateProjectView_Previews: PreviewProvider {
    static var previews: some View {
        CreateProjectView()
    }
}
