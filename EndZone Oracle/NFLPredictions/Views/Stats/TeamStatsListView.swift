//
//  TeamStatsListView.swift
//  NFLPredictions
//
//  List view showing per-team statistics
//

import SwiftUI

struct TeamStatsListView: View {
    let teamStats: [TeamStats]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Team Performance")
                .font(.headline)
            
            if teamStats.isEmpty {
                Text("No team data available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                ForEach(teamStats.prefix(10)) { stat in
                    TeamStatRow(stat: stat)
                }
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

struct TeamStatRow: View {
    let stat: TeamStats
    
    private var team: NFLTeam? {
        NFLTeams.team(named: stat.teamName)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Team helmet
            if let team = team {
                Image(team.helmetAssetName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 30, height: 30)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(stat.teamName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                Text("\(stat.gamesPlayed) games")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "%.1f%%", stat.accuracy * 100))
                    .font(.headline)
                    .foregroundColor(accuracyColor(stat.accuracy))
                
                Text("±\(String(format: "%.1f", stat.avgPointError)) pts")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func accuracyColor(_ accuracy: Double) -> Color {
        if accuracy >= 0.7 { return .green }
        else if accuracy >= 0.5 { return .orange }
        else { return .red }
    }
}

#Preview {
    TeamStatsListView(teamStats: [
        TeamStats(teamName: "Pittsburgh Steelers", gamesPlayed: 5, correctPredictions: 4, accuracy: 0.8, avgPointError: 3.2),
        TeamStats(teamName: "Kansas City Chiefs", gamesPlayed: 4, correctPredictions: 3, accuracy: 0.75, avgPointError: 2.8),
        TeamStats(teamName: "Cincinnati Bengals", gamesPlayed: 6, correctPredictions: 3, accuracy: 0.5, avgPointError: 4.5),
    ])
    .padding()
}

