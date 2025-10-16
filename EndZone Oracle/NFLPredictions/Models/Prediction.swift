//
//  Prediction.swift
//  NFLPredictions
//
//  Model for a single game prediction
//

import Foundation
import SwiftUI

struct Prediction: Codable, Identifiable, Equatable {
    let id = UUID()
    let team1: String
    let team1PredictedPoints: Int
    let team2: String
    let team2PredictedPoints: Int
    let predictedWinner: String
    let pointDifferential: Int
    let totalPoints: Int
    
    // Equatable conformance - compare by content, not ID
    static func == (lhs: Prediction, rhs: Prediction) -> Bool {
        lhs.team1 == rhs.team1 &&
        lhs.team2 == rhs.team2 &&
        lhs.team1PredictedPoints == rhs.team1PredictedPoints &&
        lhs.team2PredictedPoints == rhs.team2PredictedPoints
    }
    
    // Computed properties
    var isTie: Bool {
        predictedWinner == "TIE"
    }
    
    var confidenceLevel: ConfidenceLevel {
        let absDiff = abs(pointDifferential)
        switch absDiff {
        case 0...3:
            return .low
        case 4...7:
            return .medium
        default:
            return .high
        }
    }
    
    var winningTeam: String? {
        isTie ? nil : predictedWinner
    }
    
    enum CodingKeys: String, CodingKey {
        case team1
        case team1PredictedPoints = "team1_predicted_points"
        case team2
        case team2PredictedPoints = "team2_predicted_points"
        case predictedWinner = "predicted_winner"
        case pointDifferential = "point_differential"
        case totalPoints = "total_points"
    }
}

enum ConfidenceLevel: String, CaseIterable {
    case low = "Low Confidence"
    case medium = "Medium Confidence"
    case high = "High Confidence"
    
    var color: Color {
        switch self {
        case .low: return .orange
        case .medium: return .blue
        case .high: return .green
        }
    }
    
    var iconName: String {
        switch self {
        case .low: return "exclamationmark.triangle.fill"
        case .medium: return "checkmark.circle.fill"
        case .high: return "star.fill"
        }
    }
}

