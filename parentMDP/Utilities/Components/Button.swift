//
//  Button.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import Foundation
import SwiftUI


struct ThreeD: ButtonStyle {
    @State var backgroundColor: Color
    @State var shadowColor: Color
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            let offset: CGFloat = 2
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(shadowColor)
                .offset(y: offset)
            
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(backgroundColor)
                .offset(y: configuration.isPressed ? offset: 0)
            
            configuration.label
                .offset(y: configuration.isPressed ? offset: 0)
        }
    }
}
