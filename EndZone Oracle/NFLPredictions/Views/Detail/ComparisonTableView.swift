//
//  ComparisonTableView.swift
//  NFLPredictions
//
//  Table comparing predicted vs actual scores
//

import SwiftUI

struct ComparisonTableView: View {
    let prediction: Prediction
    let result: GameResultData
    
    var body: some View {
        VStack(spacing: 0) {
            // Header row
            HStack(spacing: 0) {
                Text("")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(prediction.team1)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .frame(width: 70)
                
                Text(prediction.team2)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .frame(width: 70)
                
                Text("Total")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .frame(width: 70)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color.secondary.opacity(0.1))
            
            Divider()
            
            // Predicted row
            comparisonRow(
                label: "Predicted",
                team1Value: prediction.team1PredictedPoints,
                team2Value: prediction.team2PredictedPoints,
                total: prediction.totalPoints,
                color: .blue
            )
            
            Divider()
            
            // Actual row
            comparisonRow(
                label: "Actual",
                team1Value: result.team1ActualScore,
                team2Value: result.team2ActualScore,
                total: result.team1ActualScore + result.team2ActualScore,
                color: .green
            )
            
            Divider()
            
            // Difference row
            differenceRow()
        }
        .background(Color.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private func comparisonRow(label: String, team1Value: Int, team2Value: Int, total: Int, color: Color) -> some View {
        HStack(spacing: 0) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(color)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(team1Value)")
                .font(.headline)
                .frame(width: 70)
            
            Text("\(team2Value)")
                .font(.headline)
                .frame(width: 70)
            
            Text("\(total)")
                .font(.headline)
                .fontWeight(.bold)
                .frame(width: 70)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
    }
    
    @ViewBuilder
    private func differenceRow() -> some View {
        let team1Diff = result.team1ActualScore - prediction.team1PredictedPoints
        let team2Diff = result.team2ActualScore - prediction.team2PredictedPoints
        let totalDiff = (result.team1ActualScore + result.team2ActualScore) - prediction.totalPoints
        
        HStack(spacing: 0) {
            Text("Difference")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            differenceText(team1Diff)
                .frame(width: 70)
            
            differenceText(team2Diff)
                .frame(width: 70)
            
            differenceText(totalDiff)
                .frame(width: 70)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(Color.secondary.opacity(0.05))
    }
    
    @ViewBuilder
    private func differenceText(_ value: Int) -> some View {
        let color: Color = value > 0 ? .green : (value < 0 ? .red : .secondary)
        let prefix = value > 0 ? "+" : ""
        
        Text("\(prefix)\(value)")
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(color)
    }
}

#Preview {
    ComparisonTableView(
        prediction: Prediction(
            team1: "Pittsburgh Steelers",
            team1PredictedPoints: 24,
            team2: "Cincinnati Bengals",
            team2PredictedPoints: 20,
            predictedWinner: "Pittsburgh Steelers",
            pointDifferential: 4,
            totalPoints: 44
        ),
        result: GameResultData(
            id: UUID(),
            team1Name: "Pittsburgh Steelers",
            team2Name: "Cincinnati Bengals",
            team1ActualScore: 27,
            team2ActualScore: 17,
            team1PredictedScore: 24,
            team2PredictedScore: 20,
            predictedWinner: "Pittsburgh Steelers",
            isCompleted: true
        )
    )
    .padding()
}

