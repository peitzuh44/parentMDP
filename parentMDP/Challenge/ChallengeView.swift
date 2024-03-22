//
//  CombinedChallengeView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/17.


import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct ChallengeView: View {
    // MARK: Properties
    
    // Initializing View Model
    @ObservedObject var challengeVM = ChallengeViewModel()
    @ObservedObject var kidVM = KidViewModel()
    @State private var selectedChallenge: ChallengeModel?

    //pickers for fetching data
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    let status: String = "ongoing"
    @State private var showKidSelector = false
    @State private var selectedKidID: String = ""
    

    // Customize Picker
    @State private var assignedOrSelfSelected: String = "assigned"
    @Namespace private var namespace
    private var animationSlideInFromLeading: Bool {
        assignedOrSelfSelected == "assigned"
    }
    
    //sheets
    @Environment(\.presentationMode) var presentationMode
    @State private var showActionSheet = false
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    @State private var showCompleteAlert = false
    @State private var showGiveUpAlert = false
    @State private var showReviewSheet = false
    @State private var showAddChallengeSheet = false

    // MARK: Functions
    func name(for selectedKidID: String?) -> String? {
        guard let selectedKidID = selectedKidID else { return nil }
        return kidVM.kids.first { $0.id == selectedKidID }?.name
    }
    
    // MARK: Fetching Configuration
    func fetchChallengesForChallengeView() {
        let config = FetchChallengesConfig(
            userID: currentUserID,
            status: status,
            selectedKidID: selectedKidID,
            criteria: [
                .createdBy(currentUserID),
                .status(status),
                .assignTo(selectedKidID),
                .assignedOrSelfSelected(assignedOrSelfSelected)
            ],
            sortOptions: [
                .dueDate(ascending: true)
            ],
            limit: nil // or specify a limit for cases like recent completions
        )
        challengeVM.fetchChallenges(withConfig: config)
    }

    
    // MARK: Body
    var body: some View {
        ZStack (alignment: .bottomTrailing){
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack {
                CustomSegmentedControl(segments: ["assigned", "self-selected"], selectedSegment: $assignedOrSelfSelected)
                
                // MARK: Kid Picker
                KidSelector(kidVM: kidVM, selectedKidID: $selectedKidID)
                    .padding(.vertical)

                
                // MARK: Return View By Case
                if assignedOrSelfSelected == "assigned" {
                    AssignedChallengeView(challengeVM: challengeVM, kidVM: kidVM, selectedChallenge: $selectedChallenge, showActionSheet: $showActionSheet)
                } else if assignedOrSelfSelected == "self-selected" {
                    SelfSelectedChallengeView(challengeVM: challengeVM, kidVM: kidVM, selectedChallenge: $selectedChallenge, showActionSheet: $showActionSheet)
                }
            }
            
            // MARK: Sheets
            .sheet(isPresented: Binding(
                get: { showActionSheet },
                set: { showActionSheet = $0 }
            )) {
                if let challengeDetail = selectedChallenge {
                    ChallengeActionSheet(showEditSheet: $showEditSheet, showDeleteAlert: $showDeleteAlert, showGiveupAlert: $showGiveUpAlert, showCompleteAlert: $showCompleteAlert, challengeVM: challengeVM, kidVM: kidVM, challenge: challengeDetail, showReviewSheet: $showReviewSheet)
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
            .sheet(isPresented: $showEditSheet, content: {
                EditChallengeSheet(selectedChallenge: selectedChallenge!, challengeVM: challengeVM, kidVM: kidVM)
            })
            .sheet(isPresented: $showReviewSheet, content: {
                ReviewChallengeView(selectedChallenge: selectedChallenge!)
                    .presentationDetents([.height(750)])
                    .presentationDragIndicator(.hidden)

            })
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Challenge"),
                    message: Text("Are you sure you want to delete this challenge?"),
                    primaryButton: .destructive(Text("Delete"), action: {
                        if let challengeID = selectedChallenge?.id {
                            challengeVM.deleteChallenge(challengeID: challengeID)
                        }
                    }),
                    secondaryButton: .cancel()
                )
            }
            
            // MARK: Fetching Conditions
            .onAppear {
                kidVM.fetchKids()
            }
            .onReceive(kidVM.$kids) { kids in
                if selectedKidID.isEmpty, let firstKid = kids.first {
                    selectedKidID = firstKid.id
                    fetchChallengesForChallengeView()
                }
            }
            .onChange(of: selectedKidID) { _ in                     fetchChallengesForChallengeView()
            }
            .onChange(of: assignedOrSelfSelected) { _ in                     fetchChallengesForChallengeView()
            }
            // MARK: Add Challenge Button
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

