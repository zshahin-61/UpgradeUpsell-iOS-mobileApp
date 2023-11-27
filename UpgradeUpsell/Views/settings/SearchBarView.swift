//
//  SearchBarView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-27.
//

import SwiftUI

struct SearchBar222: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
        }
    }
}
