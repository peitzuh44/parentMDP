//
//  EditKidSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/20.
//

import SwiftUI

struct EditKidSheet: View {
    // MARK: Properties
    @Environment(\.presentationMode) var presentationMode
    var selectedKid: KidModel
    @ObservedObject var kidVM: KidViewModel
    
    // Prefilled and Preselectd Properties
    @State private var name: String = ""
    @State private var selectedGender: GenderOptions
    @State private var selectedBirthdate: Date
    
    // Pickers
    @State private var showBirthdatePicker = false

    // MARK: INIT
    init(selectedKid: KidModel, kidVM: KidViewModel) {
        self.selectedKid = selectedKid
        self.kidVM = kidVM
        _name = State(initialValue: selectedKid.name)
        _selectedGender = State(initialValue: GenderOptions(rawValue: selectedKid.gender)!)
        _selectedBirthdate = State(initialValue: selectedKid.birthdate)

    }
    
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
                            kidVM.updateKid(updatedKid: selectedKid)
        
                            presentationMode.wrappedValue.dismiss()
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
