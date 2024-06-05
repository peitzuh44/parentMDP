//
//  KidView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/8.
//

import SwiftUI
import FirebaseAuth

struct KidProfileView: View {
    // MARK: Properties
    @ObservedObject var challengeVM: ChallengeViewModel
    @ObservedObject var kidVM: KidViewModel
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    var kid: KidModel
    
    func fetchChallengesForRecentChallengeBoard() {
        let config = FetchChallengesConfig(
            userID: currentUserID,
            status: "complete",
            selectedKidID: kid.id,
            criteria: [
                .assignTo(kid.id),
                .status("complete")
            ],
            sortOptions: [
                .dateCompleted(ascending: false)
            ],
            limit: 3
        )
        
        challengeVM.fetchChallenges(withConfig: config)
    }
    
    func fetchTopSkills() {
        let config = FetchSkillsConfig(
            kidID: kid.id,
            criteria: [
                .createdBy(currentUserID)
                
            ],
            sortOptions: [
                .exp(ascending: false)
            ],
            limit: 3)
        kidVM.fetchSkills(withConfig: config)
    }
    
    
    // MARK: Body
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            ScrollView{
                VStack(spacing: 12){
                    // MARK: Assets
                    HStack(spacing: 18){
                        GoldTag(kid: kid)
                        GemTag(kid: kid)
           
                    }
                    KidInfoItem(kid: kid)
                    AvatarAttribute(kid: kid)
                    SkillBoard(kidVM: kidVM, kid: kid)
                    RecentChallengeBoard(challengeVM: challengeVM, kid: kid)
                    
                }
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        
        // MARK: Fetching
        .onAppear{
            fetchChallengesForRecentChallengeBoard()
            fetchTopSkills()
        }


    }
}


// MARK: Kid Info Item
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



// MARK: AttributeItem
struct AttributeItem: View {
    @State private var image: String
    @State private var value: Int // should retrieve from the kidModel
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



// MARK: Skills Board


struct SkillItem: View {
    let skill: SkillModel
    let text: String
    let level: Int
    let progress: CGFloat
    var body: some View {
        HStack{
            Image("attack")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40)
            VStack(alignment: .leading){
                HStack(spacing: 8){
                    Text(skill.name)
                    Spacer()
                    Text("Lv\(level)")
                }
                LinearProgressBar(width: 270, height: 10, percent: calculateProgress(exp: skill.exp), color1: .blue, color2: .purple)
                    .onAppear()
                    .animation(.linear, value: 1)

            }
            Spacer()
        }
        .foregroundStyle(Color.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.customNavyBlue)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
}

struct SkillBoard: View {
    @ObservedObject var kidVM: KidViewModel
    var kid: KidModel
    var body: some View {
        NavigationLink(destination: ManageSkillsView(kidID: kid.id)) {
            VStack (alignment: .leading, spacing: 8){
                Text("Top 3 Skills")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.white)
                    .bold()
                if kidVM.skills.isEmpty {
                    VStack {
                        Spacer()
                        Text("No skills added yet")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.customNavyBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Spacer()
                    }
                }
                else{
                    
                    ForEach(kidVM.skills) {
                        skill in
                        let (level, progress) = calculateLevelAndProgress(forExp: skill.exp)
                        SkillItem(skill: skill, text: skill.name, level: level, progress: CGFloat(progress))
                    }
                    
                }

            }
            .padding()
        }
    
    }
}

// MARK: Currency Tags
struct GoldTag: View {
    var kid: KidModel
    var body: some View {
        ZStack(alignment: .leading) {
            Text("\(kid.coinBalance)")
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



// MARK: Attributes
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
                Text("\(kid.health)")
            }
            Spacer()
            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5){
                Image("attack")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipped()
                Text("\(kid.mental)")
            }
            Spacer()

            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5){
                Image("defense")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipped()
                Text("\(kid.social)")
            }
            Spacer()

            VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 5){
                Image("magic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipped()
                Text("\(kid.intelligence)")
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

// MARK: Recent Challenge
struct RecentChallengeBoard: View {
    @ObservedObject var challengeVM: ChallengeViewModel
    var kid: KidModel

    var body: some View {
        NavigationLink(destination: PastChallengeView(challengeVM: challengeVM, kid: kid)){
            VStack(alignment: .leading){
                Text("Recent Challenge")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .padding(.top)
                    .padding(.horizontal)
                if challengeVM.challenges.isEmpty {
                    // Display message when no tasks are available
                    VStack {
                        Spacer()
                        Text("No challenge completed yet!")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.customNavyBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        Spacer()
                    }
                } else{
                    ForEach(challengeVM.challenges){challenge in
                        CompleteChallengeListItem(challenge: challenge)
                        
                    }
                }

            }
            .padding()
            
        }
    }
}

struct CompleteChallengeListItem: View {
    let challenge: ChallengeModel
    
    var body: some View {
        HStack{
            HStack{
                Image("challenge")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36)
                VStack(alignment: .leading){
                    Text(challenge.name)
                    Text("Completed on \(challenge.dateCompleted?.formattedDate() ?? "")")
                        .font(.caption)
                }
            }
            Spacer()
        }
        .foregroundStyle(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.customNavyBlue)
        .clipShape(RoundedRectangle(cornerRadius: 20))

    }
}

// MARK: TODOs
/*
 1. Board displaying recent chllange and past challenge view
 2. Display recent jornal entry of the kids
 */
