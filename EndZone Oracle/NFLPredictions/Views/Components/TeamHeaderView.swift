//
//  TeamHeaderView.swift
//  NFLPredictions
//
//  Component for displaying team with helmet and score
//

import SwiftUI

struct TeamHeaderView: View {
    let teamName: String
    let score: Int
    let isWinner: Bool
    let size: TeamHeaderSize
    
    private var team: NFLTeam? {
        NFLTeams.team(named: teamName)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Helmet image
            helmetImage
                .frame(width: size.helmetSize, height: size.helmetSize)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(teamName)
                    .font(size.nameFont)
                    .fontWeight(isWinner ? .bold : .semibold)
                    .foregroundColor(.primary)
                
                if let team = team {
                    Text(team.abbreviation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Score
            Text("\(score)")
                .font(size.scoreFont)
                .fontWeight(.bold)
                .foregroundColor(isWinner ? team?.primaryColor ?? .primary : .secondary)
            
            // Winner badge
            if isWinner {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
        }
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private var helmetImage: some View {
        if let team = team {
            Image(team.helmetAssetName)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            // Fallback placeholder
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                Image(systemName: "sportscourt.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(size.helmetSize * 0.25)
                    .foregroundColor(.gray)
            }
        }
    }
}

enum TeamHeaderSize {
    case small
    case medium
    case large
    
    var helmetSize: CGFloat {
        switch self {
        case .small: return 40
        case .medium: return 60
        case .large: return 80
        }
    }
    
    var nameFont: Font {
        switch self {
        case .small: return .subheadline
        case .medium: return .headline
        case .large: return .title2
        }
    }
    
    var scoreFont: Font {
        switch self {
        case .small: return .title3
        case .medium: return .largeTitle
        case .large: return .system(size: 60, weight: .bold)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        TeamHeaderView(teamName: "Pittsburgh Steelers", score: 24, isWinner: true, size: .large)
        TeamHeaderView(teamName: "Cincinnati Bengals", score: 20, isWinner: false, size: .medium)
        TeamHeaderView(teamName: "Kansas City Chiefs", score: 28, isWinner: true, size: .small)
    }
    .padding()
}

