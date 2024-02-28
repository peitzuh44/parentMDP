//
//  KidSelector.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/14.
//

import SwiftUI


//struct TaskViewKidSelector: View {
//    
//    func name(for selectedKidID: String?) -> String? {
//        guard let selectedKidID = selectedKidID else { return nil }
//        return viewModelKid.kids.first { $0.id == selectedKidID }?.name
//    }
//        var body: some View {
//            HStack(spacing: 2){
//                Spacer()
//                Image("avatar1")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 80)
//                    .padding(8)
//                
//                VStack(alignment: .leading, spacing: 8){
//                    Text("Pei")
//                        .font(.title2)
//                    
//                    VStack(alignment: .leading, spacing: 8){
//                        LinearProgressBar(width: 220, height: 8, percent: 80, color1: .yellow, color2: .orange)
//                        HStack{
//                            Text("Daily progress")
//                            Spacer()
//                            Text("8/10")
//                        }
//                        .font(.caption)
//                        
//                    }
//                    .padding(.trailing)
//                }
//                
//                Spacer()
//                
//            }
//            .foregroundColor(.white)
//            .frame(height: 130)
//            .background(
//                Color.customNavyBlue
//                    .cornerRadius(20)        )
//        }
//    }
//




struct ChallengeViewKidSelector: View {
    @ObservedObject var kidVM: KidViewModel
    
    func name(for selectedKidID: String?) -> String? {
        guard let selectedKidID = selectedKidID else { return nil }
        return kidVM.kids.first { $0.id == selectedKidID }?.name
    }
    @Environment(\.presentationMode) var presentationMode
    @State var selectedKidID: String
    @Binding var showKidSelector: Bool
    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
            showKidSelector = true
        }){
            HStack{
                Spacer()
                // Name + Image
                VStack(spacing: 8){
                    //avatar image
                    Image("avatar1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60)
                        .padding(.horizontal, 8)
                    Text(self.name(for: selectedKidID) ?? "Select kid")
                        .font(.callout)
                }
                Spacer()
                HStack(spacing: 24) {
                    // Ongoing Challenge
                    VStack(alignment: .center, spacing: 2) {
                        Text("7")
                            .font(.title)
                            .bold()
                        Text("ongoing")
                    }
                    // Completed Challenge
                    VStack(alignment: .center, spacing: 2) {
                        Text("7")
                            .font(.title)
                            .bold()
                        Text("completed")
                    }
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 130)
            .background(
                Color.customNavyBlue
                    .cornerRadius(20)
            )
            .padding(.horizontal)
            
        }
    }
    
    
}
