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
    @State var selectedKidID: String? = ""
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
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
                taskVM.fetchReviewTask(forUserID: currentUserID)
            }
        }
        
    }
}
