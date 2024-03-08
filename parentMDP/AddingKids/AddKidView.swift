//
//  AddKidView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//  Edited by Eric Tran on 2024/3/7
//
//  SUMMARY: This view allows you to add kids to your profile and proceed to the view of showing your add code so that the kids can add that code to their side of the app

import SwiftUI

struct AddKidView: View {
    @StateObject var viewModel = KidViewModel()
    @Binding var authFlow: AuthFlow
    @State private var navigateToInviteKidView = false
    @State var showAddKidSheet = false
    
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack{
                VStack{
                    // HEADER START
                    Text("Add your kids")
                        .foregroundStyle(Color.white)
                        .font(.title2)
                    // HEADER END
                    
                    // List of Kids that have been added START
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
                    // List of Kids that have been added END
                    
                    // Button to pull up the add kid sheet START
                    Button(action: {
                        showAddKidSheet = true
                    }){
                        Text("+")
                            .foregroundStyle(.white)
                            .frame(width: 330, height: 50)
                            .background(Color.customNavyBlue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .sheet(isPresented: $showAddKidSheet) {
                        AddKidSheet(viewModel: viewModel)
                            .presentationDetents([.height(750)])
                            .presentationDragIndicator(.hidden)
                    }
                    // Button to pull up the add kid sheet END
                }
                
                // Button for navigateToInviteKidView START
                Button(action:{
                    navigateToInviteKidView = true
                }){
                    Text("Next step")
                }
                .frame(width: 330, height: 50)
                .buttonStyle(ThreeD(backgroundColor: .customPurple, shadowColor: .black))
                .foregroundColor(.white)
                // Button for navigateToInviteKidView END
            }
            // Pushes the inviteKidView onto the navigation stack
            .navigationDestination(isPresented: $navigateToInviteKidView) {
                InviteKidView(authFlow: $authFlow)
            }
        }
        
    }
}
