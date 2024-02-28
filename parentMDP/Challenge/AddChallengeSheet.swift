//
//  AddChallengeSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/25.
//

import SwiftUI
import FirebaseAuth

struct AddChallengeSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var challengeVM = ChallengeViewModel()
    @ObservedObject var kidVM = KidViewModel()
//    @ObservedObject var skillVM = SkillViewModel()

    
    //display pickers
    @State private var showKidPicker = false
    @State private var showDifficultyPicker = false
    @State private var showDatePicker = false
    @State private var showRewardPicker = false
    @State private var showSkillPicker = false


    // selected properties
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    @State private var name: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedKidID: String? = nil
    @State private var selectedDifficulty: DifficultyOptions = .easy
    @State private var selectedType: ChallengeTypeOptions = .assigned
    @State private var selectedreward: Int = 0
    @State private var selectedSkill: String? = nil



    func name(for selectedKidID: String?) -> String? {
        guard let selectedKidID = selectedKidID else { return nil }
        return kidVM.kids.first { $0.id == selectedKidID }?.name
    }
    
    var body: some View {
        ZStack{
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
                    GenericPickerButton(pickerText: "Reward", selectionText: "\(selectedreward)", isPresenting: $showRewardPicker) {
                        PricePicker(selectedPrice: $selectedreward)
                            .presentationDetents([.height(380)])
                            .presentationDragIndicator(.hidden)
                    }
                    // assign to picker
                    GenericPickerButton(pickerText: "Assign To", selectionText: self.name(for: selectedKidID) ?? "Select kid", isPresenting: $showKidPicker) {
                        AssignToPicker(viewModel: kidVM, selectedKidID: $selectedKidID)
                            .presentationDetents([.height(250)])
                            .presentationDragIndicator(.hidden)
                    }
//                    GenericPickerButton(pickerText: "Skill", selectionText: self.name(for: selectedKidID) ?? "Select skill", isPresenting: $showKidPicker) {
////                        SkillPicker()
//          
//                    }
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
                        presentationMode.wrappedValue.dismiss()
                        challengeVM.createChallenge(name: name, createdBy: currentUserID, assignTo: selectedKidID!, difficulty: selectedDifficulty.rawValue, due: selectedDate, assignedOrSelfSelected: selectedType.rawValue, reward: selectedreward)

                      
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

enum ChallengeTypeOptions: String, CaseIterable {
    case assigned = "assigned"
    case selfSelected = "self-selected"
    static func fromString(_ type: String) -> ChallengeTypeOptions? {
        return ChallengeTypeOptions(rawValue: type.capitalized)
    }
}
struct ChallengeTypePicker: View {
    @Binding var selectedType: ChallengeTypeOptions

    var body: some View {
        HStack{
            ForEach(ChallengeTypeOptions.allCases, id: \.self) { option in
                Button(action: {
                    self.selectedType = option
                }) {
                    VStack(spacing: 24) {
                        Image(imageString(for: option))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80)
                        Text(option.rawValue)
                            .foregroundColor(.white)
                    }
                    .frame(width: 130, height: 160)
                    .background(self.selectedType == option ? Color.customPurple : Color.black.opacity(0.6)) // Replaced custom colors for the example
                    .cornerRadius(10)
                }
            }
        }
        .padding()
    }
    private func imageString(for type: ChallengeTypeOptions) -> String {
        return type.rawValue
    }
}

