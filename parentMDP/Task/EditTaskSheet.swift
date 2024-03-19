//
//  EditTaskSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct EditTaskSheet: View {
    // MARK: Properties
    @Environment(\.presentationMode) var presentationMode
    
    var selectedTask: TaskInstancesModel
    @ObservedObject var taskVM: TaskViewModel
    @ObservedObject var kidVM: KidViewModel
    
    //display pickers
    @State private var showKidPicker = false
    @State private var showDifficultyPicker = false
    @State private var showRoutinePicker = false
    @State private var showRepeatPicker = false
    @State private var showDatePicker = false
    
    // prefilled and preselected properties
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    @State private var name: String = ""
    @State private var selectedRepeat: RepeatingOptions
    @State private var selectedDifficulty: DifficultyOptions
    @State private var selectedDate: Date = Date()
    @State private var selectedDays: Set<Int> = []
    @State private var selectedKidID: String? = nil
    @State private var selectedRoutine: RoutineOptions?
    
        
    // MARK: INIT
    init(selectedTask: TaskInstancesModel, taskVM: TaskViewModel, kidVM: KidViewModel) {
        self.selectedTask = selectedTask
        self.taskVM = taskVM
        self.kidVM = kidVM
        _name = State(initialValue: selectedTask.name)
        _selectedDifficulty = State(initialValue: DifficultyOptions(rawValue: selectedTask.difficulty)!)
        _selectedRepeat = State(initialValue: RepeatingOptions(rawValue: selectedTask.repeatingPattern)!)
        _selectedDate = State(initialValue: selectedTask.due)
        
        if let routineRawValue = selectedTask.routine, let routine = RoutineOptions(rawValue: routineRawValue) {
            _selectedRoutine = State(initialValue: routine)
        } else {
            _selectedRoutine = State(initialValue: nil) // For public tasks without a routine
        }
        _selectedKidID = State(initialValue: selectedTask.assignTo)
    }
       
    // MARK: Functions
    func name(for selectedKidID: String?) -> String? {
        guard let selectedKidID = selectedKidID else { return nil }
        return kidVM.kids.first { $0.id == selectedKidID }?.name
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack{
                //Header
                HStack{
                    //cancel button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "xmark")
                    }
                    Spacer()
                    Text("New Private Task")
                    Spacer()
                    
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.customNavyBlue)
                
                // MARK: Forms
                VStack(spacing: 12) {
                    // task name
                    CustomTextfield(text: $name, placeholder: "ready for the next mission", icon: "", background: Color.customNavyBlue, color: Color.white)
                    
                    // difficulty picker
                    GenericPickerButton(pickerText: "Difficulty", selectionText: selectedDifficulty.rawValue, isPresenting: $showDifficultyPicker) {
                        DifficultyPicker(selectedDifficulty: $selectedDifficulty)
                            .presentationDetents([.height(280)])
                            .presentationDragIndicator(.hidden)
                    }
                    
                    if selectedTask.privateOrPublic == "private" {
                        // assign to picker
                        GenericPickerButton(pickerText: "Assign To", selectionText: name(for: selectedKidID)!, isPresenting: $showKidPicker) {
                            AssignToPicker(viewModel: kidVM, selectedKidID: $selectedKidID)
                                .presentationDetents([.height(250)])
                                .presentationDragIndicator(.hidden)
                        }
                    }
                    
                    // repeat picker
                    GenericPickerButton(pickerText: "Repeat", selectionText: selectedRepeat.rawValue, isPresenting: $showRepeatPicker) {
                        RepeatPicker(selectedRepeat: $selectedRepeat)
                            .presentationDetents([.height(600)])
                            .presentationDragIndicator(.hidden)
                    }
                    
                    if selectedTask.privateOrPublic == "private" {
                        // routine picker
                        GenericPickerButton(pickerText: "Routine", selectionText: selectedRoutine?.rawValue ?? "", isPresenting: $showRoutinePicker) {
                            RoutinePicker(selectedRoutine: $selectedRoutine)
                                .presentationDetents([.height(300)])
                                .presentationDragIndicator(.hidden)
                        }
                    }
                    
                    // routine picker
                    GenericPickerButton(pickerText: "Date", selectionText: selectedDate.formattedDate(), isPresenting: $showDatePicker) {
                        CalendarDatePicker(onDateSelected: { selectedDate in
                            self.selectedDate = selectedDate
                        })
                        .presentationDetents([.height(380)])
                        .presentationDragIndicator(.hidden)
                    }
                    if selectedRepeat == .custom {
                        WeekdayPicker(selectedDays: $selectedDays)
                    }
                    
                    
                    // MARK: Button
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                        let daysArray = selectedDays.isEmpty ? nil : Array(selectedDays)
                        taskVM.updateTask(selectedTask, name: name, timeCreated: Date(), createdBy: currentUserID, assignTo: selectedKidID!, difficulty: selectedDifficulty.rawValue, routine: selectedRoutine!.rawValue, dueOrStartDate: selectedDate, repeatingPattern: selectedRepeat.rawValue, selectedDays: daysArray, privateOrPublic: selectedTask.privateOrPublic)
                    }){
                        Text("Edit task")
                    }
                    .frame(width: 330, height: 50)
                    .buttonStyle(ThreeD(backgroundColor: .customPurple, shadowColor: .black))
                    .foregroundColor(.white)
                    
                }
                
            }
        }
    }
    
}


// MARK: Generic Picker Button
struct GenericPickerButton<Content: View>: View {
    let pickerText: String
    let selectionText: String
    @Binding var isPresenting: Bool
    let content: () -> Content
    
    var body: some View {
        Button(action: {
            self.isPresenting = true
        }) {
            HStack {
                Text(pickerText)
                Spacer()
                Text(selectionText)
            }
            .frame(width: 330, height: 24)
            .foregroundColor(.white)
            .padding()
            .background(Color.customNavyBlue)
            .cornerRadius(10)
        }
        .sheet(isPresented: $isPresenting) {
            self.content()
        }
    }
}
