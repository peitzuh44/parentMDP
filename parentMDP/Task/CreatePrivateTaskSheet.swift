//
//  CreateTaskSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/24.
//

import SwiftUI
import FirebaseAuth
struct CreatePrivateTaskSheet: View {
    
    // MARK: Properties
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
                    Text("new individual quest")
                    Spacer()
                    
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.customNavyBlue)
                
                // MARK: Form
                ScrollView{
                    VStack(spacing: 12) {
                        // task name
                        CustomTextfield(text: $name, placeholder: "name your quest...", icon: "textformat", background: Color.customNavyBlue, color: Color.white)
                        
                        // difficulty picker
                        GenericPickerButton(pickerText: "Difficulty", selectionText: selectedDifficulty.rawValue, isPresenting: $showDifficultyPicker) {
                            DifficultyPicker(selectedDifficulty: $selectedDifficulty)
                                .presentationDetents([.medium])
                                .presentationDragIndicator(.hidden)
                        }
                        
                        // assign to picker
                        GenericPickerButton(pickerText: "Assign To", selectionText: self.name(for: selectedKidID) ?? "Select kid", isPresenting: $showKidPicker) {
                            AssignToPicker(viewModel: kidVM, selectedKidID: $selectedKidID)
                                .presentationDetents([.medium])
                                .presentationDragIndicator(.hidden)
                        }
                
                        
                        // repeat picker
                        GenericPickerButton(pickerText: "Repeat", selectionText: selectedRepeat.rawValue, isPresenting: $showRepeatPicker) {
                            RepeatPicker(selectedRepeat: $selectedRepeat)
                                .presentationDetents([.large])
                                .presentationDragIndicator(.hidden)
                        }
                        
                        // routine picker
                        GenericPickerButton(pickerText: "Routine", selectionText: selectedRoutine!.rawValue, isPresenting: $showRoutinePicker) {
                            RoutinePicker(selectedRoutine: $selectedRoutine)
                                .presentationDetents([.medium])
                                .presentationDragIndicator(.hidden)
                        }
                    
                        
                        // routine picker
                        GenericPickerButton(pickerText: "Date", selectionText: selectedDate.formattedDate(), isPresenting: $showDatePicker) {
                            CalendarDatePicker(onDateSelected: { selectedDate in
                                self.selectedDate = selectedDate
                            })
                            .presentationDetents([.medium])
                            .presentationDragIndicator(.hidden)
                        }
                        if selectedRepeat == .custom {
                            WeekdayPicker(selectedDays: $selectedDays)
                        }
                        Spacer()
                        
                        // MARK: Button
                        Button(action:{
                            presentationMode.wrappedValue.dismiss()
                            let daysArray = selectedDays.isEmpty ? nil : Array(selectedDays)
                            taskVM.createPrivateTask(name: name, timeCreated: Date(), createdBy: currentUserID, assignTo: selectedKidID!, difficulty: selectedDifficulty.rawValue, routine: selectedRoutine!.rawValue, dueOrStartDate: selectedDate, repeatingPattern: selectedRepeat.rawValue, selectedDays: daysArray)
                          
                        }){
                            Text("create individual quest")
                        }
                        .frame(width: 330, height: 50)
                        .buttonStyle(ThreeD(backgroundColor: .customPurple, shadowColor: .black))
                        .foregroundColor(.white)
                        
                    }
                }

                
            }
        }
    }
}
