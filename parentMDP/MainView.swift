//
//  MainView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/13.
//

import SwiftUI

struct MainView: View {
    @Binding var authFlow: AuthFlow
    @State private var selection: TabBarItem = .home

    var body: some View {
        CustomTabBarContainerView(selection: $selection) {
            DashboardView()
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

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(authFlow: .constant(.authenticated))
    }
}
