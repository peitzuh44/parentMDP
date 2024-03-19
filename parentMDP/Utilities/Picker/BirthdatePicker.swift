//
//  BirthdatePicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//  Edited by Eric Tran on 2024/3/7.

import SwiftUI

struct BirthdatePicker: View {
    // MARK: Properties
    @Binding var selectedBirthdate: Date
    @Environment(\.presentationMode) var presentationMode

    // MARK: Body
    var body: some View {
        ZStack{
            Color.customNavyBlue.ignoresSafeArea(.all)
            VStack(spacing: 10){
                DatePicker("Select Birthdate", selection: $selectedBirthdate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .padding(10)
                    .colorScheme(.dark)
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }){
                    Text("Done")
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.customPurple)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }
                .padding()
            }
        }

    }
}


// MARK: Preivew
struct BirthdatePicker_Previews: PreviewProvider {
    @State static var previewDate = Date()
    
    static var previews: some View {
        BirthdatePicker(selectedBirthdate: $previewDate)
    }
}
