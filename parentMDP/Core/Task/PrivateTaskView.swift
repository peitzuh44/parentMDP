//
//  PrivateTaskView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import Foundation
import SwiftUI

struct PrivateTaskView: View {
    // MARK: Properties
    @ObservedObject var taskVM: TaskViewModel
    @ObservedObject var kidVM: KidViewModel
    @Binding var selectedTask: TaskInstancesModel?
    @Binding var showActionSheet: Bool
    @State private var showEditTaskSheet = false
    @State private var showDeleteAlert = false
    @State var selectedKidID: String? = ""

    // MARK: Body
    var body: some View {
        VStack {
            if taskVM.tasks.count == 0 {
                Spacer()
                Text("no tasks added yet")
                    .foregroundStyle(Color.white)
                Spacer()
            } else {
                List {
                    // MARK: Morning Section
                    Section(header: Text("Morning").foregroundColor(.white)) {
                            ForEach(taskVM.tasks(forRoutine: "morning", withStatus: "todo")) { task in
                                HStack {
                                    Text(task.name).foregroundColor(.white)
                                    Spacer()
                                    if task.status == "todo" {
                                        Button(action: {
                                            taskVM.completeTaskAndUpdateKidCoin(task: task, completedBy: selectedKidID)
                                        }) {
                                            Image(systemName: "checkmark")
                                                .font(.title3)
                                                .bold()
                                                .foregroundStyle(.white)
                                        }
                                        .foregroundStyle(.green)
                                        .frame(width: 30, height: 30)
                                        .buttonStyle(ThreeD(backgroundColor: .green, shadowColor: .black))
                                    } else {
                                        Image(systemName: "checkmark.square.fill")
                                            .bold()
                                            .font(.title3)
                                            .foregroundStyle(.white)
                                            .frame(width: 30, height: 30)
                                    }
                                }
                                .padding(.vertical, 8)
                                .onTapGesture {
                                    selectedTask = task
                                    if selectedTask?.status == "todo" {
                                        showActionSheet = true
                                        print("action sheet appears")
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(task.status == "complete" ? Color.customGreen.opacity(0.5) : Color.customNavyBlue)
                                        .padding(.vertical, 2)
                                )
                            }

                        }
                    // MARK: Evening Section
                    Section(header: Text("Evening").foregroundColor(.white)) {
                        ForEach(taskVM.tasks(forRoutine: "evening", withStatus: "todo")) { task in
                            HStack {
                                Text(task.name).foregroundColor(.white)
                                Spacer()
                                if task.status == "todo" {
                                    Button(action: {
                                        taskVM.completeTaskAndUpdateKidCoin(task: task, completedBy: selectedKidID)
                                    }) {
                                        Image(systemName: "checkmark")
                                            .font(.title3)
                                            .bold()
                                            .foregroundStyle(.white)
                                    }
                                    .foregroundStyle(.green)
                                    .frame(width: 30, height: 30)
                                    .buttonStyle(ThreeD(backgroundColor: .green, shadowColor: .black))
                                }
                            }
                            .padding(.vertical, 8)
                            .onTapGesture {
                                selectedTask = task
                                if selectedTask?.status == "todo" {
                                    showActionSheet = true
                                    print("action sheet appears")
                                }
                            
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(task.status == "complete" ? Color.customGreen.opacity(0.5) : Color.customNavyBlue)
                                    .padding(.vertical, 2)
                            )
        
                        }

                    }
                    // MARK: Anytime Section
                    Section(header: Text("Anytime").foregroundColor(.white)) {
                        ForEach(taskVM.tasks(forRoutine: "anytime", withStatus: "todo")) { task in
                            HStack {
                                Text(task.name).foregroundColor(.white)
                                Spacer()
                                if task.status == "todo" {
                                    Button(action: {
                                        taskVM.completeTaskAndUpdateKidCoin(task: task, completedBy: selectedKidID)
                                    }) {
                                        Image(systemName: "checkmark")
                                            .font(.title3)
                                            .bold()
                                            .foregroundStyle(.white)
                                    }
                                    .foregroundStyle(.green)
                                    .frame(width: 30, height: 30)
                                    .buttonStyle(ThreeD(backgroundColor: .green, shadowColor: .black))
                                } else {
                                    Image(systemName: "checkmark.square.fill")
                                        .bold()
                                        .font(.title3)
                                        .foregroundStyle(.white)
                                        .frame(width: 30, height: 30)
                                }
                            }
                            .padding(.vertical, 8)
                            .onTapGesture {
                                selectedTask = task
                                if selectedTask?.status == "todo" {
                                    showActionSheet = true
                                    print("action sheet appears")
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(task.status == "complete" ? Color.customGreen.opacity(0.5) : Color.customNavyBlue)
                                    .padding(.vertical, 2)
                            )
                        }
                    }
                    
                    // MARK: Complete Section
                    Section(header: Text("Completed").foregroundColor(.white)) {
                        ForEach(taskVM.tasks(forStatus: "complete")) { task in
                            HStack {
                                Text(task.name).foregroundColor(.white)
                                Spacer()
                                if task.status == "todo" {
                                    Button(action: {
                                        taskVM.completeTaskAndUpdateKidCoin(task: task, completedBy: selectedKidID)
                                    }) {
                                        Image(systemName: "checkmark")
                                            .font(.title3)
                                            .bold()
                                            .foregroundStyle(.white)
                                    }
                                    .foregroundStyle(.green)
                                    .frame(width: 30, height: 30)
                                    .buttonStyle(ThreeD(backgroundColor: .green, shadowColor: .black))
                                } else {
                                    Image(systemName: "checkmark.square.fill")
                                        .bold()
                                        .font(.title3)
                                        .foregroundStyle(.white)
                                        .frame(width: 30, height: 30)
                                }
                            }
                            .padding(.vertical, 8)
                            .onTapGesture {
                                selectedTask = task
                                if selectedTask?.status == "todo" {
                                    showActionSheet = true
                                    print("action sheet appears")
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(task.status == "complete" ? Color.customGreen.opacity(0.5) : Color.customNavyBlue)
                                    .padding(.vertical, 2)
                            )
                        }
                    }
                   


                }
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
            }
        }

    }
}

