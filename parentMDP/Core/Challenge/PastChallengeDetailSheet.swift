//
//  PastChallengeDetailSheet.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/3/21.
//

import SwiftUI

struct PastChallengeDetailSheet: View {
    // MARK: Properties
    @Environment(\.presentationMode) var presentationMode
    let challenge: ChallengeModel

    // MARK: INIT
    init(challenge: ChallengeModel) {
        self.challenge = challenge
    }
    
    var body: some View {
        ZStack{
            Color.customDarkBlue.ignoresSafeArea(.all)
            VStack(alignment: .center){
                Text(challenge.name)
                    .font(.system(size: 24))
                    .bold()
                VStack(alignment: .leading){
                    Text("Comment and Feedback")
                    Text(challenge.comment ?? "no comment")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.customNavyBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                Text(challenge.due.formattedDate())
                
            }
            .foregroundStyle(.white)

        }
    }
}

