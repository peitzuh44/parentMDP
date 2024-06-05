//
//  CustomTabBarContainerView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/17.
//

import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
    @Binding var selection: TabBarItem
    @Binding var hideTabBar: Bool
    let content: Content
    @State private var tabs: [TabBarItem] = [.home, .quest, .challenge, .reward]
    private let tabBarHeight: CGFloat = 70

    init(selection: Binding<TabBarItem>, hideTabBar: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self._hideTabBar = hideTabBar
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .padding(.bottom, hideTabBar ? 0 : tabBarHeight) // Adjust padding based on hideTabBar

            if !hideTabBar {
                CustomTabBarView(tabs: tabs, selection: $selection)
                    .frame(height: tabBarHeight)
                    .transition(.move(edge: .bottom)) // Optional: Add a transition for better UX
            }
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
}
