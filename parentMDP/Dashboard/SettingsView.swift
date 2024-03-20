//
//  SettingsView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {

    @Binding var authFlow: AuthFlow
    
    // MARK: Signout Function
    func signOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            withAnimation {
                authFlow = .notAuthenticated
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            ScrollView{
                VStack{
                    // Manage kid - Navigation Link
                    MenuNavigationLinkItem(text: "Manage Kid", image: "challenge") {
                        ManageKidView()
                    }
                    // Help - Navigation Link
                    MenuNavigationLinkItem(text: "Help", image: "challenge") {
                        ManageKidView()

                    }
                    // Logout - Button
                    MenuActionButton(text: "Logout", image: "challenge", textColor: .red) {
                        signOut()
                    }
                }

                
            }
            .padding()
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}



struct MenuNavigationLinkItem<Destination: View>: View {
    let text: String
    let image: String
    let destinationView: () -> Destination
    
    var body: some View {
        NavigationLink(destination: destinationView()) {
            HStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36)
                Text(text)
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}


struct MenuActionButton: View {
    let text: String
    let image: String
    let textColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action){
            HStack{
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36)
                Text(text)
                    .foregroundStyle(textColor)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

