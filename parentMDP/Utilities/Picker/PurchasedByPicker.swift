//
//  PurchasedByPicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/17.
//

import SwiftUI

struct PurchasedByPicker: View {
    @ObservedObject var rewardVM: RewardViewModel
    var reward: RewardModel
    @ObservedObject var kidVM: KidViewModel
    @State var selectedKidID: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.customNavyBlue.ignoresSafeArea(.all)
            VStack (alignment: .leading, spacing: 16){
                Text("Purchased by...")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(kidVM.kids) {
                            kid in
                            Button(action: {
                                self.selectedKidID = kid.id
                                presentationMode.wrappedValue.dismiss()
                                rewardVM.purchaseRewardAndUpdateKidGold(reward: reward, purchasedBy: kid.id)

                            }) {
                                VStack(spacing: 10) {
                                    Image(kid.avatarImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80)
                                    Text(kid.name)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 130, height: 160)
                                .background(selectedKidID == kid.id ? Color.customGreen : Color.black.opacity(0.6))
                                .cornerRadius(10)                        }
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
            .onAppear{
                kidVM.fetchKids()
            }


        }
    }
}


