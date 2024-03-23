//
//  CreatePublicTaskSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/24.
//

import SwiftUI
import FirebaseAuth
struct CreatePublicTaskSheet: View {
    // MARK: Properties
    @ObservedObject var taskVM = TaskViewModel()
    @Environment(\.presentationMode) var presentationMode

    //display pickers
    @State private var showDifficultyPicker = false
    @State private var showRepeatPicker = false
    @State private var showDatePicker = false
    
    
    // selected properties
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    @State private var name: String = ""
    @State private var selectedRepeat: RepeatingOptions = .oneOff
    @State private var selectedDifficulty: DifficultyOptions = .easy
    @State private var selectedDate: Date = Date()
    @State private var selectedDays: Set<Int> = []
    

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
                
                ScrollView{
                    VStack(spacing: 12) {
                        // task name
                        CustomTextfield(text: $name, placeholder: "ready for the next mission", icon: "", background: Color.customNavyBlue, color: Color.white)
                        
                        // difficulty picker
                        GenericPickerButton(pickerText: "Difficulty", selectionText: selectedDifficulty.rawValue, isPresenting: $showDifficultyPicker) {
                            DifficultyPicker(selectedDifficulty: $selectedDifficulty)
                                .presentationDetents([.medium])
                                .presentationDragIndicator(.hidden)
                        }
                        
                        
                        // repeat picker
                        GenericPickerButton(pickerText: "Repeat", selectionText: selectedRepeat.rawValue, isPresenting: $showRepeatPicker) {
                            RepeatPicker(selectedRepeat: $selectedRepeat)
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
                        // MARK: Buttonw
                        Button(action:{
                            presentationMode.wrappedValue.dismiss()
                            let daysArray = selectedDays.isEmpty ? nil : Array(selectedDays)
                            taskVM.createPublicTask(name: name, timeCreated: Date(), createdBy: currentUserID, difficulty: selectedDifficulty.rawValue, dueOrStartDate: selectedDate, repeatingPattern: selectedRepeat.rawValue, selectedDays: daysArray, completedBy: "")
                          
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
}
