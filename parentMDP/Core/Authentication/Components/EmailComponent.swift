//
//  EmailComponent.swift
//  parentMDP
//
//  Created by Eric Tran on 3/7/24.
//

import SwiftUI

struct EmailComponent: View {
    // MARK: Properties
    @Binding var email: String
    
    // MARK: Body
    var body: some View {
        HStack {
            Image(systemName: "mail")
                .foregroundColor(.gray)
            TextField("", text: $email, prompt: Text("Email").foregroundStyle(.gray))
                .foregroundColor(.white)
                .autocorrectionDisabled()
                .autocapitalization(.none)
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
