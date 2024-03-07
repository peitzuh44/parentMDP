//
//  InviteKidView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI

struct InviteKidView: View {
    @Binding var authFlow: AuthFlow

    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack{
                Text("Invite your kids")
                    .foregroundStyle(Color.white)
                    .font(.largeTitle)
                Spacer()
                HStack{
                    Text("NK8M3n4")
                        .foregroundStyle(Color.white)
                        .padding(.vertical)
                    Button(action:{
                        
                    }){
                        Image(systemName: "doc.on.doc")
                            .foregroundStyle(Color.white)
                    }
                }
                .padding()
                .frame(width: 200, height: 40)
                .background(Color.customNavyBlue)
                .cornerRadius(10)
                Spacer()
                Button(action:{
                    authFlow = .authenticated
                }){
                    Text("Done")
                }
                .frame(width: 330, height: 50)
                .buttonStyle(ThreeD(backgroundColor: .customPurple, shadowColor: .black))
                .foregroundColor(.white)
            }
        }
    }
}
