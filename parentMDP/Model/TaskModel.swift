//
//  TaskModel =.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/23.
//

import Foundation

struct TaskOriginalModel: Identifiable, Codable {
    var id: String
    var name: String
    let timeCreated: Date
    let createdBy: String
    var difficulty: String
    var repeatingPattern: String
    var selectedDays: [Int]?
    var startDate: Date
    var routine: String? // private task only
    var assignTo: String? // private task only
    var privateOrPublic: String
 
    enum CodingKeys: String, CodingKey {
        case id, name, timeCreated, createdBy, difficulty, repeatingPattern, selectedDays, startDate, routine, assignTo, privateOrPublic
        
    }
}

struct TaskInstancesModel: Identifiable, Codable {
    var id: String
    var name: String
    let timeCreated: Date
    let createdBy: String
    var difficulty: String
    var due: Date
    var repeatingPattern: String
    var taskOriginalID: String
    var status: String
    var routine: String? // private task only
    var assignTo: String? // private task only
    var completedBy: String // public †ask only
    var privateOrPublic: String
    
    
    enum CodingKeys: String, CodingKey {
        case id, name, timeCreated, createdBy, difficulty, due, repeatingPattern, taskOriginalID, status, routine, assignTo, completedBy, privateOrPublic
    }
}

