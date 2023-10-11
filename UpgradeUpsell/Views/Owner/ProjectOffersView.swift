import SwiftUI

struct ProjectOffersView: View {
    
    @EnvironmentObject var authHelper : FireAuthController
    @EnvironmentObject var dbHelper : FirestoreController
    
    @State private var suggestions: [InvestmentSuggestion] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            List {
                if dbHelper.userProfile == nil {
                    Text("No user login")
                } else if isLoading {
                    // Display a loading indicator while data is being fetched.
                    ProgressView()
                } else {
                    // Display investment suggestions when they are available.
                    ForEach(suggestions, id: \.id) { suggestion in
                        Button(action:{
                            
                        }){
                            Text("SALAM")
//                            self.dbHelper.getRenovateProjectByID(suggestion.projectID) { (project, error) in
//                                if let error = error {
//                                    print("\(error)")
//                                }
//                                else if let prj = project{
                                    Text("Investment suggestion: \(suggestion.projectID), \(suggestion.amountOffered), \(suggestion.durationWeeks)")
//                                }
//                                else
//                                {
//                                    Text("No Offers")
//                                    print("no offers")
//                                }
                            //}
                        }
                    }
                }
            }
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
