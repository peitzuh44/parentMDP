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
    @ObservedObject var kidVM: KidViewModel

    
    func name(for purchaseBy: String?) -> String? {
           guard let purchaseBy = purchaseBy else { return "any" } // Return "Unknown" or any placeholder if nil
           return kidVM.kids.first { $0.id == purchaseBy }?.name ?? "Unknown" // Again, handling nil names
       }
    
    
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack{
                // Approve all button
                if rewardVM.purchasedRewards.isEmpty {
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
                        ForEach(rewardVM.purchasedRewards){ reward in
                            HStack {
                                HStack(spacing: 4){
                                    Image("gift")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30)
                                    VStack(alignment: .leading, spacing: 4){
                                        Text(reward.name).foregroundColor(.white)
                                        Text(name(for: reward.purchasedBy)!)
                                    }
                                    .foregroundStyle(.white)
                                }
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
                            .padding()
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
