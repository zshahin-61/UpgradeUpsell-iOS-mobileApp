import SwiftUI
import Firebase


struct CreateProjectView: View {
    @EnvironmentObject var dbHelper: FirestoreController
    @EnvironmentObject var authHelper: FireAuthController
    @Environment(\.presentationMode) var presentationMode
    
//    @State private var userProjects: [RenovateProject] = []

    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var lng: Double = 0.0
    @State private var lat: Double = 0.0
    @State private var category = ""
    @State private var investmentNeeded: Double = 0.0
    @State private var status = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Property Information")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    TextField("Location", text: $location)
                    TextField("Longitude", value: $lng, formatter: NumberFormatter())
                    TextField("Latitude", value: $lat, formatter: NumberFormatter())
                    TextField("Category", text: $category)
                    TextField("Investment Needed", value: $investmentNeeded, formatter: NumberFormatter())
                    TextField("Status", text: $status)
                }
                Section(header: Text("Dates")) {
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                
                Section {
                    Button(action: {
                        guard let userID = authHelper.user?.uid else {
                            // Handle the case when the user is not signed in.
                            // You can show an alert or take appropriate action.
                            return
                        }
                        
                        let newProperty = RenovateProject(
                            projectID: UUID().uuidString,
                            title: title,
                            description: description,
                            location: location,
                            lng: lng,
                            lat: lat,
                            images: [],
                            ownerID: userID,
                            category: category,
                            investmentNeeded: investmentNeeded,
                            selectedInvestmentSuggestionID: "",
                            status: status,
                            startDate: startDate,
                            endDate: endDate,
                            createdDate: Date(),
                            updatedDate: Date(),
                            favoriteCount: 0,
                            realtorID: "" // Set the realtorID as needed
                        )
                        
                        dbHelper.addProperty(newProperty, userID: userID) { success in
                            if success {
                                // Property saved successfully
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                // Handle the case when there is an error saving the property.
                            }
                        }
                    }) {
                        Text("Add Property")
                    }
                }
            }
        }
    }
}

