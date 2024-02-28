//
//  TaskView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
////
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct TaskView: View {
    //examples
    @ObservedObject var taskVM = TaskViewModel()
    @ObservedObject var kidVM = KidViewModel()
    @State private var selectedTask: TaskInstancesModel?
    //add new tasks
    @State private var showAddView = false
    @State private var showAddPrivateTask = false
    @State private var showAddPublicTask = false
    //pickers for fetching data
    @State private var dateToFetch: Date = Date()
    @State private var showKidSelector = false
    @State private var selectedKidID: String = ""
    //customize selector
    @State private var privateOrPublic: String = "private"
    @Namespace private var namespace
    private var animationSlideInFromLeading: Bool {
        privateOrPublic == "private"
    }
    //sheets
    @State private var showActionSheet = false
    @State private var showCompleteBySelector = false
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    @State private var showCompleteAlert = false
    
    let currentUserID = Auth.auth().currentUser?.uid ?? ""

    
    func name(for selectedKidID: String?) -> String? {
        guard let selectedKidID = selectedKidID else { return nil }
        return kidVM.kids.first { $0.id == selectedKidID }?.name
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            // Background Color
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack{
                VStack(spacing: 20){
                    //header - private/public task picker and date picker
                    CustomSegmentedControl(segments: ["private", "public"], selectedSegment: $privateOrPublic)
                    TaskViewDatePicker(selectedDate: $dateToFetch)
                    if privateOrPublic == "private" {
                        VStack{
                            Button(action:{
                                self.showKidSelector = true
                            }){
                                HStack(spacing: 2){
                                    Spacer()
                                    Image("avatar1")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80)
                                        .padding(8)
                                    
                                    VStack(alignment: .leading, spacing: 8){
                                        Text(self.name(for: selectedKidID) ?? "Select kid")
                                            .font(.title2)
                                        
                                        VStack(alignment: .leading, spacing: 8){
                                            LinearProgressBar(width: 220, height: 8, percent: 80, color1: .yellow, color2: .orange)
                                            HStack{
                                                Text("Daily progress")
                                                Spacer()
                                                Text("8/10")
                                            }
                                            .font(.caption)
                                            
                                        }
                                        .padding(.trailing)
                                    }
                                    
                                    Spacer()
                                    
                                }
                                .foregroundColor(.white)
                                .frame(height: 130)
                                .background(
                                    Color.customNavyBlue
                                        .cornerRadius(20))
                                
                            }
              
                            
                            
                        }
                        
                    } else {
                        PublicTaskLeaderBoard()
                    }
                }
                .padding(.horizontal)
                Spacer()
                if privateOrPublic == "private" {
                    PrivateTaskView(taskVM: taskVM, kidVM: kidVM, selectedTask: $selectedTask, showActionSheet: $showActionSheet)
                } else if privateOrPublic == "public" {
                    PublicTaskView(kidVM: kidVM, taskVM: taskVM, selectedTask: $selectedTask, showActionSheet: $showActionSheet)

                }
            }
            .sheet(isPresented: $showAddView) {
                AddTaskSheet(showAddPrivateTaskSheet: $showAddPrivateTask, showAddPublicTaskSheet: $showAddPublicTask)
                    .presentationDetents([.height(250)])
                    .presentationDragIndicator(.hidden)
                
            }
            
            .sheet(isPresented: $showAddPrivateTask) {
                CreatePrivateTaskSheet()
                    .presentationDetents([.height(750)])
                    .presentationDragIndicator(.hidden)
                
            }
            .sheet(isPresented: $showAddPublicTask) {
                CreatePublicTaskSheet()
                    .presentationDetents([.height(750)])
                    .presentationDragIndicator(.hidden)
                
            }
            
            .sheet(isPresented: $showEditSheet) {
                if let task = selectedTask {
                    EditTaskSheet(selectedTask: task, taskVM: taskVM, kidVM: kidVM)
                        .presentationDetents([.height(750)])
                        .presentationDragIndicator(.hidden)
                }
            }
            
            .sheet(isPresented: $showCompleteBySelector) {
                CompletedByKidPicker(kidVM: kidVM, taskVM: taskVM, task: selectedTask!)
                
            }
            
            
            .sheet(isPresented: $showKidSelector) {
                TaskViewKidSelectorSheet(kidVM: kidVM, selectedKidID: $selectedKidID)
                    .presentationDetents([.height(250)])
                    .presentationDragIndicator(.hidden)
            }
            
            .sheet(isPresented: Binding(
                            get: { showActionSheet },
                            set: { showActionSheet = $0 }
            )) {
                if let task = selectedTask {
                    TaskActionSheet(taskVM: taskVM, kidVM: kidVM, task: selectedTask!, showEditTaskSheet: $showEditSheet, showDeleteAlert: $showDeleteAlert, showCompleteAlert: $showCompleteAlert, showCompleteByPicker: $showCompleteBySelector)
                        .presentationDetents([.height(300)])
                        .presentationDragIndicator(.hidden)
                    
                }
                
            }
            
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Quest"),
                    message: Text("Are you sure you want to delete this quest?"),
                    primaryButton: .destructive(Text("Delete"), action: {
                        if let taskID = selectedTask?.id, let taskOriginalID = selectedTask?.taskOriginalID, let dueDate = selectedTask?.due {
                            taskVM.deleteTask(taskID: taskID, taskOriginalID: taskOriginalID, selectedTaskDueDate: dueDate)
                        }
                    }),
                    secondaryButton: .cancel()
                )
            }
            
            .onAppear {
                kidVM.fetchKids()
            }
            .onReceive(kidVM.$kids) { kids in
                if selectedKidID == "", let firstKid = kids.first {
                    selectedKidID = firstKid.id
                    taskVM.fetchTasks(forUserID: currentUserID, dateToFetch: dateToFetch, selectedKidID: selectedKidID, privateOrPublic: privateOrPublic)
                }
            }
            .onChange(of: privateOrPublic) {taskVM.fetchTasks(forUserID: currentUserID, dateToFetch: dateToFetch, selectedKidID: selectedKidID, privateOrPublic: privateOrPublic)}
            .onChange(of: dateToFetch) {taskVM.fetchTasks(forUserID: currentUserID, dateToFetch: dateToFetch, selectedKidID: selectedKidID, privateOrPublic: privateOrPublic)}
            .onChange(of: selectedKidID) {taskVM.fetchTasks(forUserID: currentUserID, dateToFetch: dateToFetch, selectedKidID: selectedKidID, privateOrPublic: privateOrPublic)}
                    
                
                    // Add Task Button
                    Button(action:{
                        showAddView.toggle()
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
    
    
    
    struct PublicTaskLeaderBoardItem: View {
        let avatarImage: String
        let completedTasks: Int
        
        var body: some View {
            VStack(spacing: 10) {
                Image(avatarImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80)
                Text("\(completedTasks) tasks")
                    .foregroundColor(.white)
            }
            .frame(width: 130, height: 160)
            .background(Color.customNavyBlue)
            .cornerRadius(10)
        }
    }
    
    struct LeaderboardItem: Hashable {
        let avatarImage: String
        let completedTasks: Int
    }
    
    
    struct PublicTaskLeaderBoard: View {
        // Sample data
        @State private var leaderboardData: [LeaderboardItem] = [
            LeaderboardItem(avatarImage: "avatar1", completedTasks: 5),
            LeaderboardItem(avatarImage: "avatar2", completedTasks: 3),
            LeaderboardItem(avatarImage: "avatar3", completedTasks: 7)
        ]
        
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(leaderboardData.sorted { $0.completedTasks > $1.completedTasks }, id: \.self) { item in
                        PublicTaskLeaderBoardItem(avatarImage: item.avatarImage, completedTasks: item.completedTasks)
                    }
                }
                .padding(.horizontal, 10)
            }
            .padding(.vertical)
        }
    }
    




//struct RoutineItemView: View {
//    @State var routine: String
//    @State var totalTasks: Int
//    @State var completedTasks: Int
//    var body: some View {
//        HStack(spacing: 16){
//            ZStack{
//                CircularProgressBar(diameter: 60, percent: 40, color1: .blue, color2: .purple)
//                Image(routine)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 30, height: 30)
//                
//                
//            }
//            Text("\(totalTasks) out of \(completedTasks) complete")
//                .font(Font.custom("inter", size: 14)
//                )
//            
//        }
//        .padding()
//        .frame(width: 180, height: 100)
//        .foregroundColor(.white)
//        .background(Color.customNavyBlue)
//        .cornerRadius(20)
//    }
//}
//
//HStack{
//    RoutineItemView(routine: "morning", totalTasks: 6, completedTasks: 4)
//    Spacer()
//    RoutineItemView(routine: "night", totalTasks: 4, completedTasks: 4)
//}
