//
//  KidModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import Foundation

struct KidModel: Identifiable, Codable, Hashable{
    var id: String
    var name: String
    let gender: String
    let birthdate: Date
    var parentID: String
    let myParent: String
    var createdAt: Date
    // avatar attributes
    var avatarImage: String
    var exp: Int
    var level: Int
    var avatarClass: String
    var hp: Int
    var attack: Int
    var defense: Int
    var magic: Int
    // currency
    var pointBalance: Int
    var goldBalance: Int
    var gemBalance: Int


    enum CodingKeys: String, CodingKey {
        case id, name, gender, birthdate, parentID, myParent, createdAt, avatarImage, exp, level, avatarClass, hp, attack, defense, magic, pointBalance, goldBalance, gemBalance
    }
}

struct SkillTemplateModel: Identifiable, Codable, Hashable{
    var id: String
    var name: String
    var category: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
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
        case id
        case createdBy
        case kid
        case name
        case category
        case exp
        case level
    }
}
