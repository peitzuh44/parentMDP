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
    var gender: String
    var birthdate: Date
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
    // subcollection
    var skills: [SkillModel]?
    var publicQuestsCompletedThisWeek: Int = 0 
    
    enum CodingKeys: String, CodingKey {
        case id, timeCreated, name, gender, birthdate, parentID, myParent, avatarImage, health, mental, social, intelligence, coinBalance, gemBalance, skills
    }
}


// MARK: Skills Model
struct SkillModel: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var category: String
    let createdBy: String
    let kid: String
    var exp: Int
    var completedChallenges: [String] // NEW: IDs of completed challenges related to this skill

    enum CodingKeys: String, CodingKey {
        case id, name, category, createdBy, kid, exp, completedChallenges
    }
}
