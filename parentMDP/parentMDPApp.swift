//
//  parentMDPApp.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//  Edited by Eric Tran on 2024/3/7
//
//  SUMMARY: This is the entry point for the app, includes an init function that configures the firebase

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
