//
//  KalshiOddsView.swift
//  NFLPredictions
//
//  View component for displaying Kalshi market odds
//

import SwiftUI

struct KalshiOddsView: View {
    let markets: [KalshiMarket]
    let prediction: Prediction

    var body: some View {
        // Just get first market with a price
        let marketWithPrice = markets.first { $0.midPrice != nil }

        guard let market = marketWithPrice, let probability = market.midPrice else {
            return AnyView(EmptyView())
        }

        // Determine which team the probability is for by checking yesSubtitle
        // Kalshi markets use format "Team A at Team B Winner?" where Yes = Team B wins (home team)
        var team1Prob: Double
        var team2Prob: Double

        if let yesSubtitle = market.yesSubtitle {
            // Check if yesSubtitle contains team1 or team2
            let team1City = TeamNameMapper.getCityName(for: prediction.team1).lowercased()
            let team2City = TeamNameMapper.getCityName(for: prediction.team2).lowercased()
            let yesTitleLower = yesSubtitle.lowercased()

            if yesTitleLower.contains(team1City) || yesTitleLower.contains(prediction.team1.lowercased()) {
                // Yes probability is for team1
                team1Prob = probability
                team2Prob = 1.0 - probability
            } else if yesTitleLower.contains(team2City) || yesTitleLower.contains(prediction.team2.lowercased()) {
                // Yes probability is for team2
                team1Prob = 1.0 - probability
                team2Prob = probability
            } else {
                // Fallback: parse market title to determine teams
                // Format is usually "Away at Home Winner?" where Yes = Home wins
                let titleLower = market.title.lowercased()
                if titleLower.contains(" at ") {
                    // Split by " at " to get away and home teams
                    let parts = titleLower.components(separatedBy: " at ")
                    if parts.count >= 2 {
                        let homePart = parts[1]

                        // Check which of our teams is home
                        if homePart.contains(team1City) {
                            // Team1 is home, yes probability is for team1
                            team1Prob = probability
                            team2Prob = 1.0 - probability
                        } else {
                            // Team2 is home, yes probability is for team2
                            team1Prob = 1.0 - probability
                            team2Prob = probability
                        }
                    } else {
                        // Can't determine, use default
                        team1Prob = probability
                        team2Prob = 1.0 - probability
                    }
                } else {
                    // Default fallback
                    team1Prob = probability
                    team2Prob = 1.0 - probability
                }
            }
        } else {
            // No yesSubtitle, try to parse market title
            let titleLower = market.title.lowercased()
            let team1City = TeamNameMapper.getCityName(for: prediction.team1).lowercased()
            let team2City = TeamNameMapper.getCityName(for: prediction.team2).lowercased()

            if titleLower.contains(" at ") {
                // Split by " at " to get away and home teams
                let parts = titleLower.components(separatedBy: " at ")
                if parts.count >= 2 {
                    let homePart = parts[1]

                    // Check which of our teams is home
                    if homePart.contains(team1City) {
                        // Team1 is home, yes probability is for team1
                        team1Prob = probability
                        team2Prob = 1.0 - probability
                    } else {
                        // Team2 is home, yes probability is for team2
                        team1Prob = 1.0 - probability
                        team2Prob = probability
                    }
                } else {
                    // Can't determine, use default
                    team1Prob = probability
                    team2Prob = 1.0 - probability
                }
            } else {
                // Default fallback
                team1Prob = probability
                team2Prob = 1.0 - probability
            }
        }

        // Calculate edge - our model's probability vs market
        let team1Points = Double(prediction.team1PredictedPoints)
        let team2Points = Double(prediction.team2PredictedPoints)
        let totalPoints = team1Points + team2Points
        let ourTeam1Prob = team1Points / totalPoints

        // Get market prob for our predicted winner
        let marketProbForWinner = prediction.predictedWinner == prediction.team1 ? team1Prob : team2Prob
        let ourProbForWinner = prediction.predictedWinner == prediction.team1 ? ourTeam1Prob : (1.0 - ourTeam1Prob)
        let edge = ourProbForWinner - marketProbForWinner

        return AnyView(VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack(spacing: 4) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.blue)
                    .font(.caption2)

                Text("Kalshi Market Odds")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)

                Spacer()
            }

            // Team odds display
            HStack(spacing: 12) {
                VStack(spacing: 4) {
                    Text(TeamNameMapper.getCityName(for: prediction.team1))
                        .font(.caption)
                        .fontWeight(.medium)

                    Text("\(Int(team1Prob * 100))%")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 4) {
                    Text(TeamNameMapper.getCityName(for: prediction.team2))
                        .font(.caption)
                        .fontWeight(.medium)

                    Text("\(Int(team2Prob * 100))%")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity)
            }

            // Edge indicator
            if edge > 0.05 {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)

                    Text("Odds are in our favor")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            } else if edge < -0.05 {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.caption)

                    Text("Pass harder than a kidney stone")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color.red.opacity(0.1))
                .cornerRadius(8)
            } else {
                HStack(spacing: 6) {
                    Image(systemName: "equal.circle.fill")
                        .foregroundColor(.orange)
                        .font(.caption)

                    Text("That juice ain't worth the squeeze")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4))
    }
}

struct EdgeIndicatorView: View {
    let edge: Double
    let prediction: Prediction

    var edgePercentage: String {
        let percent = abs(edge) * 100
        return String(format: "%.1f%%", percent)
    }

    var edgeColor: Color {
        if edge > 0.05 {
            return .green
        } else if edge < -0.05 {
            return .red
        } else {
            return .orange
        }
    }

    var edgeLabel: String {
        if edge > 0.05 {
            return "Our Model sees value betting on \(TeamNameMapper.getCityName(for: prediction.predictedWinner))"
        } else if edge < -0.05 {
            return "Market disagrees with our prediction"
        } else {
            return "Close to market consensus"
        }
    }

    var edgeIcon: String {
        if edge > 0.05 {
            return "checkmark.circle.fill"
        } else if edge < -0.05 {
            return "exclamationmark.triangle.fill"
        } else {
            return "equal.circle.fill"
        }
    }

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: edgeIcon)
                .foregroundColor(edgeColor)
                .font(.caption)

            VStack(alignment: .leading, spacing: 2) {
                Text(edgeLabel)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)

                Text("Edge: \(edge > 0 ? "+" : "")\(edgePercentage)")
                    .font(.caption2)
                    .foregroundColor(edgeColor)
                    .fontWeight(.semibold)
            }

            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(edgeColor.opacity(0.08))
        .cornerRadius(8)
    }
}

struct KalshiMarketDetailView: View {
    let market: KalshiMarket
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title
                VStack(alignment: .leading, spacing: 8) {
                    Text(market.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let subtitle = market.subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                // Probability
                VStack(alignment: .leading, spacing: 8) {
                    Text("Market Probability")
                        .font(.headline)
                    
                    if let prob = market.midPrice {
                        HStack {
                            Text("\(Int(prob * 100))%")
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                if let bid = market.yesBid, let ask = market.yesAsk {
                                    Text("Bid: ¢\(bid)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("Ask: ¢\(ask)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                
                Divider()
                
                // Market Details
                VStack(alignment: .leading, spacing: 12) {
                    Text("Market Details")
                        .font(.headline)
                    
                    DetailRow(label: "Status", value: market.status.capitalized)
                    
                    if let volume = market.volume {
                        DetailRow(label: "Volume", value: "\(volume)")
                    }
                    
                    if let openInterest = market.openInterest {
                        DetailRow(label: "Open Interest", value: "\(openInterest)")
                    }
                    
                    if let closeTime = market.closeTime {
                        DetailRow(label: "Closes", value: formatDate(closeTime))
                    }
                    
                    if let expirationTime = market.expirationTime {
                        DetailRow(label: "Expires", value: formatDate(expirationTime))
                    }
                }
                
                Divider()
                
                // Technical Info
                VStack(alignment: .leading, spacing: 8) {
                    Text("Technical Information")
                        .font(.headline)
                    
                    DetailRow(label: "Ticker", value: market.ticker)
                    DetailRow(label: "Event Ticker", value: market.eventTicker)
                }
            }
            .padding()
        }
        .navigationTitle("Market Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { dismiss() }
            }
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        return dateString
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}

// MARK: - Preview

#Preview {
    VStack {
        KalshiOddsView(
            markets: [
                KalshiMarket(
                    ticker: "NFL-TEST-01",
                    eventTicker: "NFL-TEST",
                    title: "Will the Chiefs win against the Raiders?",
                    subtitle: "Regular season game",
                    openTime: nil,
                    closeTime: nil,
                    expirationTime: nil,
                    status: "open",
                    yesSubtitle: "Chiefs win",
                    noSubtitle: "Raiders win",
                    yesBid: 65,
                    yesAsk: 67,
                    noBid: 33,
                    noAsk: 35,
                    lastPrice: 66,
                    volume: 1000,
                    openInterest: 500,
                    liquidityProbability: 0.66
                )
            ],
            prediction: Prediction(
                team1: "Kansas City Chiefs",
                team1PredictedPoints: 26,
                team2: "Las Vegas Raiders",
                team2PredictedPoints: 20,
                predictedWinner: "Kansas City Chiefs",
                pointDifferential: 6,
                totalPoints: 46
            )
        )
        .padding()
    }
}


