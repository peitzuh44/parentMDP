//
//  ContentView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI
import FirebaseAuth
import FirebaseAuth

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
        switch authFlow {
        case .notAuthenticated:
            AuthViewModel(authFlow: $authFlow)
        case .authenticated:
            MainView(authFlow: $authFlow)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
