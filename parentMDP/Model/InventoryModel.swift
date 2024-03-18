//
//  InventoryModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import Foundation

// MARK: Wearable Model
struct WearableShopItemModel: Identifiable, Codable, Hashable{
    var id: String
    var name: String
    var image: String
    // var bodyPart:
    var price: Int
}


struct WearableModel: Identifiable, Codable, Hashable{
    var id: String
    var owner: String
    var original: String
    var name: String
    var image: String
//    var bodyPart:
    var isEquipped: Bool
}

struct TransactionModel: Identifiable, Codable, Hashable{
    var id: String
    var name: String
    let timePurchased: Date
    var purchasedBy: String
    var cost: Int
    var currency: String
    
 

    enum CodingKeys: String, CodingKey {
        case id, name, timePurchased, purchasedBy, cost, currency
    }
}


