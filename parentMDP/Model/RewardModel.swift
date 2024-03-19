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
    let createdBy: String
    let timeCreated: Date
    var rarity: String
    var price: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, createdBy, timeCreated, rarity, price
    }
}


struct RewardPurchaseModel: Identifiable, Codable {
    var id: String
    var name: String
    let timePurchased: Date
    let createdBy: String
    var status: String
    var purchasedBy: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, timePurchased, createdBy, status, purchasedBy
    }
}
