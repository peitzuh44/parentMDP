//
//  HScrollPicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/23.
//

import SwiftUI


import SwiftUI

struct HScrollPicker<SelectionValue, Content>: View
where SelectionValue: CaseIterable & Hashable & CustomStringConvertible, Content: View {
    @Binding var selection: SelectionValue
    @Namespace private var namespace
    
    // Content closure that takes a SelectionValue and returns a View
    let content: (SelectionValue) -> Content

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(SelectionValue.allCases), id: \.self) { value in
                        Button(action: {
                            switchToValue(value: value, proxy: proxy)
                        }) {
                            content(value)
                                .id(value)
                        }
                        .foregroundStyle(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 10)
            }
            .background(Color.clear.brightness(-0.3))
        }
    }
    
    private func switchToValue(value: SelectionValue, proxy: ScrollViewProxy){
        withAnimation(.easeInOut) {
            selection = value
            proxy.scrollTo(value, anchor: .center)
        }
    }
}


//
//struct SkillCategorySelector: View {
//    @Binding var selectedCategory: SkillCategoryOption
//
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 8) {
//                ForEach(SkillCategoryOption.allCases, id: \.self) {
//                    category in
//                    Button(action: {
//                        selectedCategory = category
//                    }) {
//                        HStack(spacing: 10) {
//                            Text(emoji(for: category))
//                            Text(category.rawValue)
//                                .foregroundColor(.white)
//                        }
//                        .padding()
//                        .background(selectedCategory == category ? Color.customPurple : Color.black.opacity(0.6))
//                        .cornerRadius(10)
//                    }
//                }
//            }
//            .padding(.horizontal, 10)
//        }
//    }
//    private func emoji(for category: SkillCategoryOption) -> String {
//        switch category {
//
//        case .sports:
//            return "💪🏻"
//        case .mathLogic:
//            return "🧮"
//        case .language:
//            return "📝"
//        case .dance:
//            return "💃🏻"
//        case .music:
//            return "🎹"
//        case .stem:
//            return "🧪"
//        case .visualArt:
//            return "🎨"
//        }
//    }
//
//}
//
