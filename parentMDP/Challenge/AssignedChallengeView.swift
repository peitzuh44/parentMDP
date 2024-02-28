//
//  AssignedChallengeView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/16.
//

import SwiftUI

struct AssignedChallengeView: View {
    @ObservedObject var challengeVM: ChallengeViewModel
    @ObservedObject var kidVM: KidViewModel
    @Binding var selectedChallenge: ChallengeModel?
    @Binding var showActionSheet: Bool
    @State private var showEditTaskSheet = false
    @State private var showDeleteAlert = false
    
    func difficultyColor(for difficulty: String) -> Color {
           switch difficulty {
           case "Easy":
               return Color.green.opacity(0.6)
           case "Medium":
               return Color.yellow.opacity(0.6)
           case "Hard":
               return Color.red.opacity(0.6)
           default:
               return Color.gray.opacity(0.6)
           }
       }
    
    var body: some View {
        List {
            Section {
                ForEach(challengeVM.challenges) { challenge in
                    ChallengeItem(challenge: challenge)
                        .onTapGesture {
                            self.selectedChallenge = challenge
                            self.showActionSheet = true
                        }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.customNavyBlue)
                        .padding(.vertical, 2)
                )
            }
        }
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
    }
}



struct ChallengeItem: View {
    let challenge: ChallengeModel

    
    var body: some View {
        HStack {
            HStack(spacing: 4){
                Image("attack")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                    .padding(.vertical)
                Text(challenge.name)
                
            }
            Spacer()
            // Difficulty tag
            HStack(spacing:4){
                Image(challenge.difficulty)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24)
                Text(challenge.difficulty)
                    .foregroundColor(.white)
                
            }
            .padding(8)
            .padding(.horizontal, 10)
                .background(difficultyColor(for: challenge.difficulty).opacity(0.6))
                .cornerRadius(50)
        }

        .foregroundStyle(Color.white)
    }
}


////Reward
//VStack(alignment: .leading, spacing: 4){
//    // Gem Tag
//    HStack(spacing: 4){
//        Image("gem")
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .frame(width: 24)
//        Text("300")
//        
//    }
//    HStack(spacing: 4){
//        Image("xp")
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .frame(width: 24)
//        Text("300")
//    }
//}
