//
//  PublicTaskView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI

struct PublicTaskView: View {
    // MARK: Properties
    @ObservedObject var kidVM: KidViewModel
    @ObservedObject var taskVM: TaskViewModel
    @Binding var selectedTask: TaskInstancesModel?
    @Binding var showActionSheet: Bool
    @State private var showEditTaskSheet = false
    @State private var showDeleteTaskAlert = false
    @State private var showCompletePicker = false
    // MARK: Body
    var body: some View {
        VStack{
            List{
                Section(header: Text("For every player").foregroundColor(.white)) {
                    ForEach(taskVM.tasks) { task in
                                HStack(alignment: .center) {
                                    Text(task.name)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Button(action: {}) {
                                        Image("whiteCheck")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                    }
                                    .foregroundStyle(.green)
                                    .frame(width: 30, height: 30)
                                    .buttonStyle(ThreeD(backgroundColor: .green, shadowColor: .black))
                                }
                                .padding(.vertical, 8)
                                .onTapGesture {
                                    selectedTask = task
                                    if selectedTask?.status == "todo" {
                                        showActionSheet = true
                                    }
                                }

                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.customNavyBlue)
                            .padding(.vertical, 2)
                    )
                }
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
        }
    }
}
