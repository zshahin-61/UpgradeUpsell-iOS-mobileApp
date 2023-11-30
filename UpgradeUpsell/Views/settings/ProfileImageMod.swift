//
//  ProfileImageMod.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-11-30.
//

import SwiftUI

import SwiftUI

extension Image {
    
    func profileImageMod() -> some View {
        self
            .resizable()
            .frame(width: 150, height: 150)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
    }
    
}
