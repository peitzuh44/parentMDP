//
//  TemplateModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/17.
//

import Foundation

// MARK: Skill Template Model
//struct SkillTemplateModel: Identifiable, Codable, Hashable{
//    var id: String
//    var name: String
//    var category: String
//    
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case category
//    }
//}


struct TaskTemplateModel: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var category: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, category
    }
}
