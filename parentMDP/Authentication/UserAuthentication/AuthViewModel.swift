//
//  AuthViewModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/13.
//  Edited by Eric Tran on 2024/3/7

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SwiftUI


func generateRandomParentCode(length: Int) -> String {
    let lettersAndNumbers = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map{ _ in lettersAndNumbers.randomElement()! })
}


struct AuthViewModel: View {
    @Binding var authFlow: AuthFlow
    @State private var currentViewShowing: String = "login"
    
    var body: some View {
        if(currentViewShowing == "login") {
            LoginView(currentShowingView: $currentViewShowing, authFlow: $authFlow)
        } else {
            SignupView(currentShowingView: $currentViewShowing, authFlow: $authFlow)
                .transition(.move(edge: .bottom))
        }
    }
}


struct AuthViewModel_Previews: PreviewProvider {
    static var previews: some View {
        AuthViewModel(authFlow: .constant(.notAuthenticated))
    }
}
