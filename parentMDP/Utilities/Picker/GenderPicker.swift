//
//  GenderPicker.swift
//  parentMDP
//
//  Created by Eric Tran on 3/7/24.

import SwiftUI

struct GenderPicker: View {
    // MARK: Properties
    @Binding var selectedGender: GenderOptions

    // MARK: Body
    var body: some View {
        HStack{
            ForEach(GenderOptions.allCases, id: \.self) { option in
                Button(action: {
                    self.selectedGender = option
                }) {
                    VStack(spacing: 24) {
                        Image(option.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80)
                        Text(option.rawValue)
                            .foregroundColor(.white)
                    }
                    .frame(width: 130, height: 160)
                    .background(self.selectedGender == option ? Color.customPurple : Color.black.opacity(0.6))
                    .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}
