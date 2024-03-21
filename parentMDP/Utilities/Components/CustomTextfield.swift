//
//  CustomTextfield.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//  Edited by Eric Tran on 2024/3/7.
//
//  This is the view for the text field component that can be customized accordingly to the values passed into it, the focused state is used to activate an overlay over the text field whenever the text box is focused on

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
                .foregroundColor(.gray)
            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.gray))
                .focused($focused)
                .foregroundColor(.white)
                .autocorrectionDisabled()
                .autocapitalization(.none)
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


struct CustomTextEditor: View {
    @Binding var text: String
    let placeholder: String
    let background: Color

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
            TextEditor(text: $text)
                .foregroundColor(.white)
                .background(background)
                .frame(height: 250)
                .onChange(of: text) { newValue in
                    let words = newValue.split { $0.isWhitespace || $0.isNewline }
                    if words.count > 100 {
                        text = words.prefix(100).joined(separator: " ")
                    }
                }
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .padding(.top, 8)
        }
        .padding(20)
        .background(background)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
