//
//  ContentView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//  Edited by Eric Tran on 2024/3/7
//
//  SUMMARY: This is the main view of the app where we decide on whether or not to send our user to the login view or the main view

import SwiftUI
import FirebaseAuth
import Foundation


enum AuthFlow {
    case authenticated
    case notAuthenticated
}

struct ContentView: View {
    @State var authFlow: AuthFlow = .notAuthenticated
    init() {
        if Auth.auth().currentUser != nil {
            authFlow = .authenticated
        }
    }

    var body: some View {
        
        // If user is not authenticated yet, send them to the AuthViewModel else send them to the MainView
        switch authFlow {
        case .notAuthenticated:
            AuthViewModel(authFlow: $authFlow)
        case .authenticated:
            MainView(authFlow: $authFlow)
        }
    }
}



// MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView()
        }
    }
}
