//
//  AddRewardView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/15.
//

import SwiftUI
import FirebaseAuth


struct AddRewardSheet: View {
    // MARK: Properties

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var rewardVM = RewardViewModel()
    let currentUserID = Auth.auth().currentUser?.uid ?? ""

    // picker
    @State private var showRarityPicker = false
    @State private var showPricePicker = false
    
    //selected values
    @State private var name: String = ""
    @State private var selectedRarity: RarityOptions = .common
    @State private var selectedCategory: RewardCategoryOption = .object

    @State private var selectedprice: Int = 0
    
 
    // MARK: Body
    var body: some View {
        ZStack {
            Color.customDarkBlue.ignoresSafeArea(.all)
            // MARK: Foreground
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
                    Text("New Reward")
                    Spacer()
                    
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.customNavyBlue)
                ScrollView{
                    VStack(spacing: 12){
                        CustomTextfield(text: $name, placeholder: "reward name...", icon: "gift", background: Color.customNavyBlue, color: Color.white)
                        // rarity picker
                        Button(action: {
                            self.showRarityPicker = true
                        }) {
                            HStack {
                                Text("Rarity")
                                Spacer()
                                Text(selectedRarity.rawValue)

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
                                .presentationDetents([.large])
                                .presentationDragIndicator(.hidden)
                        }
                        // price picker
                        Button(action: {
                            self.showPricePicker = true
                        }) {
                            HStack {
                                Text("Price")
                                Spacer()
                                Text(selectedprice != 0 ? "\(selectedprice)" : "Select Price")

                            }
                            .frame(width: 330, height: 24)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.customNavyBlue)
                            .cornerRadius(10)
                        }
                        .sheet(isPresented: $showPricePicker) {
                            PricePicker(selectedPrice: $selectedprice)
                                .presentationDetents([.height(300)])
                                .presentationDragIndicator(.hidden)
                        }
                        
                        Spacer()
                        Button(action:{
                            presentationMode.wrappedValue.dismiss()
                            rewardVM.createReward(name: name, category: selectedCategory.description, rarity: selectedRarity.rawValue, price: selectedprice, createdBy: currentUserID)

                        }){
                            Text("Create reward")
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
}

// MARK: Preview

#Preview {
    AddRewardSheet()
}
