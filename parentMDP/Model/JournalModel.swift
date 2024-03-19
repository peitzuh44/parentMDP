//
//  JournalModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/17.
//

import Foundation


// MARK: Journal Model
struct JournalModel: Identifiable, Codable, Hashable{
    var id: String
    var title: String
    let timeCreated: Date
    let creator: String
    var mood: [String]
    var relatedTags: [String]
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, timeCreated, creator, mood, relatedTags, content
    }
}
