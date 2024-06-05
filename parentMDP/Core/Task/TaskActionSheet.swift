//
//  TaskActionSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/24.
//

import SwiftUI
import FirebaseAuth


struct TaskActionSheet: View {
    // MARK: Properties
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var taskVM: TaskViewModel
    @ObservedObject var kidVM: KidViewModel
    @State var task: TaskInstancesModel
    @State var selectedKidID: String? = ""
    @Binding var showEditTaskSheet: Bool
    @Binding var showDeleteAlert: Bool
    @Binding var showCompleteAlert: Bool
    @Binding var showCompleteByPicker: Bool
    
    
    // MARK: Functions
    func difficultyColor(for difficulty: String) -> Color {
           switch difficulty {
           case "Easy":
               return Color.green.opacity(0.6)
           case "Medium":
               return Color.yellow.opacity(0.6)
           case "Hard":
               return Color.red.opacity(0.6)
           default:
               return Color.gray.opacity(0.6)
           }
       }
    
    // MARK: Body
    var body: some View {
        ZStack {
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack(spacing: 16){
                VStack(spacing: 16){
                    Text(task.name)
                        .foregroundColor(.white)
                        .font(.title2)
                    HStack{
                        HStack(spacing:4){
                            Image(task.difficulty)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24)
                            Text(task.difficulty)
                                .foregroundColor(.white)
                            
                        }
                        .padding(8)
                        .padding(.horizontal, 10)
                        .background(difficultyColor(for: task.difficulty).opacity(0.6))
                        .cornerRadius(50)
                    }
                    
             
                    
                }
                .padding(.vertical, 24)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(Color.customNavyBlue)
                .cornerRadius(20)
                .padding(.horizontal)
                
                // MARK: Return By Case
                if task.privateOrPublic == "private" {
                    privateTaskUI
                }
                if task.privateOrPublic == "public" {
                    publicTaskUI
                }
            }
        }
    }
    
    
    // MARK: Private Task
    private var privateTaskUI: some View {
        
        HStack(spacing: 24) {
            ActionSheetButton(image: "edit", text: "edit", color: Color.customNavyBlue, size: 50, isPresenting: $showEditTaskSheet)
            ActionSheetButton(image: "check", text: "complete", color: Color.customPurple, size: 50, isPresenting: $showCompleteAlert) {
                taskVM.completeTaskAndUpdateKidCoin(task: task, completedBy: selectedKidID)
            }
            ActionSheetButton(image: "trash", text: "delete", color: Color.customNavyBlue, size: 50, isPresenting: $showDeleteAlert)
            
        }
    }
    
    // MARK: Public Task
    private var publicTaskUI: some View {
        
        HStack(spacing: 24) {
            ActionSheetButton(image: "edit", text: "edit", color: Color.customNavyBlue, size: 50, isPresenting: $showEditTaskSheet)
            ActionSheetButton(image: "check", text: "complete", color: Color.customPurple, size: 50, isPresenting: $showCompleteByPicker)
            ActionSheetButton(image: "trash", text: "delete", color: Color.customNavyBlue, size: 50, isPresenting: $showDeleteAlert)
            
        }
    }
    

}


// MARK: ActionSheetButton
struct ActionSheetButton: View {
    @Environment(\.presentationMode) var presentationMode
    let image: String
    let text: String
    let color: Color
    let size: CGFloat
    @Binding var isPresenting: Bool
    var action: (() -> Void)? // Optional action to run
    
    var body: some View {
        Button(action: {
            action?()
            
            presentationMode.wrappedValue.dismiss()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isPresenting = true
            }
        }){
            VStack(spacing: 16){
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .padding(24)
                    .background(color)
                    .cornerRadius(20)
                Text(text)
                    .foregroundColor(.white)
            }
        }

    }
}


