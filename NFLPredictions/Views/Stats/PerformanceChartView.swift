//
//  PerformanceChartView.swift
//  NFLPredictions
//
//  Chart view for performance metrics
//

import SwiftUI
import Charts

struct PerformanceChartView: View {
    let results: [GameResultData]
    
    private var chartData: [ChartDataPoint] {
        var data: [ChartDataPoint] = []
        var correctCount = 0
        var totalCount = 0
        
        for (index, result) in results.enumerated() {
            if result.isCompleted {
                totalCount += 1
                if result.wasPredictionCorrect {
                    correctCount += 1
                }
                let accuracy = totalCount > 0 ? Double(correctCount) / Double(totalCount) : 0
                data.append(ChartDataPoint(gameNumber: index + 1, accuracy: accuracy * 100))
            }
        }
        
        return data
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Accuracy Over Time")
                .font(.headline)
            
            if chartData.isEmpty {
                Text("No data available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                Chart(chartData) { point in
                    LineMark(
                        x: .value("Game", point.gameNumber),
                        y: .value("Accuracy", point.accuracy)
                    )
                    .foregroundStyle(Color.blue.gradient)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Game", point.gameNumber),
                        y: .value("Accuracy", point.accuracy)
                    )
                    .foregroundStyle(Color.blue.opacity(0.1).gradient)
                    .interpolationMethod(.catmullRom)
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel {
                            if let intValue = value.as(Double.self) {
                                Text("\(Int(intValue))%")
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks { value in
                        AxisValueLabel()
                    }
                }
                .frame(height: 200)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let gameNumber: Int
    let accuracy: Double
}

#Preview {
    PerformanceChartView(results: [
        GameResultData(id: UUID(), team1Name: "Team A", team2Name: "Team B",
                      team1ActualScore: 24, team2ActualScore: 20,
                      team1PredictedScore: 24, team2PredictedScore: 20,
                      predictedWinner: "Team A", isCompleted: true),
        GameResultData(id: UUID(), team1Name: "Team C", team2Name: "Team D",
                      team1ActualScore: 17, team2ActualScore: 21,
                      team1PredictedScore: 20, team2PredictedScore: 17,
                      predictedWinner: "Team C", isCompleted: true),
    ])
    .padding()
}


