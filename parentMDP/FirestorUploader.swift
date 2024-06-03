//
//  FirestorUploader.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/6/2.
//


import SwiftUI
import FirebaseFirestore
import Firebase

struct SkillTemplateModel: Identifiable, Codable, Hashable {
    var id: String? = UUID().uuidString
    var name: String
    var category: String

    enum CodingKeys: String, CodingKey {
        case name
        case category
    }
}

//class FirestoreUploader {
//
//    
//    // MARK: A function that uploads skills
//    static func uploadSkillsData() {
//        guard let url = Bundle.main.url(forResource: "skills_template", withExtension: "json") else {
//            print("JSON file not found")
//            return
//        }
//
//        do {
//            let data = try Data(contentsOf: url)
//            let decoder = JSONDecoder()
//            let skills = try decoder.decode([SkillTemplateModel].self, from: data)
//
//            let db = Firestore.firestore()
//
//            for skill in skills {
//                db.collection("skillTemplates").addDocument(data: [
//                    "name": skill.name,
//                    "category": skill.category
//                ]) { err in
//                    if let err = err {
//                        print("Error writing document: \(err)")
//                    } else {
//                        print("Document successfully written!")
//                    }
//                }
//            }
//        } catch {
//            print("Error reading JSON file: \(error)")
//        }
//    }
//}
