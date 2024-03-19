//
//  ChallengeActionSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/15.
//

import SwiftUI

struct ChallengeActionSheet: View {
    // MARK: Properties
    @Environment(\.presentationMode) var presentationMode
    @Binding var showEditSheet: Bool
    @Binding var showDeleteAlert: Bool
    @Binding var showGiveupAlert: Bool
    @Binding var showCompleteAlert: Bool

    @ObservedObject var challengeVM: ChallengeViewModel
    @ObservedObject var kidVM: KidViewModel
    @State var challenge: ChallengeModel
    
    // MARK: Body
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack(spacing: 16){
                
                // MARK: Challenge Info
                HStack{
                    HStack{
                        Image("attack")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .padding()
                        Text(challenge.name)
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    Spacer()
                    Text(challenge.difficulty)
                        .foregroundColor(.white)
                        .padding(8)
                        .padding(.horizontal, 10)
                        .background(difficultyColor(for: challenge.difficulty).opacity(0.6))
                        .cornerRadius(50)
                }
                .padding()
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(Color.customNavyBlue)
                .cornerRadius(20)
                .padding(.horizontal)
                
                
                // MARK: Action Sheet Buttons
                HStack(spacing: 12){
                    Button(action:{
                    presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.showEditSheet = true
                        }

                    }){
                        VStack(spacing: 16){
                            Image("edit")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .padding(16)
                                .background(Color.customNavyBlue)
                                    .cornerRadius(20)
                            Text("edit")
                                .foregroundColor(.white)
                        }
                    }
                    Button(action:{
                    presentationMode.wrappedValue.dismiss()
                        challengeVM.completeChallengeAndUpdateKidGem(challenge: challenge)
                    }){
                        VStack(spacing: 16){
                            Image("check")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .padding(16)
                                .background(Color.customPurple)
                                    .cornerRadius(20)
                            Text("complete")
                                .foregroundColor(.white)
                        }
                    }
                    Button(action:{
                    presentationMode.wrappedValue.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showGiveupAlert = true

                        }
                    }){
                        VStack(spacing: 16){
                            Image("dead")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .padding(16)
                                .background(Color.red)
                                    .cornerRadius(20)
                            Text("give up")
                                .foregroundColor(.white)
                        }
                    }
                    Button(action:{
                    presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showDeleteAlert = true
                        }
                    }){
                        VStack(spacing: 16){
                            Image("trash")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .padding(16)
                                .background(Color.customNavyBlue)
                                    .cornerRadius(20)
                            Text("delete")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }

    }
}
