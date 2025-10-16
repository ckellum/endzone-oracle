//
//  ResultsViewModel.swift
//  NFLPredictions
//
//  ViewModel for entering game results
//

import Foundation

class ResultsViewModel: ObservableObject {
    @Published var dataPersistenceService: DataPersistenceService
    @Published var predictions: [Prediction] = []
    @Published var timestamp: String = ""
    
    // Temporary storage for scores being entered
    @Published var scores: [UUID: (team1: Int, team2: Int)] = [:]
    
    init(dataPersistenceService: DataPersistenceService = DataPersistenceService()) {
        self.dataPersistenceService = dataPersistenceService
    }
    
    func loadPredictions(_ predictions: [Prediction], timestamp: String) {
        self.predictions = predictions
        self.timestamp = timestamp
        
        // Initialize scores with existing results or predicted values
        for prediction in predictions {
            if let result = dataPersistenceService.getResult(for: prediction, timestamp: timestamp) {
                scores[prediction.id] = (result.team1ActualScore, result.team2ActualScore)
            } else {
                scores[prediction.id] = (prediction.team1PredictedPoints, prediction.team2PredictedPoints)
            }
        }
    }
    
    func updateScore(for predictionId: UUID, team1Score: Int, team2Score: Int) {
        scores[predictionId] = (team1Score, team2Score)
    }
    
    func saveResult(for prediction: Prediction) {
        guard let (team1Score, team2Score) = scores[prediction.id] else { return }
        dataPersistenceService.saveResult(
            for: prediction,
            team1Score: team1Score,
            team2Score: team2Score,
            timestamp: timestamp
        )
    }
    
    func saveAllResults() {
        for prediction in predictions {
            saveResult(for: prediction)
        }
    }
    
    func getScore(for predictionId: UUID) -> (team1: Int, team2: Int)? {
        return scores[predictionId]
    }
    
    func hasResult(for prediction: Prediction) -> Bool {
        return dataPersistenceService.getResult(for: prediction, timestamp: timestamp) != nil
    }
}


