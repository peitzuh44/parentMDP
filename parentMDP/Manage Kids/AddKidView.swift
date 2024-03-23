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
    // MARK: Properties
    @StateObject var kidVM = KidViewModel()
    @Binding var authFlow: AuthFlow
    @State private var navigateToInviteKidView = false
    @State var showAddKidSheet = true
    
    // MARK: Body
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack{
                VStack{
                    // HEADER START
                    VStack(alignment: .leading){
                        Text("Add your kids")
                            .foregroundStyle(Color.white)
                            .font(.title2)
                            .bold()
                            .padding()
                    }
                    // HEADER END
                    
                    // List of Kids that have been added START
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
                            
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.customNavyBlue)
                                .padding(.vertical, 2)
                        )
                    }
                    
                    // MARK: Fetching
                    .onAppear() {
                        // This fetches the kids from the database when we first load the add kids view
                        kidVM.fetchKids()
                    }
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    // List of Kids that have been added END
                    
                    // MARK: Buttons
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
                        AddKidSheet(kidVM: kidVM)
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
