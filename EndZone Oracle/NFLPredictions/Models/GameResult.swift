//
//  GameResult.swift
//  NFLPredictions
//
//  Model for storing actual game results
//

import Foundation
import CoreData

@objc(GameResult)
public class GameResult: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var team1Name: String
    @NSManaged public var team2Name: String
    @NSManaged public var team1ActualScore: Int16
    @NSManaged public var team2ActualScore: Int16
    @NSManaged public var team1PredictedScore: Int16
    @NSManaged public var team2PredictedScore: Int16
    @NSManaged public var predictedWinner: String
    @NSManaged public var gameDate: Date
    @NSManaged public var timestamp: String
    @NSManaged public var isCompleted: Bool
    
    var actualWinner: String {
        if team1ActualScore > team2ActualScore {
            return team1Name
        } else if team2ActualScore > team1ActualScore {
            return team2Name
        } else {
            return "TIE"
        }
    }
    
    var wasPredictionCorrect: Bool {
        return actualWinner == predictedWinner
    }
    
    var team1ScoreError: Int {
        return Int(abs(team1ActualScore - team1PredictedScore))
    }
    
    var team2ScoreError: Int {
        return Int(abs(team2ActualScore - team2PredictedScore))
    }
    
    var totalPointsError: Int {
        let actualTotal = Int(team1ActualScore + team2ActualScore)
        let predictedTotal = Int(team1PredictedScore + team2PredictedScore)
        return abs(actualTotal - predictedTotal)
    }
}

// Result wrapper for SwiftUI
struct GameResultData: Identifiable {
    let id: UUID
    let team1Name: String
    let team2Name: String
    let team1ActualScore: Int
    let team2ActualScore: Int
    let team1PredictedScore: Int
    let team2PredictedScore: Int
    let predictedWinner: String
    let isCompleted: Bool
    
    var actualWinner: String {
        if team1ActualScore > team2ActualScore {
            return team1Name
        } else if team2ActualScore > team1ActualScore {
            return team2Name
        } else {
            return "TIE"
        }
    }
    
    var wasPredictionCorrect: Bool {
        return actualWinner == predictedWinner
    }

    // Initializer from CoreData entity
    init(from result: GameResult) {
        self.id = result.id
        self.team1Name = result.team1Name
        self.team2Name = result.team2Name
        self.team1ActualScore = Int(result.team1ActualScore)
        self.team2ActualScore = Int(result.team2ActualScore)
        self.team1PredictedScore = Int(result.team1PredictedScore)
        self.team2PredictedScore = Int(result.team2PredictedScore)
        self.predictedWinner = result.predictedWinner
        self.isCompleted = result.isCompleted
    }

    // Direct initializer for testing/previews
    init(id: UUID, team1Name: String, team2Name: String, team1ActualScore: Int, team2ActualScore: Int, team1PredictedScore: Int, team2PredictedScore: Int, predictedWinner: String, isCompleted: Bool) {
        self.id = id
        self.team1Name = team1Name
        self.team2Name = team2Name
        self.team1ActualScore = team1ActualScore
        self.team2ActualScore = team2ActualScore
        self.team1PredictedScore = team1PredictedScore
        self.team2PredictedScore = team2PredictedScore
        self.predictedWinner = predictedWinner
        self.isCompleted = isCompleted
    }
}

