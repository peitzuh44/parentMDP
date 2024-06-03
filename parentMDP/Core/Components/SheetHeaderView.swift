//
//  SheetHeaderView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/21.
//

import SwiftUI
struct SheetHeaderView: View {
    @Environment(\.presentationMode) var presentationMode
    let headerText: String
    var body: some View {
        HStack{
            //dimiss button
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }){
                Image(systemName: "xmark")
            }
            Spacer()
            Text(headerText)
            Spacer()
            
        }
        .foregroundColor(.white)
        .padding()
        .background(Color.customNavyBlue)
    }
}
