//
//  RewardActionSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/17.
//

import SwiftUI

struct RewardActionSheet: View {
    // MARK: Properties

    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var rewardVM: RewardViewModel
    @ObservedObject var kidVM: KidViewModel
    @State var reward: RewardModel
    @Binding var showEditSheet: Bool
    @Binding var showDeleteAlert: Bool
    @Binding var showPurchaseByPicker: Bool

    
    // MARK: Functions
    func rarityColor(for rarity: String) -> Color {
           switch rarity {
           case "common":
               return Color.gray.opacity(0.6)
           case "rare":
               return Color.blue.opacity(0.6)
           case "epic":
               return Color.green.opacity(0.6)
           case "legendary":
               return Color.orange.opacity(0.6)
           case "mythic":
               return Color.purple.opacity(0.6)
           default:
               return Color.gray.opacity(0.6)
           }
       }
    
    // MARK: Body
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            // MARK: Reward Detail
            VStack(spacing: 16){
                HStack{
                    HStack{
                        Image("gift")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .padding()
                        Text(reward.name)
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    Spacer()
                    Text(reward.rarity)
                        .foregroundColor(.white)
                        .padding(8)
                        .padding(.horizontal, 10)
                        .background(rarityColor(for: reward.rarity))
                        .cornerRadius(50)
                }
                .padding()
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(Color.customNavyBlue)
                .cornerRadius(20)
                .padding(.horizontal)
                
                // MARK: Action Sheet Buttons
                HStack(spacing: 24){
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
                                .frame(width: 50, height: 50)
                                .padding(24)
                                .background(Color.customNavyBlue)
                                    .cornerRadius(20)
                            Text("edit")
                                .foregroundColor(.white)
                        }
                    }
                    Button(action:{
                    presentationMode.wrappedValue.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showPurchaseByPicker = true
                        }
                    }){
                        VStack(spacing: 16){
                            Image("purchase")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .padding(24)
                                .background(Color.customPurple)
                                    .cornerRadius(20)
                            Text("purchase")
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
                                .frame(width: 50, height: 50)
                                .padding(24)
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

