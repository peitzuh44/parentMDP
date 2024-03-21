//
//  ReviewChallengeView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/20.
//

import SwiftUI

struct ReviewChallengeView: View {
    // MARK: Properties
    @Environment(\.presentationMode) var presentationMode
    var selectedChallenge: ChallengeModel
    @ObservedObject var challengeVM = ChallengeViewModel()

    // display pickers
    @State private var showDatePicker = false
    
    
    // selected properties
    @State private var comment: String = ""
    @State private var selectedDateCompleted: Date = Date()

    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack{
                //Header START
                HStack{
                    //cancel button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "xmark")
                    }
                    Spacer()
                    Text("New Challenge")
                    Spacer()
                    
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.customNavyBlue)
                // Header END
                
                // Form START
                VStack(spacing: 12) {
                    // Parent's Comment and feedback
                    TextEditor(text: $comment)
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color.black)
                        .background(Color.customNavyBlue)
               
                    // date completed picker
                    GenericPickerButton(pickerText: "Date", selectionText: selectedDateCompleted.formattedDate(), isPresenting: $showDatePicker) {
                        CalendarDatePicker(onDateSelected: { selectedDate in
                            self.selectedDateCompleted = selectedDate
                        })
                        .presentationDetents([.height(380)])
                        .presentationDragIndicator(.hidden)
                    }
                    

                    Spacer()
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                        var updatedChallenge = selectedChallenge
                        updatedChallenge.comment = comment
                        updatedChallenge.dateCompleted = selectedDateCompleted
                        
                        challengeVM.completeChallengeAndUpdateKidGem(challenge: selectedChallenge, comment: comment, dateComplete: selectedDateCompleted)
                      
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
