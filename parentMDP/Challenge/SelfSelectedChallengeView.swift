//
//  SelfSelectedChallengeView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/16.
//

import SwiftUI

struct SelfSelectedChallengeView: View {
    // MARK: Properties
    @ObservedObject var challengeVM: ChallengeViewModel
    @ObservedObject var kidVM: KidViewModel
    @Binding var selectedChallenge: ChallengeModel?
    @Binding var showActionSheet: Bool
    @State private var showEditTaskSheet = false
    @State private var showDeleteTaskAlert = false
    
    
    // MARK: Body
    var body: some View {
        List {
            Section (header: Text("self-selected").foregroundColor(.white)){
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

