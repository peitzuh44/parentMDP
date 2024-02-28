//
//  MainView.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/13.
//

import SwiftUI

struct MainView: View {
    @Binding var authFlow: AuthFlow

    var body: some View {
        TabView {
                DashboardView()
                       .tabItem {
                           Image(systemName: "person.crop.circle")
                           Text("Dashboard")
                       }
                TaskView()
                       .tabItem {
                           Image(systemName: "checklist")
                           Text("Quests")
                       }
               RewardView()
                   .tabItem{
                       Image(systemName: "gift")
                       Text("Reward")

                   }
                ChallengeView()
                   .tabItem {
                       Image(systemName: "star.square")
                       Text("Challenges")
                   }
            
               }
           }
    }

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(authFlow: .constant(.authenticated))
    }
}
