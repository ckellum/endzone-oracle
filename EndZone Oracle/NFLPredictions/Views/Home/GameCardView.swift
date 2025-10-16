//
//  GameCardView.swift
//  NFLPredictions
//
//  Card view for displaying a single game prediction
//

import SwiftUI

struct GameCardView: View {
    let prediction: Prediction
    let result: GameResultData?
    var kalshiMarkets: [KalshiMarket]? = nil
    var showKalshiPlaceholder: Bool = false
    let onTap: () -> Void
    
    private var team1: NFLTeam? { NFLTeams.team(named: prediction.team1) }
    private var team2: NFLTeam? { NFLTeams.team(named: prediction.team2) }
    
    private var accentColor: Color {
        if let team = team1, prediction.predictedWinner == prediction.team1 {
            return team.primaryColor
        } else if let team = team2, prediction.predictedWinner == prediction.team2 {
            return team.primaryColor
        }
        return .gray
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Team 1
                teamRow(
                    teamName: prediction.team1,
                    score: prediction.team1PredictedPoints,
                    isWinner: prediction.predictedWinner == prediction.team1,
                    team: team1
                )
                
                // VS Divider
                HStack {
                    Rectangle()
                        .fill(Color.secondary.opacity(0.3))
                        .frame(height: 1)
                    
                    Text("vs")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.cardBackground)
                        .cornerRadius(12)
                    
                    Rectangle()
                        .fill(Color.secondary.opacity(0.3))
                        .frame(height: 1)
                }
                .padding(.vertical, 8)
                
                // Team 2
                teamRow(
                    teamName: prediction.team2,
                    score: prediction.team2PredictedPoints,
                    isWinner: prediction.predictedWinner == prediction.team2,
                    team: team2
                )
                
                // Info section
                VStack(spacing: 8) {
                    Divider()
                        .padding(.vertical, 4)
                    
                    HStack(spacing: 16) {
                        // Point differential
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.left.arrow.right")
                                .font(.caption)
                            Text("Diff: \(abs(prediction.pointDifferential))")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                        
                        // Total points
                        HStack(spacing: 4) {
                            Image(systemName: "sum")
                                .font(.caption)
                            Text("Total: \(prediction.totalPoints)")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        // Confidence badge
                        ConfidenceBadge(confidence: prediction.confidenceLevel)
                    }
                    
                    // Result section (if game completed)
                    if let result = result {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Actual: \(result.team1Name)")
                                    .font(.caption)
                                Spacer()
                                Text("\(result.team1ActualScore)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            
                            HStack {
                                Text(result.team2Name)
                                    .font(.caption)
                                Spacer()
                                Text("\(result.team2ActualScore)")
                                    .font(.caption)
                                    .fontWeight(.bold)
                            }
                            
                            AccuracyIndicator(isCorrect: result.wasPredictionCorrect)
                                .padding(.top, 4)
                        }
                        .padding(.top, 8)
                        .padding(.horizontal, 4)
                    }
                    
                    // Kalshi odds section (if available)
                    if let markets = kalshiMarkets, !markets.isEmpty {
                        Divider()
                            .padding(.vertical, 4)

                        KalshiOddsView(markets: markets, prediction: prediction)
                    } else if showKalshiPlaceholder {
                        Divider()
                            .padding(.vertical, 4)

                        KalshiPlaceholderView()
                    }
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(accentColor.opacity(0.3), lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private func teamRow(teamName: String, score: Int, isWinner: Bool, team: NFLTeam?) -> some View {
        HStack(spacing: 12) {
            // Helmet
            if let team = team {
                Image(team.helmetAssetName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            } else {
                // Fallback
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: "sportscourt.fill")
                        .foregroundColor(.gray)
                }
            }
            
            // Team name
            VStack(alignment: .leading, spacing: 2) {
                Text(teamName)
                    .font(.headline)
                    .fontWeight(isWinner ? .bold : .semibold)
                    .foregroundColor(.primary)
                
                if let team = team {
                    Text(team.abbreviation)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Score
            Text("\(score)")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(isWinner ? (team?.primaryColor ?? .primary) : .secondary)
            
            // Pick badge
            if isWinner && !prediction.isTie {
                PickBadge()
            } else if prediction.isTie {
                TieBadge()
            }
        }
    }
}

struct KalshiPlaceholderView: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .foregroundColor(.orange.opacity(0.7))
                .font(.caption)

            VStack(alignment: .leading, spacing: 4) {
                Text("Kalshi Market")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)

                Text("Loading odds data...")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

#Preview {
    VStack(spacing: 16) {
        GameCardView(
            prediction: Prediction(
                team1: "Pittsburgh Steelers",
                team1PredictedPoints: 24,
                team2: "Cincinnati Bengals",
                team2PredictedPoints: 20,
                predictedWinner: "Pittsburgh Steelers",
                pointDifferential: 4,
                totalPoints: 44
            ),
            result: nil,
            onTap: {}
        )
        
        GameCardView(
            prediction: Prediction(
                team1: "Kansas City Chiefs",
                team1PredictedPoints: 28,
                team2: "Las Vegas Raiders",
                team2PredictedPoints: 20,
                predictedWinner: "Kansas City Chiefs",
                pointDifferential: 8,
                totalPoints: 48
            ),
            result: GameResultData(
                id: UUID(),
                team1Name: "Kansas City Chiefs",
                team2Name: "Las Vegas Raiders",
                team1ActualScore: 30,
                team2ActualScore: 17,
                team1PredictedScore: 28,
                team2PredictedScore: 20,
                predictedWinner: "Kansas City Chiefs",
                isCompleted: true
            ),
            onTap: {}
        )
    }
    .padding()
    .background(Color.appBackground)
}

