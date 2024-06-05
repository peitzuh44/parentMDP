//
//  GenericPickerButton.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/23.
//

import SwiftUI

struct GenericPickerButton<Content: View>: View {
    let pickerText: String
    let selectionText: String
    @Binding var isPresenting: Bool
    let content: () -> Content
    
    var body: some View {
        Button(action: {
            self.isPresenting = true
        }) {
            HStack {
                Text(pickerText)
                Spacer()
                Text(selectionText)
            }
            .frame(width: 330, height: 24)
            .foregroundColor(.white)
            .padding()
            .background(Color.customNavyBlue)
            .cornerRadius(10)
        }
        .sheet(isPresented: $isPresenting) {
            self.content()
        }
    }
}

