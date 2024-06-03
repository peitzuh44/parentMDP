//
//  ChallengeModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import Foundation


// MARK: Challenge model
struct ChallengeModel: Identifiable, Codable {
    var id: String
    var name: String
    var description: String
    var comment: String?
    let timeCreated: Date
    let createdBy: String
    var assignTo: String
    var difficulty: String
    var reward: Int
    var due: Date
    var relatedSkills: [String]? // IDs of skills related to this challenge
    var status: String
    var dateCompleted: Date?

    enum CodingKeys: String, CodingKey {
        case id, name, description, comment, timeCreated, createdBy, assignTo, difficulty, reward, due, relatedSkills, status, dateCompleted
    }
}
