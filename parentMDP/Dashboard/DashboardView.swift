//
//  DashboardView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct DashboardView: View {
    
    //MARK: Properties
    @ObservedObject var challengeVM = ChallengeViewModel()

    @ObservedObject var kidVM = KidViewModel()
    @ObservedObject var taskVM = TaskViewModel()
    @ObservedObject var rewardVM = RewardViewModel()
    @State private var selectedKid: KidModel?
    @State private var showKidDetail = false
    @Binding var authFlow: AuthFlow
    // Fetching Conditions
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    let status: String = "reviewing"
 
    // MARK: Body
    var body: some View {
        NavigationStack{
            ZStack{
                Color.customDarkBlue.ignoresSafeArea(.all)
                List{
                    // MARK: Kid Section
                    Section{
                        ForEach(kidVM.kids) { kid in
                            NavigationLink(value: kid) {
                                KidListItem(kid: kid)
                            }
                        }
                    } header:{
                        Text("My Kids")
                            .foregroundColor(.white)
                            .bold()
                    }
                    // kid list styling
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.customNavyBlue)
                            .padding(.vertical, 4)
                    )
                    // MARK: Action Buttons Section
                    Section{
                        //review task navigation link
                        NavigationLink {
                            ReviewTaskView(taskVM: taskVM, kidVM: kidVM)
                        } label: {
                            HStack{
                                Image(systemName: "checkmark.square.fill")
                                Text("\(taskVM.totalReviewTasksCount) tasks to review") // MARK: Pass in the calculation
                                Spacer()
                            }
                            .foregroundColor(.white)
                        }
                        .padding(.vertical)                        
                        //review gift navigation link
                        NavigationLink {
                            RedeemRewardView(rewardVM: rewardVM, kidVM: kidVM)
                        } label: {
                            HStack{
                                Image(systemName: "gift")
                                Text("\(rewardVM.rewardNeedRedeemCount) rewards redeemed") // MARK: Pass in the calculation
                                Spacer()
                            }
                            .foregroundColor(.white)
                        }
                        .padding(.vertical)
                    }
                    
                    // Action Button Section Styling
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.customNavyBlue)
                            .padding(.vertical, 4))
                    
                }
                .scrollContentBackground(.hidden)
                // MARK: Fetching
                .onAppear {
                    taskVM.updateReviewTasksCounts(userID: currentUserID, kids: kidVM.kids)
                 }
                .onAppear {
                    kidVM.fetchKids()
                }
                .onAppear {
                     rewardVM.updateRewardCount(userID: currentUserID)
                 }
                // MARK: Navigation Destinations
                .navigationDestination(for: KidModel.self) { kid in
                    KidProfileView(challengeVM: challengeVM, kidVM: kidVM, kid: kid)
                }
                
            }
            .navigationTitle("Dashboard")
                .foregroundStyle(.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        SettingsView(authFlow: $authFlow)
                    } label: {
                        Image(systemName: "line.3.horizontal")

                    }

                }
                
                ToolbarItem(placement: .principal) {
                    Text("Dashboard")
                        .foregroundStyle(.white)
                        .bold()
                }
//                ToolbarItem(placement: .principal) {
//                    HStack(spacing: 24){
//                        // login streak
//                    }
//                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    NavigationLink {
//                        MessageView()
//                    } label: {
//                        Image("mail")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 32)
//                    }
//
//                }
            }
            .foregroundStyle(Color.white)
            .toolbarColorScheme(.dark, for: .navigationBar)
            

        }
    }
}
  

// MARK: Kid List Item
struct KidListItem: View {
    var kid: KidModel
    var body: some View {
        HStack(spacing: 16){
            //Avatar Gif
            Image(kid.avatarImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70)
            VStack(alignment: .leading, spacing: 4){
                Text(kid.name)
                    .font(.title2)
                    .bold()
            }
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.vertical, 8)
        
        
        
    }
}

// MARK: TODOs
/*
 1. func calculating # of quest needed review
 2. func calculating # of gift needed to redeem
 3. display the skills of thre kids
 */
