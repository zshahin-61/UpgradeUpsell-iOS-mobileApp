//
//  SwiftUIView.swift
//  UpgradeUpsell
//  Created by Created by Zahra Shahin - Golnaz Chehrazi .
//

import SwiftUI

struct MakeOffers_InvestorView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var dbHelper: FirestoreController
    //@EnvironmentObject var authHelper: FireAuthController
    
    let project: RenovateProject
        
    @State private var amountOffered = "" // Removed the initial value
    @State private var durationWeeks = "" // Removed the initial value
    @State private var description = "" // Removed the initial value

        
        @State private var alertMessage = ""
        @State private var showAlert = false

        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Section(header: Text("Property Information").bold()){
                    //Text("Investor ID: \(dbHelper.userProfile?.id!)")
                    HStack{
                        Text("Title: ").bold()
                        Text("\(project.title)")}
                    HStack{
                        Text("Category: ").bold()
                        Text("\(project.category)")
                    }
                    HStack{
                        Text("Released date: ").bold()
                        Text("\(dateFormatter.string(from: project.createdDate))")
                    }
                    VStack{
                        Text("need to be done between: ").bold()
                        Text("From: \(dateFormatter.string(from: project.startDate))")
                        Text("To: \(dateFormatter.string(from: project.endDate))")
                    }
                    HStack{
                        Text("Description: ").bold()
                        Text("\(project.description)")
                    }
                    HStack{
                        Text("Likes: ").bold()
                        Text("\(project.favoriteCount)")
                    }
                    HStack{
                        Text("Status: ").bold()
                        Text("\(project.status)")
                    }
                    HStack{
                        Text("Location: ").bold()
                        Text("\(project.location)")
                    }
                    
                }
                    Form{
                        TextField("Amount Offered", text: $amountOffered)
                        TextField("Duration in Weeks", text: $durationWeeks)
                        //TextField("Description", text: $description)
                        Text("Description:")
                        TextEditor(text: $description)
                                        .frame(height: 200) // Adjust the height as needed
                                        .border(Color.gray, width: 1)
                                        .padding()
                    }
                        //TextField("Status", text: $status)
                HStack{
                    Spacer()
                    Button("Submit") {
                        let newOffer : InvestmentSuggestion = InvestmentSuggestion(id: UUID().uuidString, investorID: self.dbHelper.userProfile?.id ?? "", investorFullName: self.dbHelper.userProfile?.fullName ?? "", ownerID: project.ownerID, projectID: project.id!, projectTitle: project.title,amountOffered: Double(amountOffered) ?? 0.0 , durationWeeks: Int(durationWeeks) ?? 0, description: description, status: "New", date: Date())
                        
                        self.dbHelper.addInvestmentSuggestion(newOffer) { error in
                            if let error = error {
                                // Handle error if needed
                                print("Error: \(error.localizedDescription)")
                                alertMessage = "Error: \(error.localizedDescription)"
                            } else {
                                // Suggestion added successfully, you can navigate or show a confirmation message
                                print("Suggestion added successfully")
                                alertMessage = "Suggestion added successfully"
                                
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            showAlert = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
                    Spacer()
            } // VSTACK
            .padding()
            .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Conversion Result"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
            .navigationBarTitle("Add an Offer")
        }
    
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
        }()
    
    }
