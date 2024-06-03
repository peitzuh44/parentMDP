//
//  CustomSegmentedPicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/23.
//

import SwiftUI


struct CustomSegmentedPicker<SelectionValue>: View where SelectionValue: CaseIterable & Hashable, SelectionValue: CustomStringConvertible {
    @Binding var selection: SelectionValue
    @Namespace private var namespace


    var body: some View {
            HStack(spacing: 16) {
                ForEach(Array(SelectionValue.allCases), id: \.self) { value in
                    segment(value: value)
                        .onTapGesture {
                            switchToValue(value: value)
                        }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 12)
            .background(Color.white.brightness(-0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))

    }
}

extension CustomSegmentedPicker {
    private func segment(value: SelectionValue) -> some View {
        HStack {
            Text(value.description)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundStyle(self.selection == value ? Color.black : Color.gray)
        .background(
            ZStack{
                if selection == value {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.2))
                        .matchedGeometryEffect(id: "HScrollPicker", in: namespace)
                }
            }
        )
    }
    private func switchToValue(value: SelectionValue){
        withAnimation(.easeInOut) {
            selection = value
        }
    }
}


