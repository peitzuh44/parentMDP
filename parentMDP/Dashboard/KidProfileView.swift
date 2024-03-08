//
//  KidView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI


struct KidProfileView: View {
    var kid: KidModel
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            ScrollView{
                VStack(spacing: 12){
                    //Assets
                    HStack(spacing: 18){
                        GoldTag(kid: kid)
                        GemTag(kid: kid)
           
                    }
                    KidInfoItem(kid: kid)
                    AvatarAttribute(kid: kid)
                    SkillBoard(kid: kid)
                    
                }
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
        }
    }
}

struct KidInfoItem: View {
    var kid: KidModel
    var body: some View {
        HStack(spacing: 2){
            Spacer()
            //Avatar Image
            Image(kid.avatarImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
                .padding(8)

            
            
            //exp bar
            VStack(alignment: .leading, spacing: 10){
                HStack(alignment: .bottom){
                    Text(kid.name)
                        .font(
                            Font.custom("inter", size: 22)
                                .weight(.bold)
                        )
                    Spacer()
                    Text("Level \(kid.level)")
                        .font(
                            Font.custom("inter", size: 16)
                                .weight(.bold)
                        )

                }
                .frame(width: 200)
                LinearProgressBar(width: 210, height: 10, percent: 50, color1: .pink, color2: .red)

                .padding(.trailing)
                
            }
        }
        .padding(.horizontal)
        .foregroundColor(.white)
        .frame(width: 350, height: 150)
        .background(
            Color.customNavyBlue
                .cornerRadius(20)        )
    }
}


struct StatsItem: View {
    @State private var image: String
    @State private var value: Int // shuold retrieve from the kidModel
    var body: some View {
        HStack(spacing: 0) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
            Text("\(value)")
                .bold()
        }
    }
}


struct SkillItem: View{
    @State var skills: String
    @State var level: Int
    @State var percentage: CGFloat
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .bottom){
                Text(skills)
                Spacer()
                Text("Lv. \(level)")
            }
            LinearProgressBar(width: 290, height:5, percent: percentage, color1: .blue, color2: .purple)
        }
        
        .padding()
        .foregroundColor(.white)
        
    }
}
struct SkillBoard: View {
    
    var kid: KidModel
    var body: some View {
        NavigationLink(destination: ManageSkillsView(kidID: kid.id)) {
            VStack(alignment: .leading){
                VStack(alignment: .leading, spacing: 0){
                    Text("Skills")
                        .font(.headline)
                        .padding(.top)
                        .padding(.horizontal)
                }
                VStack(alignment: .leading, spacing: 8){
                    SkillItem(skills: "Coding", level: 10, percentage: 20)
                    SkillItem(skills: "Basketball", level: 3, percentage: 40)
                    SkillItem(skills: "Writing", level: 2, percentage: 70)
                    SkillItem(skills: "Piano", level: 6, percentage: 80)
                    
                    
                }
                
            }
            .padding()
            .foregroundColor(.white)
            .frame(width: 350)
            .background(Color.customNavyBlue)
            .cornerRadius(20)
            
        }
    }
    
}

struct GoldTag: View {
    var kid: KidModel
    var body: some View {
        ZStack(alignment: .leading) {
            Text("\(kid.goldBalance)")
                .font(
                Font.custom("Inter", size: 14)
                .weight(.bold)
                )
                .foregroundColor(.white)
                .frame(width: 80, height: 30)
                .background(Color.customNavyBlue)
                .cornerRadius(5)
                .padding(.leading, 36)

            // gold image
            Image("gold")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 52, height: 52)
                .clipped()
        }
    }
}

struct GemTag: View {
    var kid: KidModel
    var body: some View {
        ZStack(alignment: .leading) {
            Text("\(kid.gemBalance)")
                .font(
                Font.custom("Inter", size: 14)
                .weight(.bold)
                )
                .foregroundColor(.white)
                .frame(width: 80, height: 30)
                .background(Color.customNavyBlue)
                .cornerRadius(5)
                .padding(.leading, 36)

            // gem image
            Image("gem")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 52, height: 52)
                .clipped()
        }
    }
}


struct AvatarAttribute: View {
    var kid: KidModel

    var body: some View {
        HStack{
            Spacer()
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5){
                Image("hp")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipped()
                Text("\(kid.hp)")
            }
            Spacer()
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5){
                Image("attack")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipped()
                Text("\(kid.attack)")
            }
            Spacer()

            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5){
                Image("defense")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipped()
                Text("\(kid.defense)")
            }
            Spacer()

            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5){
                Image("magic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipped()
                Text("\(kid.magic)")
            }
            Spacer()

        }
        .padding(.horizontal)
        .foregroundColor(.white)
        .frame(width: 350, height: 120)
        .background(
            Color.customNavyBlue
            
            
                .cornerRadius(20)        )
    }
}

