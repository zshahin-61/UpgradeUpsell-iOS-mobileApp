//
//  SwiftUIView.swift
//  UpgradeUpsell
//  Created by Created by Zahra Shahin - Golnaz Chehrazi .
//

import SwiftUI

struct MakeOffers_InvestorView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var dbHelper: FirestoreController

    let project: RenovateProject

    @State private var amountOffered = ""
    @State private var durationWeeks = ""
    @State private var description = ""

    @State private var alertMessage = ""
    @State private var showAlert = false

    var body: some View {
        VStack{
            Form {
                Section(header: Text("Property Information").font(.headline)) {
                    HStack{
                        Text("Title: ").bold()
                        Text("\(project.title)")}
                    HStack{
                        Text("Category: ").bold()
                        Text("\(project.category)")
                    }
                    HStack{
                        Text("Released date: ").bold()
                        Text("\(formattedDate(from: project.createdDate))")
                    }
                    VStack{
                        Text("need to be done between: ").bold()
                        HStack{ Text(" \(formattedDate(from: project.startDate))")
                            Text("   to    \(formattedDate(from: project.endDate))")
                        }
                    }
                    VStack{
                        Text("Description: ").bold()
                        Text("\(project.description)")
                    }
                    HStack{
                        Text("Likes: ").bold()
                        Text("\(project.favoriteCount)")
                        Spacer()
                        Text("Status: ").bold()
                        Text("\(project.status)")
                    }
                    HStack{
                        Text("Location: ").bold()
                        Text("\(project.location)")
                    }
                    //                Text("Title: \(project.title)")
                    //                Text("Category: \(project.category)")
                    //                Text("Released Date: \(formattedDate(from: project.createdDate))")
                    //                VStack{
                    //                    Text("Need to be done between:")
                    //                    Text("From: \(formattedDate(from: project.startDate))")
                    //                    Text("To: \(formattedDate(from: project.endDate))")
                    //                }
                    //                Text("Description: \(project.description)")
                    //                HStack{
                    //                    Text("Likes: \(project.favoriteCount)")
                    //                    Spacer()
                    //                    Text("Status: \(project.status)")
                    //                }
                    //                Text("Location: \(project.location)")
                }
                
                Section(header: Text("Make an Offer").font(.headline)) {
                    TextField("Amount Offered", text: $amountOffered).textFieldStyle(.roundedBorder)
                    TextField("Duration in Weeks", text: $durationWeeks).textFieldStyle(.roundedBorder)
                    Text("Description:")
                    TextEditor(text: $description)
                        .frame(height: 200)
                        .border(Color.gray, width: 1)
                }
            }
            Section {
                Button("Submit") {
                    let newOffer = InvestmentSuggestion(
                        id: UUID().uuidString,
                        investorID: self.dbHelper.userProfile?.id ?? "",
                        investorFullName: self.dbHelper.userProfile?.fullName ?? "",
                        ownerID: project.ownerID,
                        projectID: project.id!,
                        projectTitle: project.title,
                        amountOffered: Double(amountOffered) ?? 0.0,
                        durationWeeks: Int(durationWeeks) ?? 0,
                        description: description,
                        status: "New",
                        date: Date()
                    )
                    
                    self.dbHelper.addInvestmentSuggestion(newOffer) { error in
                        if let error = error {
                            alertMessage = "Error: \(error.localizedDescription)"
                        } else {
                            alertMessage = "Suggestion added successfully"
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        showAlert = true
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
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

    func formattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}
