//
//  AddKidView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI

struct AddKidView: View {
    @StateObject var viewModel = KidViewModel()
    @Binding var authFlow: AuthFlow
    @State private var navigateToInviteKidView = false
//    let birthdate = kid.birthdate.dateValue()

    @State var showAddKidSheet = false
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack{
                VStack{
                    Text("Add your kids")
                        .foregroundStyle(Color.white)
                        .font(.title2)
                    
                    // Kid added - fetch kid according to parent
                    List{
                        ForEach(viewModel.kids) {
                            kid in
                            HStack{
                                HStack{
                                    Image("\(kid.gender)")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50)
                                    Text(kid.name)
                                        .foregroundStyle(Color.white)
                                }
                                Spacer()
                                Text("10 yrs")
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
                        viewModel.fetchKids()
                    }
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    
                    // Add Kid button
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
                }
                Button(action:{
                    navigateToInviteKidView = true
                }){
                    Text("Next step")
                }
                .frame(width: 330, height: 50)
                .buttonStyle(ThreeD(backgroundColor: .customPurple, shadowColor: .black))
                .foregroundColor(.white)
                
                
            }
            .sheet(isPresented: $showAddKidSheet) {
                AddKidSheet(viewModel: viewModel)
                    .presentationDetents([.height(750)])
                    .presentationDragIndicator(.hidden)
            }
            NavigationLink(destination: InviteKidView(authFlow: $authFlow), isActive: $navigateToInviteKidView) { EmptyView() }

        }
        
    }
}
