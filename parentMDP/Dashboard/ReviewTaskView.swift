//
//  ReviewTaskView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI
import FirebaseAuth


struct ReviewTaskView: View {
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
    
    func fetchTasksForTaskView() {
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
        taskVM.fetchTasks(withConfig: config)
    }
    
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack(spacing: 20){
                //header - private/public task picker and date picker
                CustomSegmentedControl(segments: ["private", "public"], selectedSegment: $privateOrPublic)                
                // MARK: Return View By Case
                if privateOrPublic == "private" {
                    KidSelector(kidVM: kidVM, selectedKidID: $selectedKidID)
                }
            }
            .padding(.horizontal)
            VStack{
                // Approve all button
                if taskVM.tasks(forStatus: "reviewing").isEmpty {
                    // Display message when no tasks are available
                    VStack {
                        Spacer()
                        Text("You've reviewed all tasks!")
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
            .onAppear {
                kidVM.fetchKids()
            }
            .onReceive(kidVM.$kids) { kids in
                if selectedKidID.isEmpty, let firstKid = kids.first {
                    selectedKidID = firstKid.id
                    fetchTasksForTaskView()
                }
            }
            .onChange(of: selectedKidID) { _ in
                fetchTasksForTaskView()
            }
            .onChange(of: privateOrPublic) { _ in
                fetchTasksForTaskView()
            }

        }
        
    }
}
