//
//  ProgressBar.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/14.
//

import SwiftUI

import SwiftUI

struct CircularProgressBar: View {
    var diameter: CGFloat
    var percent: CGFloat
    var color1: Color
    var color2: Color

    var body: some View {
        let radius = diameter / 2
        let progress = percent / 100
        
        return ZStack {
            Circle()
                .stroke(Color.black.opacity(0.35), lineWidth: 5)
                .frame(width: diameter, height: diameter)

            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .leading, endPoint: .trailing),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                )
                .frame(width: diameter, height: diameter)
                .rotationEffect(.degrees(-90))
        }
    }
}

#Preview {
    CircularProgressBar(diameter: 130, percent: 40, color1: .blue, color2: .purple)
}


struct LinearProgressBar: View {
    var width: CGFloat
    var height: CGFloat
    var percent: CGFloat
    var color1: Color
    var color2: Color
    var body: some View {
        let multiplier = width / 100
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: height, style: .continuous)
                .frame(width: width, height: height)
                .foregroundColor(Color.black.opacity(0.35))
            RoundedRectangle(cornerRadius: height, style: .continuous)
                .frame(width: percent * multiplier, height: height)
                .background(
                    LinearGradient(gradient: Gradient(colors: [color1, color2]), startPoint: .leading, endPoint: .trailing)
                        .clipShape(RoundedRectangle(cornerRadius: height, style: .continuous))
                    
                )
                .foregroundColor(.clear)
            
        }
    }
}
