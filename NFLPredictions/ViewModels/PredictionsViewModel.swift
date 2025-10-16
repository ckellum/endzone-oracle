//
//  PredictionsViewModel.swift
//  NFLPredictions
//
//  ViewModel for managing predictions display and filtering
//

import Foundation
import SwiftUI

enum PredictionSortOption: String, CaseIterable, Identifiable {
    case pointDifferential = "Point Differential"
    case totalPoints = "Total Points"
    case teamName = "Team Name"
    
    var id: String { rawValue }
}

enum PredictionFilterOption: String, CaseIterable, Identifiable {
    case all = "All Games"
    case completed = "Completed"
    case scheduled = "Scheduled"
    case highConfidence = "High Confidence"
    
    var id: String { rawValue }
}

class PredictionsViewModel: ObservableObject {
    @Published var predictionService: PredictionService
    @Published var dataPersistenceService: DataPersistenceService
    
    @Published var sortOption: PredictionSortOption = .pointDifferential
    @Published var filterOption: PredictionFilterOption = .all
    @Published var searchText: String = ""
    @Published var favoriteTeams: Set<String> = []
    
    var filteredAndSortedPredictions: [Prediction] {
        guard let predictions = predictionService.currentPredictions?.predictions else {
            return []
        }
        
        var filtered = predictions
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.team1.localizedCaseInsensitiveContains(searchText) ||
                $0.team2.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply type filter
        switch filterOption {
        case .all:
            break
        case .completed:
            filtered = filtered.filter { prediction in
                getResult(for: prediction) != nil
            }
        case .scheduled:
            filtered = filtered.filter { prediction in
                getResult(for: prediction) == nil
            }
        case .highConfidence:
            filtered = filtered.filter { $0.confidenceLevel == .high }
        }
        
        // Apply sorting
        switch sortOption {
        case .pointDifferential:
            filtered.sort { abs($0.pointDifferential) > abs($1.pointDifferential) }
        case .totalPoints:
            filtered.sort { $0.totalPoints > $1.totalPoints }
        case .teamName:
            filtered.sort { $0.team1 < $1.team1 }
        }
        
        return filtered
    }
    
    var statistics: PredictionStatistics? {
        predictionService.currentPredictions?.statistics
    }
    
    var modelInfo: (version: String, timestamp: String)? {
        guard let data = predictionService.currentPredictions else { return nil }
        return (data.modelVersion, data.timestamp)
    }
    
    init(predictionService: PredictionService = PredictionService(),
         dataPersistenceService: DataPersistenceService = DataPersistenceService()) {
        self.predictionService = predictionService
        self.dataPersistenceService = dataPersistenceService
    }
    
    func getResult(for prediction: Prediction) -> GameResultData? {
        guard let timestamp = predictionService.currentPredictions?.timestamp else {
            return nil
        }
        return dataPersistenceService.getResult(for: prediction, timestamp: timestamp)
    }
    
    func toggleFavoriteTeam(_ teamName: String) {
        if favoriteTeams.contains(teamName) {
            favoriteTeams.remove(teamName)
        } else {
            favoriteTeams.insert(teamName)
        }
    }
    
    func isFavorite(_ teamName: String) -> Bool {
        favoriteTeams.contains(teamName)
    }
    
    func loadSampleData() {
        // For preview/testing purposes
        let sampleJSON = """
        {
          "generated_at": "2025-10-14T16:01:58.087500",
          "timestamp": "20251014_160158",
          "model_version": "EnhancedNFLPredictionModel_v1.0",
          "data_sources": {
            "offensive_stats": "nfl_offensive_stats_20251014_142752.csv",
            "defensive_stats": "nfl_defensive_stats_20251014_142755.csv"
          },
          "statistics": {
            "total_games": 2,
            "outliers_detected": 0,
            "avg_total_points": 45.0,
            "min_total_points": 38,
            "max_total_points": 52,
            "avg_point_differential": 4.0,
            "max_spread": 8,
            "games_with_ties": 0,
            "games_40_50_points": 2
          },
          "predictions": [
            {
              "team1": "Pittsburgh Steelers",
              "team1_predicted_points": 24,
              "team2": "Cincinnati Bengals",
              "team2_predicted_points": 20,
              "predicted_winner": "Pittsburgh Steelers",
              "point_differential": 4,
              "total_points": 44
            },
            {
              "team1": "Kansas City Chiefs",
              "team1_predicted_points": 28,
              "team2": "Las Vegas Raiders",
              "team2_predicted_points": 20,
              "predicted_winner": "Kansas City Chiefs",
              "point_differential": 8,
              "total_points": 48
            }
          ]
        }
        """
        
        if let data = sampleJSON.data(using: .utf8) {
            predictionService.loadPredictionsFromJSON(data: data)
        }
    }
}


