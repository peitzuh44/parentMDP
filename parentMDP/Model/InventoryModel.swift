//
//  InventoryModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import Foundation


/// equipment - something that when you equipped or uneqquiped it will change your attributes
struct EquipmentModel: Identifiable, Codable, Hashable{
    var id: String
    var name: String
    var image: String
    var type: String //head, shoe, upper body...
    var value: Int
    var currency: String // gold or gem
    var isEquipped: Bool
 

    enum CodingKeys: String, CodingKey {
        case id, name, image, type, value, currency, isEquipped
    }
}


/// consumable
/// 1. food / poison - when you eat it increases your certain attribute forever.
/// 2. material - use it to synthesize other things

struct ConsumableModel: Identifiable, Codable, Hashable{
    var id: String
    var name: String
    var image: String
    var type: String //poison, materials...
    var currency: String // gold or gem
    var value: Int
 

    enum CodingKeys: String, CodingKey {
        case id, name, image, type, currency, value
    }
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



/// select reward -> puchase by -> update kid balance -> add reward to the kid's inventory


/// fetching inventory
/// - fetching equipment
/// - fetching final goods - food, poison
/// - fetching raw materials / ingredient



