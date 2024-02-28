//
//  CombinedChallengeView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/17.


import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct ChallengeView: View {
    @ObservedObject var challengeVM = ChallengeViewModel()
    @ObservedObject var kidVM = KidViewModel()
    @State private var selectedChallenge: ChallengeModel?
    @Environment(\.presentationMode) var presentationMode

    @State private var showAddChallengeSheet = false
    //pickers for fetching data
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    @State private var showKidSelector = false
    @State private var selectedKidID: String = ""
    @State private var assignedOrSelfSelected: String = "assigned"
    @Namespace private var namespace
    private var animationSlideInFromLeading: Bool {
        assignedOrSelfSelected == "assigned"
    }
    
    //sheets
    @State private var showActionSheet = false
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    @State private var showCompleteAlert = false
    @State private var showGiveUpAlert = false
    
    func name(for selectedKidID: String?) -> String? {
        guard let selectedKidID = selectedKidID else { return nil }
        return kidVM.kids.first { $0.id == selectedKidID }?.name
    }
    
    
    var body: some View {
        ZStack (alignment: .bottomTrailing){
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack {
                CustomSegmentedControl(segments: ["assigned", "self-selected"], selectedSegment: $assignedOrSelfSelected)
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                    showKidSelector = true
                }){
                    HStack{
                        Spacer()
                        // Name + Image
                        VStack(spacing: 8){
                            //avatar image
                            Image("avatar1")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60)
                                .padding(.horizontal, 8)
                            Text(self.name(for: selectedKidID) ?? "Select kid")
                                .font(.callout)
                        }
                        Spacer()
                        HStack(spacing: 24) {
                            // Ongoing Challenge
                            VStack(alignment: .center, spacing: 2) {
                                Text("7")
                                    .font(.title)
                                    .bold()
                                Text("ongoing")
                            }
                            // Completed Challenge
                            VStack(alignment: .center, spacing: 2) {
                                Text("7")
                                    .font(.title)
                                    .bold()
                                Text("completed")
                            }
                        }
                        
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 130)
                    .background(
                        Color.customNavyBlue
                            .cornerRadius(20)
                    )
                    .padding(.horizontal)
                    
                }
                    .padding()
                
                if assignedOrSelfSelected == "assigned" {
                    AssignedChallengeView(challengeVM: challengeVM, kidVM: kidVM, selectedChallenge: $selectedChallenge, showActionSheet: $showActionSheet)
                } else if assignedOrSelfSelected == "self-selected" {
                    SelfSelectedChallengeView(challengeVM: challengeVM, kidVM: kidVM, selectedChallenge: $selectedChallenge, showActionSheet: $showActionSheet)
                }
            }
            .sheet(isPresented: Binding(
                get: { showActionSheet },
                set: { showActionSheet = $0 }
            )) {
                if let challengeDetail = selectedChallenge {
                    ChallengeActionSheet(showEditSheet: $showEditSheet, showDeleteAlert: $showDeleteAlert, showGiveupAlert: $showGiveUpAlert, showCompleteAlert: $showCompleteAlert, challengeVM: challengeVM, kidVM: kidVM, challenge: challengeDetail)
                        .presentationDetents([.height(350)])
                        .presentationDragIndicator(.hidden)
                }
            }
            .sheet(isPresented: $showKidSelector) {
                ChallengeViewKidSelectorSheet(kidVM: kidVM, selectedKidID: $selectedKidID)
                    .presentationDetents([.height(250)])
                    .presentationDragIndicator(.hidden)
            }
            
            .sheet(isPresented: $showAddChallengeSheet) {
                AddChallengeSheet()
                    .presentationDetents([.height(750)])
                    .presentationDragIndicator(.hidden)
                
            }
            //fetching
            .onAppear {
                kidVM.fetchKids()
            }
            .onReceive(kidVM.$kids) { kids in
                if selectedKidID == "", let firstKid = kids.first {
                    selectedKidID = firstKid.id
                    challengeVM.fetchChallenges(forUserID: currentUserID, selectedKidID: selectedKidID, assignedOrSelfSelected: assignedOrSelfSelected)
                    
                }
            }
            .onChange(of: selectedKidID) {challengeVM.fetchChallenges(forUserID: currentUserID, selectedKidID: selectedKidID, assignedOrSelfSelected: assignedOrSelfSelected)}
            .onChange(of: assignedOrSelfSelected) {challengeVM.fetchChallenges(forUserID: currentUserID, selectedKidID: selectedKidID, assignedOrSelfSelected: assignedOrSelfSelected)}
            
            // Add Task Button
            Button(action:{
                showAddChallengeSheet.toggle()
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
            .padding()
        }
    }
}


