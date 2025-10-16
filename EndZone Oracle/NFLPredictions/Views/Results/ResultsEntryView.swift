//
//  ResultsEntryView.swift
//  NFLPredictions
//
//  View for bulk entry of game results
//

import SwiftUI

struct ResultsEntryView: View {
    @ObservedObject var viewModel: ResultsViewModel
    let predictions: [Prediction]
    let timestamp: String
    
    @Environment(\.dismiss) var dismiss
    
    init(predictions: [Prediction], timestamp: String) {
        self.predictions = predictions
        self.timestamp = timestamp
        self.viewModel = ResultsViewModel()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text("Enter the actual scores for each game")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                ForEach(predictions) { prediction in
                    Section {
                        VStack(alignment: .leading, spacing: 12) {
                            // Game header
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(prediction.team1) vs \(prediction.team2)")
                                    .font(.headline)
                                
                                Text("Predicted: \(prediction.team1PredictedPoints)-\(prediction.team2PredictedPoints)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            // Score pickers
                            if let scores = viewModel.getScore(for: prediction.id) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(prediction.team1)
                                            .font(.caption)
                                        Stepper("\(scores.team1)", value: Binding(
                                            get: { scores.team1 },
                                            set: { newValue in
                                                viewModel.updateScore(
                                                    for: prediction.id,
                                                    team1Score: newValue,
                                                    team2Score: scores.team2
                                                )
                                            }
                                        ), in: 0...99)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing) {
                                        Text(prediction.team2)
                                            .font(.caption)
                                        Stepper("\(scores.team2)", value: Binding(
                                            get: { scores.team2 },
                                            set: { newValue in
                                                viewModel.updateScore(
                                                    for: prediction.id,
                                                    team1Score: scores.team1,
                                                    team2Score: newValue
                                                )
                                            }
                                        ), in: 0...99)
                                    }
                                }
                            }
                            
                            // Status indicator
                            if viewModel.hasResult(for: prediction) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Saved")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Enter Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save All") {
                        viewModel.saveAllResults()
                        dismiss()
                    }
                }
            }
            .onAppear {
                viewModel.loadPredictions(predictions, timestamp: timestamp)
            }
        }
    }
}

#Preview {
    ResultsEntryView(
        predictions: [
            Prediction(
                team1: "Pittsburgh Steelers",
                team1PredictedPoints: 24,
                team2: "Cincinnati Bengals",
                team2PredictedPoints: 20,
                predictedWinner: "Pittsburgh Steelers",
                pointDifferential: 4,
                totalPoints: 44
            )
        ],
        timestamp: "20251014_160158"
    )
}

