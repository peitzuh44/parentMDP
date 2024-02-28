//
//  ChallengeModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import Foundation
struct ChallengeModel: Identifiable, Codable {
    var id: String
    var name: String
    let createdBy: String
    let timeCreated: Date
    var assignTo: String
    var difficulty: String
    var due: Date
    var status: String
    var reward: Int
    var assignedOrSelfSelected: String


    enum CodingKeys: String, CodingKey {
        case id, name, createdBy, timeCreated, assignTo, difficulty, due, status, reward, assignedOrSelfSelected
    }
   
}
