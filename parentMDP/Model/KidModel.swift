//
//  KidModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import Foundation


// MARK: KidModel
struct KidModel: Identifiable, Codable, Hashable{
    var id: String
    let timeCreated: Date
    var name: String
    let gender: String
    let birthdate: Date
    var parentID: String
    let myParent: String
    // avatar attributes
    var avatarImage: String
    var health: Int
    var mental: Int
    var social: Int
    var intelligence: Int
    // currency
    var coinBalance: Int
    var gemBalance: Int
    
    enum CodingKeys: String, CodingKey {
        case id, timeCreated, name, gender, birthdate, parentID, myParent, avatarImage, health, mental, social, intelligence, coinBalance, gemBalance
    }
}



struct SkillModel: Identifiable, Codable, Hashable{
    var id: String
    var name: String
    let createdBy: String
    let kid: String
    var category: String
    var exp: Int
    var level: Int
    
    
    enum CodingKeys: String, CodingKey {
        case id, createdBy, kid, name, category, exp, level
    }
}
