//
//  ReviewTaskView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI
import FirebaseAuth


struct ReviewTaskView: View {
    // MARK: Properties
    
    // ViewModel
    @ObservedObject var taskVM: TaskViewModel
    @ObservedObject var kidVM: KidViewModel
    
    //customize selector
    @State private var privateOrPublic: String = "private"
    @Namespace private var namespace
    private var animationSlideInFromLeading: Bool {
        privateOrPublic == "private"
    }
    
    // Fetching conditions
    @State private var selectedKidID: String = ""
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    let status: String = "reviewing"
    
    func name(for selectedKidID: String?) -> String? {
        guard let selectedKidID = selectedKidID else { return nil }
        return kidVM.kids.first { $0.id == selectedKidID }?.name
    }
    // MARK: Fetching task and count function
    
    func fetchReviewTask() {
        let config = FetchTaskConfig(
            userID: currentUserID, 
            status: status,
            selectedKidID: selectedKidID,
            criteria: [
                .createdBy(currentUserID),
                .assignTo(selectedKidID),
                .privateOrPublic(privateOrPublic),

            ],
            sortOptions: [
                .dueDate(ascending: false)
            ]
        )
        taskVM.fetchTasks(withConfig: config, privateOrPublic: privateOrPublic)
    }
    
    // MARK: Body
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            
            VStack{
                if taskVM.totalReviewTasksCount == 0 {
                    Spacer()
                    Text("No task require review!")
                        .foregroundStyle(.white)
                    Spacer()
                }
                else {
                    VStack{
                        CustomSegmentedControl(segments: ["private", "public"], selectedSegment: $privateOrPublic)
                        if privateOrPublic == "private" {
                            if taskVM.privateReviewTasksCount == 0 {
                                Spacer()
                                Text("No private task require review!")
                                    .foregroundStyle(.white)
                                Spacer()
                            } else {
                                KidSelector(kidVM: kidVM, selectedKidID: $selectedKidID)
                                VStack{
                                    if taskVM.tasks(forStatus: "reviewing").isEmpty {
                                        VStack {
                                            Spacer()
                                            //NOTE: Should return the name of the selectedKid
                                            Text("You've reviewed all tasks for \(name(for: selectedKidID) ?? "")!")
                                                .foregroundColor(.white)
                                                .font(.title2)
                                            Spacer()
                                        }
                                    }
                                    else{
                                        List{
                                            ForEach(taskVM.tasks(forStatus: "reviewing")){ task in
                                                HStack {
                                                    Text(task.name).foregroundColor(.white)
                                                    Spacer()
                                                    Button(action: {
                                                        taskVM.completeTaskAndUpdateKidCoin(task: task, completedBy: selectedKidID)
                                                    }) {
                                                        Text("Approve")
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
                            }
                        } else {
                                VStack{
                                    if taskVM.tasks(forStatus: "reviewing").isEmpty {
                                        VStack {
                                            Spacer()
                                            //NOTE: Should return the name of the selectedKid
                                            Text("You've reviewed all public quest!")
                                                .foregroundColor(.white)
                                                .font(.title2)
                                            Spacer()
                                        }
                                    }
                                    else{
                                        List{
                                            ForEach(taskVM.tasks(forStatus: "reviewing")){ task in
                                                HStack {
                                                    Text(task.name).foregroundColor(.white)
                                                    Spacer()
                                                    Button(action: {
                                                        taskVM.completeTaskAndUpdateKidCoin(task: task, completedBy: selectedKidID)
                                                    }) {
                                                        Text("Approve")
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
                            }
                    }
                }
            }
            // MARK: Fetching
            .onAppear {
                kidVM.fetchKids()
            }
            .onReceive(kidVM.$kids) { kids in
                if selectedKidID.isEmpty, let firstKid = kids.first {
                    selectedKidID = firstKid.id
                    fetchReviewTask()
                }
            }
            .onChange(of: selectedKidID) { _ in
                fetchReviewTask()
            }
            .onChange(of: privateOrPublic) { _ in
                fetchReviewTask()
            }
            .onAppear {
                 taskVM.updateReviewTasksCounts(userID: currentUserID, kids: kidVM.kids)
             }


        }
        
    }
}
