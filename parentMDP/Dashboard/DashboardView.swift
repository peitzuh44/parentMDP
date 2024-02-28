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
    @ObservedObject var kidVM = KidViewModel()
    @State private var selectedKid: KidModel?
    @State private var showKidDetail = false
    var body: some View {
        NavigationStack{
            ZStack{
                Color.customDarkBlue.ignoresSafeArea(.all)
                List{
                    // kid list section
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
                    // kid list section styling
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.customNavyBlue)
                            .padding(.vertical, 4)
                    )
                    // review section
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
                    
                    // Review Section Styling
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
                Text("level: \(kid.level)")
            }
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.vertical, 8)
        
        
        
    }
}

