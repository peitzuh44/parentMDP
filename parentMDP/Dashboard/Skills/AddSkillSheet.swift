//
//  AddSkillSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/23.
//

import SwiftUI
import FirebaseAuth

struct AddSkillSheet: View {
    var kidID: String
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var kidVM = KidViewModel()
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    
    
    // picker
    @State private var showSkillCategoryPicker = false
    
    //selected values
    @State private var name: String = ""
    @State private var selectedCategory: SkillCategoryOption = .sports
    
    var body: some View {
        ZStack {
            Color.customDarkBlue.ignoresSafeArea(.all)
            // MARK: Foreground
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
                    Text("Add new skill")
                    Spacer()
                    
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.customNavyBlue)
                VStack(spacing: 12){
                    CustomTextfield(text: $name, placeholder: "enter skill name...", icon: "", background: Color.customNavyBlue, color: Color.white)
                    // skill category picker
                    GenericPickerButton(pickerText: "Category", selectionText: selectedCategory.description, isPresenting: $showSkillCategoryPicker) {
                        SkillCategoryPicker(selectedCategory: $selectedCategory)
                            .presentationDetents([.large])
                            .presentationDragIndicator(.hidden)
                    }

                    
                    Spacer()
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                        kidVM.addSkillToKid(name: name, category: selectedCategory.description, kidID: kidID)
                      

                    }){
                        Text("Create skill")
                    }
                    .frame(width: 330, height: 50)
                    .buttonStyle(ThreeD(backgroundColor: .customPurple, shadowColor: .black))
                    .foregroundColor(.white)
                }
                .padding(.vertical)
            }

        }
    }
}
