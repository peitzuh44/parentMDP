//
//  PastChallengeView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/21.
//

import SwiftUI
import FirebaseAuth

struct PastChallengeView: View {
    @ObservedObject var challengeVM: ChallengeViewModel
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    var kid: KidModel

    
    func fetchPastChallenges() {
        let config = FetchChallengesConfig(
            userID: currentUserID,
            status: "complete",
            selectedKidID: kid.id,
            criteria: [
                .assignTo(kid.id),
                .createdBy(currentUserID),
                .status("complete")
            ],
            sortOptions: [
                .dateCompleted(ascending: false)
            ], 
            limit: nil
        )
        
        challengeVM.fetchChallenges(withConfig: config)
    }
    
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            if challengeVM.challenges.isEmpty {
                VStack{
                    Spacer()
                    VStack{
                        Image("sad")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64)
                        Text("No challenge completed")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    Spacer()
                }
                
            } else {
                ScrollView{
                    VStack{
                        ForEach(challengeVM.challenges){challenge in
                            CompleteChallengeListItem(challenge: challenge)
                        }
                        
                    }
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                }
                .padding()
                .onAppear{
                    fetchPastChallenges()
                }
            }
        }
    }
}


