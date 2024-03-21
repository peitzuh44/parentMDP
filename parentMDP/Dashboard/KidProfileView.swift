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
    @ObservedObject var challengeVM = ChallengeViewModel()
    let currentUserID = Auth.auth().currentUser?.uid ?? ""
    var kid: KidModel
    
    
    func fetchChallengesForRecentChallengeBoard() {
        let config = FetchChallengesConfig(
            userID: currentUserID,
            status: "complete",
            selectedKidID: kid.id,
            criteria: [
                .assignTo(kid.id),
                .createdBy(currentUserID),
                .status("complete")
            ],
            sortOptions: [
                .dateCompleted(ascending: true)
            ],
            limit: 3 // or specify a limit for cases like recent completions
        )
        
        challengeVM.fetchChallenges(withConfig: config)
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
                    SkillBoard(kid: kid)
                    RecentChallengeBoard(challengeVM: challengeVM)
                    
                }
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
        }
        .onAppear{
            fetchChallengesForRecentChallengeBoard()

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
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Recent Challenge")
                .font(.headline)
                .padding(.top)
                .padding(.horizontal)
            ForEach(challengeVM.challenges){challenge in
                RecentChallengeBoardItem(challenge: challenge)
                
            }
        }
        .background(Color.customNavyBlue)

    }
}

struct RecentChallengeBoardItem: View {
    let challenge: ChallengeModel
    let name: String = "Challenge name"
    let dateComplete: String = "02/11/2024"
    var body: some View {
        HStack{
            HStack{
                Image("challenge")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36)
                VStack{
                    Text(challenge.name)
                    Text("Completed on \(dateComplete)")
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
 */
