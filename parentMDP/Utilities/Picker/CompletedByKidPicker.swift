//
//  CompletedByKidPicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI

struct CompletedByKidPicker: View {
    // MARK: Properties
    @ObservedObject var kidVM: KidViewModel
    @ObservedObject var taskVM: TaskViewModel
    var task: TaskInstancesModel
    @State private var completedBy: String?
    @Environment(\.presentationMode) var presentationMode

    // MARK: Body
    var body: some View {
        ZStack {
            Color.customNavyBlue.ignoresSafeArea(.all)
            VStack (alignment: .leading, spacing: 16){
                Text("Completed by...")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                // MARK: Kid Options
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(kidVM.kids) {
                            kid in
                            Button(action: {
                                self.completedBy = kid.id
                                taskVM.completeTaskAndUpdateKidGold(task: task, completedBy: completedBy)
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
                                .background(completedBy == kid.id ? Color.customGreen : Color.black.opacity(0.6))
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }


        }
        // MARK: Fetching
        .onAppear{
            kidVM.fetchKids()
        }
    }
}
