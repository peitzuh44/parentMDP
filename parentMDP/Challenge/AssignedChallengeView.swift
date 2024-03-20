//
//  AssignedChallengeView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/16.
//

import SwiftUI

struct AssignedChallengeView: View {
    // MARK: Properties
    @ObservedObject var challengeVM: ChallengeViewModel
    @ObservedObject var kidVM: KidViewModel
    @Binding var selectedChallenge: ChallengeModel?
    @Binding var showActionSheet: Bool
    @State private var showEditTaskSheet = false
    @State private var showDeleteAlert = false
    // MARK: Functions
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
    // MARK: Body
    var body: some View {
        List {
            Section(header: Text("Assigned Challenge").foregroundColor(.white)) {
                ForEach(challengeVM.challenges) { challenge in
                    ChallengeItem(challenge: challenge)
                        .onTapGesture {
                            selectedChallenge = challenge
                            if selectedChallenge?.status == "ongoing" {
                                self.showActionSheet = true
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(challenge.status == "complete" ? Color.customGreen.opacity(0.5) : Color.customNavyBlue)
                                .padding(.vertical, 2)
                        )
                }
            }
        }
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
    }
}
// MARK: Challenge Item
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
        }
        .foregroundStyle(Color.white)
    }
}


