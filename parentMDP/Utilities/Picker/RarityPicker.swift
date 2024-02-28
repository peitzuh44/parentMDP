//
//  RarityPicker.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/15.
//

import SwiftUI

enum RarityOptions: String, CaseIterable {
    case common = "common"
    case rare = "rare"
    case epic = "epic"
    case legendary = "legendary"
    case mythic = "mythic"
    
    static func fromString(_ rarity: String) -> RarityOptions? {
        return RarityOptions(rawValue: rarity.capitalized)
    }
}

struct RarityPicker: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedRarity: RarityOptions
        var body: some View {
            ZStack {
                Color.customNavyBlue.ignoresSafeArea(.all)
                VStack (alignment: .leading){
                    Text("SELECT ROUTINE")
                        .foregroundColor(.white)
                        .font(.callout)
                        .padding(.horizontal, 10)
                    
                    ForEach(RarityOptions.allCases, id: \.self) { option in
                        Button(action: {
                            self.selectedRarity = option
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack (){
                                Text(emoji(for: option))
                                Text(option.rawValue).foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 24)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedRarity == option ? rarityColor(for: option) : Color.customDarkBlue)
                            )

                        }
                    }
                }
                .padding(.horizontal, 10)
            }
        }

        private func emoji(for routine: RarityOptions) -> String {
            switch routine {
            case .common:
                return "⚪️"
            case .rare:
                return "🔵"
            case .epic:
                return "🟢"
            case .legendary:
                return "🟠"
            case .mythic:
                return "🟣"
            }
        }
    private func rarityColor(for routine: RarityOptions) -> Color {
        switch routine {
        case .common:
            return .gray
        case .rare:
            return .blue
        case .epic:
            return .green
        case .legendary:
            return .orange
        case .mythic:
            return .customPurple
        }
    }
    
    }

