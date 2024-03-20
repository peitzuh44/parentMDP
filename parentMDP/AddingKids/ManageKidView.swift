//
//  ManageKidView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/19.
//

import SwiftUI

struct ManageKidView: View {
    @StateObject var viewModel = KidViewModel()
    @State var showAddKidSheet = true

    var body: some View {
        ZStack{
            List{
                ForEach(viewModel.kids) {
                    kid in
                    HStack{
                        Image("\(kid.gender)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                        Text(kid.name)
                            .foregroundStyle(Color.white)
                        Spacer()
                        Text("\(viewModel.calculateAge(birthday: kid.birthdate)) years old")
                            .foregroundStyle(Color.white)
                    }
                    .padding(.vertical, 8)
                    .listRowSeparator(.hidden)
                    .swipeActions (edge: .trailing, allowsFullSwipe: false) {
                        Button("Edit"){
                            
                        }
                        .tint(.blue)
                        Button("Delete"){
                            
                        }
                        .tint(.red)
                    }
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.customNavyBlue)
                        .padding(.vertical, 2)
                )
            }
            .onAppear() {
                // This fetches the kids from the database when we first load the add kids view
                viewModel.fetchKids()
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    ManageKidView()
}
