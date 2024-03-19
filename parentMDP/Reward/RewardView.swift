//
//  RewardView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/13.
//
//
import SwiftUI
import FirebaseAuth

struct RewardView: View {
    // MARK: Properties

    @ObservedObject var rewardVM = RewardViewModel() // reward VM
    @ObservedObject var kidVM = KidViewModel()
    @State private var selectedReward: RewardModel? // rewardModel

    //sheets
    @State private var showAddSheet = false
    @State private var showActionSheet = false
    @State private var showEditSheet = false
    @State private var showPurchasedByPicker = false
    @State private var showDeleteAlert = false

    // MARK: Body

    var body: some View {
        ZStack(alignment: .bottomTrailing){
            Color.customDarkBlue.ignoresSafeArea(.all)
            // MARK: Foreground
                List{
                    ForEach(rewardVM.rewards) { reward in
                        RewardListItem(reward: reward)
                            .onTapGesture {
                                self.selectedReward = reward
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
            
                // MARK: Fetching Factors
                .onAppear{
                    rewardVM.fetchRewards()
                }
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
        
            // MARK: Add Reward Button
            Button(action:{
                showAddSheet.toggle()
            }){
                ZStack(){
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.customPurple)
                    Image(systemName: "plus")
                .foregroundColor(.white)
                        .font(.title)
                    
                }
            }
            // MARK: Sheets and Alerts
            .sheet(isPresented: $showAddSheet) {
                AddRewardSheet()
                    .presentationDetents([.height(750)])
                    .presentationDragIndicator(.hidden)
            }
            //reward action sheet
            .sheet(isPresented: Binding(
                            get: { showActionSheet },
                            set: { showActionSheet = $0 }
            )) {
                if let rewardDetail = selectedReward {
                    RewardActionSheet(rewardVM: rewardVM, kidVM: kidVM, reward: rewardDetail, showEditSheet: $showEditSheet, showDeleteAlert: $showDeleteAlert, showPurchaseByPicker: $showPurchasedByPicker)
                    .presentationDetents([.height(350)])
                    .presentationDragIndicator(.hidden)
                    
                }
                
            }
            // Purchased by picker
            .sheet(isPresented: $showPurchasedByPicker) {
                PurchasedByPicker(rewardVM: rewardVM, kidVM: kidVM, reward: selectedReward!)
                    .presentationDetents([.height(250)])
                    .presentationDragIndicator(.hidden)
            }
            // EDIT - edit reward (NEEDED)
            .sheet(isPresented: $showEditSheet) {
                if let reward = $selectedReward.wrappedValue {
                    EditRewardSheet(selectedReward: reward, rewardVM: rewardVM, kidVM: kidVM)
                        .presentationDetents([.height(800)])
                        .presentationDragIndicator(.hidden)
                }
            }
            // DELETE 
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Quest"),
                    message: Text("Are you sure you want to delete this quest?"),
                    primaryButton: .destructive(Text("Delete"), action: {
                        if let rewardID = selectedReward?.id  {
                            rewardVM.deleteReward(rewardID: rewardID)
                        }
                    }),
                    secondaryButton: .cancel()
                )
            }
            .padding()
        }
    
    }
}


// MARK: Reward List Item
struct RewardListItem : View {
    let reward: RewardModel

    var body: some View {
        HStack(alignment: .center) {
            Text(reward.name)
            Spacer()
            //price
            HStack(spacing: 4) {
                Image("gem")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                Text("\(reward.price)")
            }
        }
        .foregroundColor(.white)
        .padding(.vertical, 8)
    }
}
