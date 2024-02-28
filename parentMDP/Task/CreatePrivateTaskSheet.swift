//
//  CreateTaskSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/24.
//

import SwiftUI
import FirebaseAuth
struct CreatePrivateTaskSheet: View {
    @ObservedObject var taskVM = TaskViewModel()
    @ObservedObject var kidVM = KidViewModel()
    @Environment(\.presentationMode) var presentationMode

    //display pickers
    @State private var showKidPicker = false
    @State private var showDifficultyPicker = false
    @State private var showRoutinePicker = false
    @State private var showRepeatPicker = false
    @State private var showDatePicker = false
    
    
    // selected properties
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    @State private var name: String = ""
    @State private var selectedRepeat: RepeatingOptions = .oneOff
    @State private var selectedDifficulty: DifficultyOptions = .easy
    @State private var selectedDate: Date = Date()
    @State private var selectedDays: Set<Int> = []
    @State private var selectedKidID: String? = nil
    @State private var selectedRoutine: RoutineOptions? = .anytime
    
    
    func name(for selectedKidID: String?) -> String? {
        guard let selectedKidID = selectedKidID else { return nil }
        return kidVM.kids.first { $0.id == selectedKidID }?.name
    }

    
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
                
                VStack(spacing: 12) {
                    // task name
                    CustomTextfield(text: $name, placeholder: "ready for the next mission", icon: "", background: Color.customNavyBlue, color: Color.white)
                    
                    // difficulty picker
                    GenericPickerButton(pickerText: "Difficulty", selectionText: selectedDifficulty.rawValue, isPresenting: $showDifficultyPicker) {
                        DifficultyPicker(selectedDifficulty: $selectedDifficulty)
                            .presentationDetents([.height(280)])
                            .presentationDragIndicator(.hidden)
                    }
                    
                    // assign to picker
                    GenericPickerButton(pickerText: "Assign To", selectionText: self.name(for: selectedKidID) ?? "Select kid", isPresenting: $showKidPicker) {
                        AssignToPicker(viewModel: kidVM, selectedKidID: $selectedKidID)
                            .presentationDetents([.height(250)])
                            .presentationDragIndicator(.hidden)
                    }
            
                    
                    // repeat picker
                    GenericPickerButton(pickerText: "Repeat", selectionText: selectedRepeat.rawValue, isPresenting: $showRepeatPicker) {
                        RepeatPicker(selectedRepeat: $selectedRepeat)
                            .presentationDetents([.height(600)])
                            .presentationDragIndicator(.hidden)
                    }
                    
                    // routine picker
                    GenericPickerButton(pickerText: "Routine", selectionText: selectedRoutine!.rawValue, isPresenting: $showRoutinePicker) {
                        RoutinePicker(selectedRoutine: $selectedRoutine)
                            .presentationDetents([.height(300)])
                            .presentationDragIndicator(.hidden)
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
                    Spacer()
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                        let daysArray = selectedDays.isEmpty ? nil : Array(selectedDays)
                        taskVM.createPrivateTask(name: name, timeCreated: Date(), createdBy: currentUserID, assignTo: selectedKidID!, difficulty: selectedDifficulty.rawValue, routine: selectedRoutine!.rawValue, dueOrStartDate: selectedDate, repeatingPattern: selectedRepeat.rawValue, selectedDays: daysArray)
                      
                    }){
                        Text("Create task")
                    }
                    .frame(width: 330, height: 50)
                    .buttonStyle(ThreeD(backgroundColor: .customPurple, shadowColor: .black))
                    .foregroundColor(.white)
                    
                }
                
            }
        }
    }
}
