//
//  PredictionData.swift
//  NFLPredictions
//
//  Root model for parsing JSON predictions file
//

import Foundation

struct PredictionData: Codable {
    let generatedAt: String
    let timestamp: String
    let modelVersion: String
    let dataSources: DataSources
    let statistics: PredictionStatistics
    let predictions: [Prediction]
    
    enum CodingKeys: String, CodingKey {
        case generatedAt = "generated_at"
        case timestamp
        case modelVersion = "model_version"
        case dataSources = "data_sources"
        case statistics
        case predictions
    }
    
    var formattedGeneratedDate: Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: generatedAt)
    }
}

struct DataSources: Codable {
    let offensiveStats: String
    let defensiveStats: String
    
    enum CodingKeys: String, CodingKey {
        case offensiveStats = "offensive_stats"
        case defensiveStats = "defensive_stats"
    }
}

struct PredictionStatistics: Codable {
    let totalGames: Int
    let outliersDetected: Int
    let avgTotalPoints: Double
    let minTotalPoints: Int
    let maxTotalPoints: Int
    let avgPointDifferential: Double
    let maxSpread: Int
    let gamesWithTies: Int
    let games4050Points: Int
    
    enum CodingKeys: String, CodingKey {
        case totalGames = "total_games"
        case outliersDetected = "outliers_detected"
        case avgTotalPoints = "avg_total_points"
        case minTotalPoints = "min_total_points"
        case maxTotalPoints = "max_total_points"
        case avgPointDifferential = "avg_point_differential"
        case maxSpread = "max_spread"
        case gamesWithTies = "games_with_ties"
        case games4050Points = "games_40_50_points"
    }
}

