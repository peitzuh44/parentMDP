//
//  SettingsView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            ScrollView{
                VStack{
                    // Manage kid - Navigation Link
                    MenuNavigationLinkItem(text: "Manage Kid", image: "challenge")
                    // Help - Navigation Link
                    MenuNavigationLinkItem(text: "Help", image: "challenge")
                    // Logout - Button
                    MenuActionButton(text: "Logout", image: "challenge", textColor: .red)
                }

                
            }
            .padding()
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    SettingsView()
}



struct MenuNavigationLinkItem: View {
    
    let text: String
    let image: String
    
    var body: some View{
        NavigationLink {
            // Logout action
        } label: {
            HStack{
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
    var body: some View {
        Button(action:{
            // signout function
        }){
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
