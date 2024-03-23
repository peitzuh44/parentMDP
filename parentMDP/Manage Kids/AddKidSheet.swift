//
//  AddKidSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//  Edited by Eric Tran on 2024/3/7.
//
//  SUMMARY: This sheet is pulled up whenever we want to add a new kid, this will ask for the name, birthdate, and gender of the kid and add the kid to the db once we fill out all of the information

import SwiftUI


struct AddKidSheet: View {
    // MARK: Properties
    @Environment(\.presentationMode) var presentationMode
    var kidVM: KidViewModel
    @State private var name: String = ""
    @State private var selectedGender: GenderOptions = .male
    @State private var selectedBirthdate = Date()
    @AppStorage("kidID") var kidID: String = ""
    @State private var showBirthdatePicker = false

    // MARK: Body
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            
            VStack{
                // MARK: Header
                HStack{
                    //cancel button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "xmark")
                    }
                    Spacer()
                    Text("Add a new kid")
                    Spacer()
                    
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.customNavyBlue)
                
                CustomTextfield(text: $name, placeholder: "Kid's Name", icon: "", background: Color.customNavyBlue, color: Color.white)
                
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

                GenderPicker(selectedGender: $selectedGender)
                
                Spacer()
                
                // Add Kid Button START
                Button(action:{
                    // If the user has selected the gender and given a name, proceed!
                        if !name.isEmpty {
                            kidVM.addKids(name: name, gender: selectedGender.rawValue, birthdate: selectedBirthdate)
                            presentationMode.wrappedValue.dismiss()
                        }
                }){
                    Text("Add a new kid")
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



// MARK: Gender Options
enum GenderOptions: String, CaseIterable {
    case male = "male"
    case female = "female"
}
