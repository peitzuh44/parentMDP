//
//  PricePicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/15.
//
import SwiftUI

struct PricePicker: View {
    @Binding var selectedPrice: Int
    let priceRange: [Int] = Array(stride(from: 10, to: 1000, by: 10))
    var body: some View {
        ZStack {
            Color.customNavyBlue.ignoresSafeArea(.all)
            Picker(selection: $selectedPrice, label: Text("Price").foregroundColor(.white)) {
                ForEach(priceRange, id: \.self) { price in
                    Text("$\(price)").foregroundColor(.white).tag(price)
                }
            }
            .padding()
            .pickerStyle(WheelPickerStyle())
            .frame(height: 150)
            .clipped()
        }
        .colorScheme(.dark)
    }
}

struct PricePicker_Previews: PreviewProvider {
    @State static var selectedPrice: Int = 0

    static var previews: some View {
        PricePicker(selectedPrice: $selectedPrice)
    }
}
