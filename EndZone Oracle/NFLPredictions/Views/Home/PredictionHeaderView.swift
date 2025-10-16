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
            // Logo centered
            HStack {
                Spacer()

                Image("AppLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 160)
                    .cornerRadius(20)
                    .shadow(radius: 5)

                Spacer()
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

