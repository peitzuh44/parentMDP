//
//  TabBarItem.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/17.
//

import SwiftUI



enum TabBarItem: Hashable {
    case home, quest, challenge, reward
    
    var image: String {
        switch self {
        case .home: return "home"
        case .quest: return "check"
        case .challenge: return "challenge"
        case .reward: return "gift"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Homw"
        case .quest: return "Quest"
        case .challenge: return "Challenge"
        case .reward: return "Reward"
        }
    }
    
    var color: Color {
        switch self {
        case.home: return Color.red
        case.quest: return Color.yellow
        case.challenge: return Color.green
        case.reward: return Color.blue

            
        }
    }
    
}


