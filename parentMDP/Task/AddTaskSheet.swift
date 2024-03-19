//
//  AddTaskSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI

struct AddTaskSheet: View {
    // MARK: Properties
    @Environment(\.presentationMode) var presentationMode
    @Binding var showAddPrivateTaskSheet: Bool
    @Binding var showAddPublicTaskSheet: Bool
    
    // MARK: Body

    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            HStack(spacing: 24){
                Button(action:{
                    presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showAddPrivateTaskSheet = true
                    }
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius:10)
                            .frame(width: 140, height: 140)
                            .foregroundColor(.customNavyBlue)
                        
                        VStack(spacing: 8){
                            Image("single")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80)
                            Text("individual")
                            
                        }
                        .foregroundColor(.white)
                        
                        
                    }
                }
                Button(action:{
                    presentationMode.wrappedValue.dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showAddPublicTaskSheet = true
                    }
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius:10)
                            .frame(width: 140, height: 140)
                            .foregroundColor(.customNavyBlue)
                        VStack(spacing: 8){
                            Image("group")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80)
                            Text("for everyone")
                            
                        }
                        .foregroundColor(.white)
                        
                    }
                }
            }
        }    }
}
