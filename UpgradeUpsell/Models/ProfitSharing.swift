//
//  ProfitSharing.swift
//  UpgradeUpsell
//
//  Created by Golnaz Chehrazi on 2023-09-20.
//

import Foundation
import FirebaseFirestoreSwift

struct ProfitSharing: Codable , Hashable, Identifiable {
    @DocumentID var id = UUID().uuidString
    //let profitID: String
    var projectID: String
    var investorShare: Double
    var ownerShare: Double
    var details: String
}
