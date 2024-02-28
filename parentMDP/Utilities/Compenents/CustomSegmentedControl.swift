//
//  CustomSegmentedControl.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI

struct CustomSegmentedControl: View {
    let segments: [String]
    @Binding var selectedSegment: String
    @Namespace private var animationNamespace
    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments, id: \.self) { segment in
                Text(segment)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .foregroundColor(selectedSegment == segment ? .white : .gray)
                    .background(
                        ZStack {
                            if selectedSegment == segment {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.customPurple)
                                    .matchedGeometryEffect(id: "selectedBackground", in: animationNamespace)
                            }
                        }
                    )
                    .clipShape(Capsule())
                    .onTapGesture {
                        withAnimation(.smooth(duration: 0.2)) {
                            self.selectedSegment = segment
                        }
                    }
            }
        }
        .background(Capsule().fill(Color.black.opacity(0.2)))
        .clipShape(Capsule())
    }
}


