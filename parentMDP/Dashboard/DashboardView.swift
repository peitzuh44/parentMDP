//
//  DashboardView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct DashboardView: View {
    
    //MARK: Properties
    @ObservedObject var kidVM = KidViewModel()
    @State private var selectedKid: KidModel?
    @State private var showKidDetail = false
    
    // MARK: Body
    var body: some View {
        NavigationStack{
            ZStack{
                Color.customDarkBlue.ignoresSafeArea(.all)
                
                List{
                    // MARK: Kid Section
                    Section{
                        ForEach(kidVM.kids) { kid in
                            NavigationLink(value: kid) {
                                KidListItem(kid: kid)
                            }
                        }
                    } header:{
                        Text("My Kids")
                            .foregroundColor(.white)
                            .bold()
                    }
                    // kid list styling
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.customNavyBlue)
                            .padding(.vertical, 4)
                    )
                    // MARK: Action Buttons Section
                    Section{
                        //review task navigation link
                        Button(action:
                                {
                            
                        }){
                            HStack{
                                Image(systemName: "checkmark.square.fill")
                                Text("2 tasks to review")
                                Spacer()
                                Image(systemName: "arrow.right")
                            }
                            .foregroundColor(.white)
                        }
                        .padding(.vertical)
                        
                        //review gift navigation link
                        Button(action:
                                {
                            
                        }){
                            HStack{
                                Image(systemName: "gift")
                                Text("2 rewards redeemed")
                                Spacer()
                                Image(systemName: "arrow.right")
                            }
                            .foregroundColor(.white)
                        }
                        .padding(.vertical)
                    }
                    
                    // Action Button Section Styling
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.customNavyBlue)
                            .padding(.vertical, 4))
                    
                }
                .scrollContentBackground(.hidden)
                .onAppear {
                    kidVM.fetchKids()
                }
                .navigationDestination(for: KidModel.self) { kid in
                    KidProfileView(kid: kid)
                }
            }
        }
    }
}
  

// MARK: Kid List Item
struct KidListItem: View {
    var kid: KidModel
    var body: some View {
        HStack(spacing: 16){
            //Avatar Gif
            Image(kid.avatarImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 70)
            VStack(alignment: .leading, spacing: 4){
                Text(kid.name)
                    .font(.title2)
                    .bold()
            }
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.vertical, 8)
        
        
        
    }
}

