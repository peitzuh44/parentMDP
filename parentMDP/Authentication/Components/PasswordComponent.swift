//
//  PasswordComponent.swift
//  parentMDP
//
//  Created by Eric Tran on 3/7/24.
//

import SwiftUI

struct PasswordComponent: View {
    // MARK: Properties
    @Binding var password: String
    
    // MARK: Body
    var body: some View {
        HStack {
            Image(systemName: "lock")
                .foregroundColor(.gray)
            SecureField("", text: $password, prompt: Text("Password").foregroundColor(.gray))
                .foregroundColor(.white)

            
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .foregroundColor(.white)
            
        )
        .padding()
    }
}
