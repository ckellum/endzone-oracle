//
//  PredictionHeaderView.swift
//  NFLPredictions
//
//  Header view with model info and statistics summary
//

import SwiftUI

struct PredictionHeaderView: View {
    let modelVersion: String
    let timestamp: String
    let statistics: PredictionStatistics?
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and metadata
            VStack(alignment: .leading, spacing: 4) {
                Text("NFL Predictions")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack(spacing: 8) {
                    Image(systemName: "brain.head.profile")
                        .font(.caption)
                    Text(modelVersion)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(formattedTimestamp)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Statistics card
            if let stats = statistics {
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Model Statistics", systemImage: "chart.bar.fill")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .font(.caption)
                        }
                        
                        if !isExpanded {
                            // Summary view
                            HStack(spacing: 20) {
                                VStack(alignment: .leading) {
                                    Text("\(stats.totalGames)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text("Games")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(String(format: "%.1f", stats.avgTotalPoints))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text("Avg Points")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("\(stats.maxSpread)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text("Max Spread")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        } else {
                            // Detailed view
                            VStack(spacing: 8) {
                                InfoRow(label: "Total Games", value: "\(stats.totalGames)")
                                InfoRow(label: "Avg Total Points", value: String(format: "%.1f", stats.avgTotalPoints))
                                InfoRow(label: "Point Range", value: "\(stats.minTotalPoints)-\(stats.maxTotalPoints)")
                                InfoRow(label: "Avg Differential", value: String(format: "%.1f", stats.avgPointDifferential))
                                InfoRow(label: "Max Spread", value: "\(stats.maxSpread)")
                                InfoRow(label: "Games with Ties", value: "\(stats.gamesWithTies)")
                                InfoRow(label: "40-50 Point Games", value: "\(stats.games4050Points)")
                                InfoRow(label: "Outliers Detected", value: "\(stats.outliersDetected)")
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var formattedTimestamp: String {
        // Parse timestamp like "20251014_160158" to readable format
        let ts = timestamp.replacingOccurrences(of: "_", with: " ")
        return "Updated: \(ts)"
    }
}

#Preview {
    PredictionHeaderView(
        modelVersion: "EnhancedNFLPredictionModel_v1.0",
        timestamp: "20251014_160158",
        statistics: PredictionStatistics(
            totalGames: 15,
            outliersDetected: 0,
            avgTotalPoints: 45.4,
            minTotalPoints: 38,
            maxTotalPoints: 56,
            avgPointDifferential: 3.0,
            maxSpread: 10,
            gamesWithTies: 2,
            games4050Points: 10
        )
    )
    .padding()
}


