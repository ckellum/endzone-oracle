//
//  StatsViewModel.swift
//  NFLPredictions
//
//  ViewModel for statistics dashboard
//

import Foundation

class StatsViewModel: ObservableObject {
    @Published var dataPersistenceService: DataPersistenceService
    
    var accuracyStats: AccuracyStats {
        AnalyticsService.calculateAccuracy(from: dataPersistenceService.savedResults)
    }
    
    var teamStats: [TeamStats] {
        AnalyticsService.calculateTeamStats(from: dataPersistenceService.savedResults)
    }
    
    var bestPrediction: GameResultData? {
        AnalyticsService.findBestPrediction(from: dataPersistenceService.savedResults)
    }
    
    var worstPrediction: GameResultData? {
        AnalyticsService.findWorstPrediction(from: dataPersistenceService.savedResults)
    }
    
    var hasData: Bool {
        !dataPersistenceService.savedResults.isEmpty
    }
    
    init(dataPersistenceService: DataPersistenceService = DataPersistenceService()) {
        self.dataPersistenceService = dataPersistenceService
    }
    
    func refreshData() {
        dataPersistenceService.fetchResults()
    }
}


