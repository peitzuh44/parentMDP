//
//  EditChallengeSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/15.
//

import SwiftUI

struct EditChallengeSheet: View {
    //MARK: Properties
    @Environment(\.presentationMode) var presentationMode
    var selectedChallenge: ChallengeModel
    @ObservedObject var challengeVM: ChallengeViewModel
    @ObservedObject var kidVM: KidViewModel

    // Prefilled properties
    @State private var name: String = ""
    @State private var selectedDate: Date
    @State private var selectedKidID: String? = nil
    @State private var selectedDifficulty: DifficultyOptions
    @State private var selectedType: ChallengeTypeOptions
    @State private var selectedreward: Int
    
    // Pickers
    @State private var showKidPicker = false
    @State private var showDifficultyPicker = false
    @State private var showDatePicker = false
    @State private var showRewardPicker = false
    @State private var showSkillPicker = false
    
    // MARK: INIT
    init(selectedChallenge: ChallengeModel, challengeVM: ChallengeViewModel, kidVM: KidViewModel){
        self.selectedChallenge = selectedChallenge
        self.challengeVM = challengeVM
        self.kidVM = kidVM
        _name = State(initialValue: selectedChallenge.name)
        _selectedDifficulty = State(initialValue: DifficultyOptions(rawValue: selectedChallenge.difficulty)!)
        _selectedDate = State(initialValue: selectedChallenge.due)
        _selectedKidID = State(initialValue: selectedChallenge.assignTo)
        _selectedreward = State(initialValue: selectedChallenge.reward)
        _selectedType = State(initialValue: ChallengeTypeOptions(rawValue: selectedChallenge.assignedOrSelfSelected)!)
    }
    
    // MARK: Functions
    func name(for selectedKidID: String?) -> String? {
        guard let selectedKidID = selectedKidID else { return nil }
        return kidVM.kids.first { $0.id == selectedKidID }?.name
    }
    
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            ScrollView{
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
                        Text("Edit Challenge")
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
                        GenericPickerButton(pickerText: "Reward", selectionText: "\(selectedreward)", isPresenting: $showRewardPicker) {
                            PricePicker(selectedPrice: $selectedreward)
                                .presentationDetents([.height(380)])
                                .presentationDragIndicator(.hidden)
                        }
                        // assign to picker

                        GenericPickerButton(pickerText: "Assign To", selectionText: name(for: selectedKidID)!, isPresenting: $showKidPicker) {
                            AssignToPicker(viewModel: kidVM, selectedKidID: $selectedKidID)
                                .presentationDetents([.height(250)])
                                .presentationDragIndicator(.hidden)
                        }

                        // date picker
                        GenericPickerButton(pickerText: "Date", selectionText: selectedDate.formattedDate(), isPresenting: $showDatePicker) {
                            CalendarDatePicker(onDateSelected: { selectedDate in
                                self.selectedDate = selectedDate
                            })
                            .presentationDetents([.height(380)])
                            .presentationDragIndicator(.hidden)
                        }
                        ChallengeTypePicker(selectedType: $selectedType)
                        

                        Spacer()
                        Button(action:{
                            
                            //MARK: Call Update Function
                            presentationMode.wrappedValue.dismiss()
                            var updatedChallenge = selectedChallenge
                            updatedChallenge.name = name
                            updatedChallenge.difficulty = selectedDifficulty.rawValue
                            updatedChallenge.reward = selectedreward
                            updatedChallenge.assignedOrSelfSelected = selectedType.rawValue
                            challengeVM.updateChallenge(updatedChallenge: updatedChallenge)
                            
                        }){
                            Text("Create challenge")
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

