//
//  GameDetailView.swift
//  NFLPredictions
//
//  Detailed view of a single game prediction
//

import SwiftUI

struct GameDetailView: View {
    let prediction: Prediction
    let result: GameResultData?
    let timestamp: String
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataPersistenceService: DataPersistenceService
    
    @State private var showingResultEntry = false
    @State private var team1Score: Int
    @State private var team2Score: Int
    
    private var team1: NFLTeam? { NFLTeams.team(named: prediction.team1) }
    private var team2: NFLTeam? { NFLTeams.team(named: prediction.team2) }
    
    init(prediction: Prediction, result: GameResultData?, timestamp: String) {
        self.prediction = prediction
        self.result = result
        self.timestamp = timestamp
        
        // Initialize scores
        _team1Score = State(initialValue: result?.team1ActualScore ?? prediction.team1PredictedPoints)
        _team2Score = State(initialValue: result?.team2ActualScore ?? prediction.team2PredictedPoints)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Team headers
                VStack(spacing: 20) {
                    TeamHeaderView(
                        teamName: prediction.team1,
                        score: prediction.team1PredictedPoints,
                        isWinner: prediction.predictedWinner == prediction.team1,
                        size: .large
                    )
                    
                    ZStack {
                        Capsule()
                            .fill(Color.secondary.opacity(0.2))
                            .frame(width: 60, height: 30)
                        Text("VS")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                    }
                    
                    TeamHeaderView(
                        teamName: prediction.team2,
                        score: prediction.team2PredictedPoints,
                        isWinner: prediction.predictedWinner == prediction.team2,
                        size: .large
                    )
                }
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(16)
                
                // Prediction details
                VStack(alignment: .leading, spacing: 12) {
                    Text("Prediction Details")
                        .font(.headline)
                    
                    VStack(spacing: 10) {
                        InfoRow(label: "Point Differential", value: "\(abs(prediction.pointDifferential))")
                        InfoRow(label: "Total Points", value: "\(prediction.totalPoints)")
                        InfoRow(label: "Confidence", value: prediction.confidenceLevel.rawValue)
                        
                        if prediction.isTie {
                            HStack {
                                Text("Prediction")
                                    .foregroundColor(.secondary)
                                Spacer()
                                TieBadge()
                            }
                        }
                    }
                }
                .padding()
                .background(Color.cardBackground)
                .cornerRadius(16)
                
                // Results section
                if let result = result {
                    resultComparisonView(result)
                } else {
                    // Enter result button
                    Button(action: { showingResultEntry = true }) {
                        Label("Enter Game Result", systemImage: "pencil.circle.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Game Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingResultEntry) {
            ResultEntrySheet(
                prediction: prediction,
                timestamp: timestamp,
                team1Score: $team1Score,
                team2Score: $team2Score,
                onSave: {
                    dataPersistenceService.saveResult(
                        for: prediction,
                        team1Score: team1Score,
                        team2Score: team2Score,
                        timestamp: timestamp
                    )
                    showingResultEntry = false
                }
            )
        }
    }
    
    @ViewBuilder
    private func resultComparisonView(_ result: GameResultData) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Actual Results")
                    .font(.headline)
                Spacer()
                AccuracyIndicator(isCorrect: result.wasPredictionCorrect)
            }
            
            ComparisonTableView(prediction: prediction, result: result)
            
            // Edit button
            Button(action: { showingResultEntry = true }) {
                Label("Edit Result", systemImage: "pencil")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(16)
    }
}

struct ResultEntrySheet: View {
    let prediction: Prediction
    let timestamp: String
    @Binding var team1Score: Int
    @Binding var team2Score: Int
    let onSave: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(prediction.team1) {
                    Stepper("\(team1Score) points", value: $team1Score, in: 0...99)
                }
                
                Section(prediction.team2) {
                    Stepper("\(team2Score) points", value: $team2Score, in: 0...99)
                }
                
                Section {
                    HStack {
                        Text("Predicted:")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(prediction.team1) \(prediction.team1PredictedPoints) - \(prediction.team2PredictedPoints) \(prediction.team2)")
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Enter Result")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GameDetailView(
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
            timestamp: "20251014_160158"
        )
    }
    .environmentObject(DataPersistenceService())
}


