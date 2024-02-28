//
//  parentMDPApp.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct parentMDPApp: App {
    init() {
        FirebaseApp.configure()
       }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
