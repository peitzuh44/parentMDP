//
//  KidSelectorSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/19.
//

import SwiftUI


// MARK: Kid Selector (TaskView)
struct TaskViewKidSelectorSheet: View {
    
    // MARK: Properties
    @ObservedObject var kidVM: KidViewModel
    @Binding var selectedKidID: String
    @Environment(\.presentationMode) var presentationMode

    
    // MARK: Body
    var body: some View {
        ZStack {
            Color.customNavyBlue.ignoresSafeArea(.all)
            VStack (alignment: .leading, spacing: 16){
                Text("Select Kid...")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                // MARK: Kid Options
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(kidVM.kids) {
                            kid in
                            Button(action: {
                                self.selectedKidID = kid.id
                                presentationMode.wrappedValue.dismiss()

                            }) {
                                VStack(spacing: 10) {
                                    Image(kid.avatarImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80)
                                    Text(kid.name)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 130, height: 160)
                                .background(selectedKidID == kid.id ? Color.customGreen : Color.black.opacity(0.6))
                                .cornerRadius(10)                        }
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }


        }
        // MARK: Fetching
        .onReceive(kidVM.$kids) { kids in
            // Set the selectedKidID to the first kid's ID if it hasn't been set yet
            if selectedKidID == nil, let firstKid = kids.first {
                selectedKidID = firstKid.id
            }
        }
    }
}


// MARK: Kid Selector (ChallengeView)
struct ChallengeViewKidSelectorSheet: View {
    
    // MARK: Properties
    @ObservedObject var kidVM: KidViewModel
    @Binding var selectedKidID: String
    @Environment(\.presentationMode) var presentationMode

    // MARK: Body
    var body: some View {
        ZStack {
            Color.customNavyBlue.ignoresSafeArea(.all)
            VStack (alignment: .leading, spacing: 16){
                Text("Select Kid...")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                // MARK: Kid Options
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(kidVM.kids) {
                            kid in
                            Button(action: {
                                self.selectedKidID = kid.id
                                presentationMode.wrappedValue.dismiss()

                            }) {
                                VStack(spacing: 10) {
                                    Image(kid.avatarImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80)
                                    Text(kid.name)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 130, height: 160)
                                .background(selectedKidID == kid.id ? Color.customGreen : Color.black.opacity(0.6))
                                .cornerRadius(10)                        }
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }


        }
    }
}

