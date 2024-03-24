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
    @Binding var showCompleteByPicker: Bool
    // MARK: Body
    var body: some View {
        VStack{
            List{
                Section(header: Text("For every player").foregroundColor(.white)) {
                    ForEach(taskVM.tasks(forStatus: "todo")) { task in
                                HStack(alignment: .center) {
                                    Text(task.name)
                                        .foregroundColor(.white)
                                    Spacer()
                                    if task.status == "todo"{
                                        Button(action: {
                                            selectedTask = task
                                            if selectedTask?.status == "todo" {
                                                showCompleteByPicker = true
                                            }
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
                                    else{
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
                Section(header: Text("Completed").foregroundColor(.white)) {
                    ForEach(taskVM.tasks(forStatus: "complete")) { task in
                                HStack(alignment: .center) {
                                    Text(task.name)
                                        .foregroundColor(.white)
                                    Spacer()
                                    if task.status == "todo"{
                                        Button(action: {
                                            selectedTask = task
                                            if selectedTask?.status == "todo" {
                                                showCompleteByPicker = true
                                            }
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
                                    else{
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



// MARK: Public Quest Leaderbaord

struct PublicTaskLeaderboard: View {
    @ObservedObject var kidVM: KidViewModel
    @ObservedObject var taskVM: TaskViewModel
    var sortedKids: [KidModel] {
         // Here, you sort the kids based on the completed task count for the current week
         kidVM.kids.sorted {
             taskVM.completedTasksCountByKid[$0.id, default: 0] > taskVM.completedTasksCountByKid[$1.id, default: 0]
         }
     }
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(sortedKids, id: \.id)
                { kid in
                    PublicTaskLeaderboardItem(name: kid.name, image: kid.avatarImage, completedTasks: taskVM.completedTasksCountByKid[kid.id] ?? 0)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .onAppear{
            kidVM.fetchKids()
            taskVM.fetchCompletedPublicTasksForCurrentWeek()

            
        }

    }
}

struct PublicTaskLeaderboardItem: View {
    let name: String
    let image: String
    let completedTasks: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70)
            VStack{
                Text(name)
                    .bold()
                Text("\(completedTasks) tasks")

            }
        }
        .foregroundColor(.white)
        .frame(width: 130, height: 160)
        .background(Color.customNavyBlue)
        .cornerRadius(10)
    }
}
