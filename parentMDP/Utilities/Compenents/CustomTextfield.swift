//
//  CustomTextfield.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI

struct CustomTextfield: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    let background: Color
    @FocusState var focused: Bool
    let color: Color


    var body: some View {
        let isActive = focused || text.count > 0

        HStack {
            Image(systemName: icon)
            TextField(placeholder, text: $text)
                .focused($focused)
                .foregroundColor(.white)
                .autocorrectionDisabled()
                .autocapitalization(.none)
            // Use the Binding directly
        }
        .onTapGesture {
            focused = true
        }
        .padding(20)
        .background(background)
        .cornerRadius(10)

        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(focused ? AnyShapeStyle(color) : AnyShapeStyle(background),
                        lineWidth: 1
                )
        }
        .padding(.horizontal)
    }
}
