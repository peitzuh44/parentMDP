//
//  RedeemRewardView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI
import FirebaseAuth
struct RedeemRewardView: View{
    
    @ObservedObject var rewardVM: RewardViewModel
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack{
                // Approve all button
                if rewardVM.purchasedReward.isEmpty {
                    // Display message when no tasks are available
                    VStack {
                        Spacer()
                        Text("You have redeemed all the rewards!")
                            .foregroundColor(.white)
                            .font(.title2)
                        Spacer()
                    }
                }
                else{
                    List{
                        ForEach(rewardVM.purchasedReward){ reward in
                            HStack {
                                Text(reward.name).foregroundColor(.white)
                                Spacer()
                                Button(action: {
                                    rewardVM.markRewardAsRedeemed(purchasedReward: reward)
                                }) {
                                    Text("Redeem")
                                        .foregroundStyle(.white)
                                        .padding(8)
                                        .background(.blue)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                                .padding(.vertical, 8)
                                
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.customNavyBlue)
                                .padding(.vertical, 2)
                        )
                    }
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                }
            }
            .onAppear {
                rewardVM.fetchPurchaseRecord(forUserID: currentUserID)
            }
        }
        
    }
}
