//
//  AddKidSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//  Edited by Eric Tran on 2024/3/7.
//
//  SUMMARY: This sheet is pulled up whenever we want to add a new kid, this will ask for the name, birthdate, and gender of the kid and add the kid to the db once we fill out all of the information

import SwiftUI

enum GenderOptions: String, CaseIterable {
    case male = "male"
    case female = "female"
}

struct AddKidSheet: View {
    @Environment(\.presentationMode) var presentationMode
    var viewModel: KidViewModel
    @State private var name: String = ""
    @State private var selectedGender: GenderOptions?
    @State private var selectedBirthdate = Date()
    @AppStorage("kidID") var kidID: String = ""
    @State private var showBirthdatePicker = false

    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            
            VStack{
                // Header START
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
                // Header END
                
                // CustomTextField for kid's name START
                CustomTextfield(text: $name, placeholder: "Kid's Name", icon: "", background: Color.customNavyBlue, color: Color.white)
                // CustomTextField for kid's name END
                
                // Button that will show the BirthDate Picker START
                Button(action:{
                    self.showBirthdatePicker = true
                }){
                    HStack {
                        Text("Birthdate")
                        Spacer()
                        Text(selectedBirthdate.formattedDate())
                    }
                    .frame(width: 330, height: 24)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.customNavyBlue)
                    .cornerRadius(10)
                }
                .sheet(isPresented: $showBirthdatePicker) {
                    BirthdatePicker(selectedBirthdate: $selectedBirthdate)
                        .presentationDetents([.height(380)])
                        .presentationDragIndicator(.hidden)
                }
                // Button that will show the Birthdate Picker END

                // GenderPicker START
                GenderPicker(selectedGender: $selectedGender)
                // GenderPicker END
                
                Spacer()
                
                // Add Kid Button START
                Button(action:{
                    // If the user has selected the gender and given a name, proceed!
                    if let selectedGender = selectedGender {
                        if !name.isEmpty {
                            viewModel.addKids(name: name, gender: selectedGender.rawValue, birthdate: selectedBirthdate)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }){
                    Text("Add")
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .buttonStyle(ThreeD(backgroundColor: Color.customPurple, shadowColor: Color.black))
                .padding()
                // Add Kid Button END
            }
        }

        
                        
    }
}


