//
//  EditRewardSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/15.
//

import SwiftUI

struct EditRewardSheet: View {
    @Environment(\.presentationMode) var presentationMode
    var selectedReward: RewardModel
    @ObservedObject var rewardVM: RewardViewModel
    @ObservedObject var kidVM: KidViewModel
    
    @State private var showRarityPicker = false
    @State private var showPricePicker = false

    @State private var name: String = ""
    @State private var selectedRarity: RarityOptions 
    @State private var selectedPrice: Int
    
    
    
    init(selectedReward: RewardModel, rewardVM: RewardViewModel, kidVM: KidViewModel) {
        self.selectedReward = selectedReward
        self.rewardVM = rewardVM
        self.kidVM = kidVM
        _name = State(initialValue: selectedReward.name)
        _selectedRarity = State(initialValue: RarityOptions(rawValue: selectedReward.rarity)!)
        _selectedPrice = State(initialValue: selectedReward.price)

    }


    var body: some View {
        ZStack {
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack{
                //Header
                HStack{
                    //cancel button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "xmark")
                    }
                    Spacer()
                    Text("Edit Reward")
                    Spacer()
                    
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.customNavyBlue)
                VStack(spacing: 12){
                    CustomTextfield(text: $name, placeholder: "new reward...", icon: "", background: Color.customNavyBlue, color: Color.white)
                    // rarity picker
                    Button(action: {
                        self.showRarityPicker = true
                    }) {
                        HStack {
                            Text("Rarity")
                            Spacer()
                            Text(selectedRarity.rawValue ?? "Select Rarity")

                        }
                        .frame(width: 330, height: 24)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.customNavyBlue)
                        .cornerRadius(10)
                    }
                    .sheet(isPresented: $showRarityPicker) {
                        // Present KidPicker here
                        RarityPicker(selectedRarity: $selectedRarity)
                            .presentationDetents([.height(500)])
                            .presentationDragIndicator(.hidden)
                    }
                    // price picker
                    Button(action: {
                        self.showPricePicker = true
                    }) {
                        HStack {
                            Text("Price")
                            Spacer()
                            Text("\(selectedPrice)")

                        }
                        .frame(width: 330, height: 24)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.customNavyBlue)
                        .cornerRadius(10)
                    }
                    .sheet(isPresented: $showPricePicker) {
                        PricePicker(selectedPrice: $selectedPrice)
                            .presentationDetents([.height(300)])
                            .presentationDragIndicator(.hidden)
                    }
                    
                    Spacer()
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                        var updatedReward = selectedReward
                        updatedReward.name = name
                        updatedReward.rarity = selectedRarity.rawValue
                        updatedReward.price = selectedPrice
                        rewardVM.updateReward(updatedReward: updatedReward)

                    }){
                        Text("Edit reward")
                    }
                    .frame(width: 330, height: 50)
                    .buttonStyle(ThreeD(backgroundColor: .customPurple, shadowColor: .black))
                    .foregroundColor(.white)
                }
                .padding(.vertical)
            }

        }
    }
}

