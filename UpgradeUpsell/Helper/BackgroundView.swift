//
//  BackgroundView.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-10-17.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}
