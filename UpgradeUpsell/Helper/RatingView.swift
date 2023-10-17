//
//  RatingView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-10-17.
//

import SwiftUI

struct RatingView: View {
    var rating: Double
    
    var body: some View {
        HStack {
            ForEach(1..<6, id: \.self) { index in
                Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
        }
    }
}
