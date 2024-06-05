//
//  GenericMultiselectPicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/23.
//

import SwiftUI

struct GenericMultiSelectPicker<Content: View>: View {
    let pickerText: String
    @Binding var isPresenting: Bool
    let content: () -> Content

    var body: some View {
        Button(action: {
            self.isPresenting = true
        }) {
            VStack{
                HStack {
                    Text(pickerText)
                    Spacer()
                }
//                ForEach(selectedSkills){
//                    HStack{
//                        Image("attack")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 24)
//                        Text("Skill")
//                            .foregroundStyle(Color.customDarkBlue)
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.white)
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                    .padding()
//                }
            }
            .frame(maxWidth: .infinity)
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

