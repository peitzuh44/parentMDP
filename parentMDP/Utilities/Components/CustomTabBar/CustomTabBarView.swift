//
//  CustomTabBarView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/17.
//

import SwiftUI


struct CustomTabBarView: View {
    
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace

    var body: some View {
        HStack{
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
                
            }
        }
        .background(
            Color.white.ignoresSafeArea(edges: .bottom)
            
        )
        
    }
    
}

extension CustomTabBarView {
    private func tabView(tab: TabBarItem) -> some View {
        VStack{
            Image(tab.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 36)
            Text(tab.title)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.black)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            ZStack{
                if selection == tab {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            }
        )
        
    }
    
    private func switchToTab(tab: TabBarItem){
        withAnimation(.easeInOut) {
            selection = tab
        }
    }
    
}

