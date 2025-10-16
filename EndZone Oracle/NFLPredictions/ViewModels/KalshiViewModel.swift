//
//  KalshiViewModel.swift
//  NFLPredictions
//
//  ViewModel for managing Kalshi odds integration
//

import Foundation
import SwiftUI

class KalshiViewModel: ObservableObject {
    @Published var kalshiService: KalshiService
    @Published var enrichedPredictions: [PredictionWithOdds] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showOnlyEdges = false
    @Published var minimumEdge: Double = 0.05 // 5% default
    
    init(kalshiService: KalshiService = KalshiService()) {
        self.kalshiService = kalshiService
    }
    
    // MARK: - Public Methods
    
    /// Load Kalshi odds for given predictions
    func loadOddsForPredictions(_ predictions: [Prediction]) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let enriched = try await kalshiService.enrichPredictionsWithOdds(predictions)
            
            await MainActor.run {
                self.enrichedPredictions = enriched
                self.isLoading = false
            }
        } catch let error as KalshiError {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load odds: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    /// Refresh odds data
    func refreshOdds() async {
        guard !enrichedPredictions.isEmpty else { return }
        let predictions = enrichedPredictions.map { $0.prediction }
        await loadOddsForPredictions(predictions)
    }
    
    /// Get enriched prediction for a given prediction
    func getEnrichedPrediction(for prediction: Prediction) -> PredictionWithOdds? {
        enrichedPredictions.first { $0.prediction.id == prediction.id }
    }
    
    /// Filter predictions with positive edge
    var predictionsWithEdge: [PredictionWithOdds] {
        enrichedPredictions.filter { prediction in
            guard let edge = prediction.predictionEdge else { return false }
            return edge >= minimumEdge
        }
    }
    
    /// Get statistics about edges
    var edgeStatistics: EdgeStatistics {
        let validEdges = enrichedPredictions.compactMap { $0.predictionEdge }
        
        guard !validEdges.isEmpty else {
            return EdgeStatistics(
                totalPredictions: enrichedPredictions.count,
                predictionsWithOdds: 0,
                averageEdge: 0,
                maxEdge: 0,
                minEdge: 0,
                positiveEdges: 0,
                negativeEdges: 0
            )
        }
        
        let positive = validEdges.filter { $0 > 0 }.count
        let negative = validEdges.filter { $0 < 0 }.count
        
        return EdgeStatistics(
            totalPredictions: enrichedPredictions.count,
            predictionsWithOdds: validEdges.count,
            averageEdge: validEdges.reduce(0, +) / Double(validEdges.count),
            maxEdge: validEdges.max() ?? 0,
            minEdge: validEdges.min() ?? 0,
            positiveEdges: positive,
            negativeEdges: negative
        )
    }
    
    // MARK: - API Key Management
    
    var hasAPIKey: Bool {
        kalshiService.hasAPIKey()
    }
    
    func setCredentials(keyID: String, privateKey: String) {
        kalshiService.setCredentials(keyID: keyID, privateKey: privateKey)
    }
    
    func getAPIKeyID() -> String? {
        kalshiService.getAPIKeyID()
    }
}

// MARK: - Edge Statistics

struct EdgeStatistics {
    let totalPredictions: Int
    let predictionsWithOdds: Int
    let averageEdge: Double
    let maxEdge: Double
    let minEdge: Double
    let positiveEdges: Int
    let negativeEdges: Int
    
    var coveragePercentage: Double {
        guard totalPredictions > 0 else { return 0 }
        return Double(predictionsWithOdds) / Double(totalPredictions) * 100
    }
    
    var positiveEdgePercentage: Double {
        guard predictionsWithOdds > 0 else { return 0 }
        return Double(positiveEdges) / Double(predictionsWithOdds) * 100
    }
}

