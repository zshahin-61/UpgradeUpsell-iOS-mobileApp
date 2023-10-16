
import Foundation
import SwiftUI


struct ProjectOffersView: View {
    
    @EnvironmentObject var authHelper : FireAuthController
    @EnvironmentObject var dbHelper : FirestoreController
    
    @State private var suggestions: [InvestmentSuggestion] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            List {
                if dbHelper.userProfile == nil {
                    Text("No user login")
                } else if isLoading {
                    // Display a loading indicator while data is being fetched.
                    ProgressView()
                } else {
                    // Display investment suggestions when they are available.
                    ForEach(suggestions, id: \.id) { suggestion in
                        // Button(action:{
                        Section{
                            
                            HStack{
                                Text("Title:").bold()
                                Spacer()
                                Text("\(suggestion.projectTitle)")//.foregroundColor(.black)
                            }
                            Group{
                                HStack {
                                    NavigationLink(destination: InvestorProfileView(investorID: suggestion.investorID).environmentObject(self.authHelper).environmentObject(self.dbHelper)) {
                                        Text("Investor:").bold()
                                        Spacer()
                                        Text(suggestion.investorFullName) // Link to Investor Profile
                                    }
                                }
                                
                                HStack{
                                    Text("Offered amount:").bold()
                                    Spacer()
                                    Text(String(format: "%.2f", suggestion.amountOffered))//.foregroundColor(.black)
                                }
                                
                                HStack{
                                    Text("Duration:").bold()
                                    Spacer()
                                    Text("\(suggestion.durationWeeks) Weeks")//.foregroundColor(.black)
                                }
                            }
                            HStack{
                                Text("Status:").bold()
                                Spacer()
                                Text("\(suggestion.status)")//.foregroundColor(.black)
                            }
                            //VStack(alignment: .leading){//HStack{
                            //Text("Description:").bold()
                            //  Spacer()
                            HStack{
                                Text("\(suggestion.description)")
                                // .lineLimit(nil) // Allow it to wrap to the second line
                                // .fixedSize(horizontal: false, vertical: true) // Allow vertical expansion
                            }
                            //.foregroundColor(.black)
                            //  }
                            
                            //}
                        }
                    }
                }
            }            .padding()
            
                .onAppear {
                    // Fetch investment suggestions when the view appears.
                    if let ownerID = dbHelper.userProfile?.id {
                        self.isLoading = true
                        self.dbHelper.getInveSuggByOwnerID(ownerID: ownerID) { (suggestions, error) in
                            self.isLoading = false
                            if let error = error {
                                print("Error getting investment suggestions: \(error)")
                            } else if let suggestions = suggestions {
                                self.suggestions = suggestions
                            }
                        }
                    }
                }
            Spacer()
        }
    }
}
