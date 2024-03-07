//
//  AddKidSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI

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
                //kid's name
                CustomTextfield(text: $name, placeholder: "Kid's Name", icon: "", background: Color.customNavyBlue, color: Color.white)
                //birthdate
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

                
                GenderPicker(selectedGender: $selectedGender)
                
                
                Spacer()
                Button(action:{
                    presentationMode.wrappedValue.dismiss()
                    if let selectedGender = selectedGender {
                        viewModel.addKids(name: name, gender: selectedGender.rawValue, birthdate: selectedBirthdate)
                        presentationMode.wrappedValue.dismiss()
                    }

                }){
                    Text("Add")
                        .foregroundStyle(Color.white)

                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .buttonStyle(ThreeD(backgroundColor: Color.customPurple, shadowColor: Color.black)
                             )
                .padding()

                
            }
        }

        
                        
    }
}

struct AddKidSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddKidView(authFlow: Binding.constant(.notAuthenticated))
    }
}



enum GenderOptions: String, CaseIterable {
    case male = "male"
    case female = "female"
}
struct GenderPicker: View {
    @Binding var selectedGender: GenderOptions?

    var body: some View {
        HStack{
            ForEach(GenderOptions.allCases, id: \.self) { option in
                Button(action: {
                    self.selectedGender = option
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
                    .background(self.selectedGender == option ? Color.customPurple : Color.black.opacity(0.6)) // Replaced custom colors for the example
                    .cornerRadius(10)
                }
            }
        }
        .padding()
    }
    private func imageString(for gender: GenderOptions) -> String {
        return gender.rawValue
    }
}

