//
//  CustomTextEditor.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/20.
//
import SwiftUI

struct DynamicHeightTextEditor: View {
    @Binding var text: String
    let placeholder: String
    var backgroundColor: Color
    var textColor: Color
    var placeholderTextColor: Color
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(placeholderTextColor)
                    .padding(4)
            }
            TextEditor(text: $text)
                .foregroundColor(textColor)
                .padding(4)
                .background(backgroundColor)
        }
        .frame(minHeight: 200, maxHeight: .infinity) // Set your own flexible height
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(backgroundColor, lineWidth: 1) // Stroke with the same color to hide border
        )
    }
}


// The PreferenceKey and DynamicHeightPreference remain unchanged

struct DynamicHeightPreferenceKey: PreferenceKey {
    static var defaultValue: [DynamicHeightPreference] = []
    static func reduce(value: inout [DynamicHeightPreference], nextValue: () -> [DynamicHeightPreference]) {
        value.append(contentsOf: nextValue())
    }
}

struct DynamicHeightPreference: Equatable {
    let height: CGFloat
}
