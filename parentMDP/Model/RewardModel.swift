//
//  RewardModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import Foundation

struct RewardModel: Identifiable, Codable {
    var id: String
    var name: String
    var category: String
    let createdBy: String
    let timeCreated: Date
    var rarity: String
    var price: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, category, createdBy, timeCreated, rarity, price
    }
}


struct RewardPurchaseModel: Identifiable, Codable {
    var id: String
    var name: String
    var category: String
    let timePurchased: Date
    let createdBy: String
    var status: String
    var purchasedBy: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, category, timePurchased, createdBy, status, purchasedBy
    }
}



enum RewardCategoryOption: CaseIterable, Hashable, CustomStringConvertible {
    case travel, object, privileges, special

    var description: String {
        switch self {
        case .travel: return "Travel"
        case .object: return "Object"
        case .privileges: return "Privileges"
        case .special: return "Special"

        }
    }

    func emoji() -> String {
        switch self {
        case .travel: return "✈️"
        case .object: return "📦"
        case .privileges: return "👏🏼"
        case .special: return "⭐️"
        }
    }
}
