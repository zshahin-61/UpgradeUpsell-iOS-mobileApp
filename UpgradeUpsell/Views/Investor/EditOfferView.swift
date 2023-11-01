//
//  EditOfferView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-10-31.
//

import SwiftUI

struct EditOfferView: View {
    @Binding var isPresented: Bool
    @Binding var suggestion: InvestmentSuggestion

    @State private var amountOfferedString: String

    init(isPresented: Binding<Bool>, suggestion: Binding<InvestmentSuggestion>) {
        _isPresented = isPresented
        _suggestion = suggestion
        _amountOfferedString = State(initialValue: String(suggestion.wrappedValue.amountOffered))
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Offer")) {
                    TextField("Amount Offered", text: $amountOfferedString)
                        .keyboardType(.decimalPad)
                }
                Button("Save") {
                    // Convert the edited amountOfferedString back to Double and update the suggestion.
                    if let amountOffered = Double(amountOfferedString) {
                        suggestion.amountOffered = amountOffered
                    }
                    isPresented = false
                }
            }
            .navigationBarTitle("Edit Offer")
        }
    }
}
