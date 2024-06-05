//
//  MainView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/13.
//

import SwiftUI
import Foundation

import SwiftUI
import Foundation

struct MainView: View {
    @Binding var authFlow: AuthFlow
    @State private var selection: TabBarItem = .home
    @State private var hideTabBar: Bool = false

    var body: some View {
        CustomTabBarContainerView(selection: $selection, hideTabBar: $hideTabBar) {
            DashboardView(authFlow: $authFlow, hideTabBar: $hideTabBar)
                .tabBarItem(tab: .home, selection: $selection)
            TaskView()
                .tabBarItem(tab: .quest, selection: $selection)
            ChallengeView()
                .tabBarItem(tab: .challenge, selection: $selection)
            RewardView()
                .tabBarItem(tab: .reward, selection: $selection)
        }
    }
}


