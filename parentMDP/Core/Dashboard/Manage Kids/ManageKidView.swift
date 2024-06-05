//
//  ManageKidView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/19.
//

import SwiftUI

struct ManageKidView: View {
    
    // MARK: Properties
    @ObservedObject var kidVM = KidViewModel() 
    @State private var selectedKid: KidModel?
    @State var showAddKidSheet = false
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false

    // MARK: Body
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack{
                List{
                    ForEach(kidVM.kids) {
                        kid in
                        HStack{
                            Image("\(kid.gender)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50)
                            Text(kid.name)
                                .foregroundStyle(Color.white)
                            Spacer()
                            Text("\(kidVM.calculateAge(birthdate: kid.birthdate)) years old")
                                .foregroundStyle(Color.white)
                        }
                        .padding(.vertical, 8)
                        .listRowSeparator(.hidden)
                        
                        // MARK: List swipe aciton
                        .swipeActions (edge: .trailing, allowsFullSwipe: false) {
                            Button("Edit"){
                                selectedKid = kid
                                showEditSheet = true
                            }
                            .tint(.blue)
                            Button("Delete"){
                                showDeleteAlert = true
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
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)

            }
            // MARK: Fetching
            .onAppear() {
                kidVM.fetchKids()
            }
            // MARK: Sheets and alerts
            .sheet(isPresented: $showAddKidSheet) {
                AddKidSheet(kidVM: kidVM)
                    .presentationDetents([.large])
                    .presentationDragIndicator(.hidden)
            }
            .sheet(isPresented: Binding(
                get: { showEditSheet },
                set: { showEditSheet = $0 }
            )) {
                if let kid = selectedKid{
                    EditKidSheet(selectedKid: kid, kidVM: kidVM)
                        .presentationDetents([.large])
                        .presentationDragIndicator(.hidden)
                }
                
            }

            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Kid"),
                    message: Text("Are you sure you want to delete this kid?"),
                    primaryButton: .destructive(Text("Delete"), action: {
                        if let kidID = selectedKid?.id {
                            kidVM.deleteKid(kidID: kidID)
                        }
                    }),
                    secondaryButton: .cancel()
                )
            }

        }
        .toolbar{
            ToolbarItem(placement: .principal) {
                Text("Manage Kids")
                    .foregroundStyle(.white)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showAddKidSheet = true
                }){
                    Text("+")
                        .font(.title2)
                }
                .padding(.horizontal)
                

            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)

    }
}
