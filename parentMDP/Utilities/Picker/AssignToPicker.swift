//
//  AssignToPicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI

struct AssignToPicker: View {
    // MARK: Properties
    @ObservedObject var viewModel: KidViewModel
    @Binding var selectedKidID: String?
    @Environment(\.presentationMode) var presentationMode

    
    // MARK: Body
    var body: some View {
        ZStack {
            Color.customNavyBlue.ignoresSafeArea(.all)
            VStack(alignment: .leading, spacing: 16) {
                Text("ASSIGN TO")
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                // MARK: Kid Options
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.kids) { kid in
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
                                .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
                // MARK: Fetching
                .onAppear {
                    viewModel.fetchKids()
                    }
                }

            }
        }
    }


