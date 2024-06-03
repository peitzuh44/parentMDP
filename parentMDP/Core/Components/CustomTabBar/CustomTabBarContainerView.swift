//
//  CustomTabBarContainerView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/17.
//

import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
    
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = [.home, .quest, .challenge, .reward]
    private let tabBarHeight: CGFloat = 70
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content){
        self._selection = selection
        self.content = content()
    }
    
    
    var body: some View {
        ZStack(alignment: .bottom){
            content
                .padding(.bottom, tabBarHeight) // Add padding to make room for the tab bar
            CustomTabBarView(tabs: tabs, selection: $selection)

        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
}

