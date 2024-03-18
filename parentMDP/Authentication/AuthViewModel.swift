//
//  AuthViewModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/13.
//  Edited by Eric Tran on 2024/3/7
//
//  SUMMARY: This is the root of the authentication portion of the app, here we have two possible views where the user can either log in or sign up. If they log in, they are sent to the main view, and if they sign up, they will be sent to the add kid view

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SwiftUI

struct AuthViewModel: View {
    // MARK: Properties

    @Binding var authFlow: AuthFlow
    @State private var currentViewShowing: String = "login"
    
    // MARK: Body
    var body: some View {
        if(currentViewShowing == "login") {
            LoginView(currentShowingView: $currentViewShowing, authFlow: $authFlow)
        } else {
            SignupView(currentShowingView: $currentViewShowing, authFlow: $authFlow)
                .transition(.move(edge: .top))
        }
    }
}


// MARK: Preview
struct AuthViewModel_Previews: PreviewProvider {
    static var previews: some View {
        AuthViewModel(authFlow: .constant(.notAuthenticated))
    }
}
