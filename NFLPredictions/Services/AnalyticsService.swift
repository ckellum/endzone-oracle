//
//  AnalyticsService.swift
//  NFLPredictions
//
//  Service for calculating prediction accuracy and statistics
//

import Foundation

struct AccuracyStats {
    let totalGames: Int
    let correctPredictions: Int
    let incorrectPredictions: Int
    let accuracy: Double
    let averagePointError: Double
    let averageTotalPointsError: Double
    let currentStreak: Int
    let bestStreak: Int
    
    var accuracyPercentage: String {
        String(format: "%.1f%%", accuracy * 100)
    }
}

struct TeamStats: Identifiable {
    let id = UUID()
    let teamName: String
    let gamesPlayed: Int
    let correctPredictions: Int
    let accuracy: Double
    let avgPointError: Double
}

class AnalyticsService {
    
    static func calculateAccuracy(from results: [GameResultData]) -> AccuracyStats {
        let totalGames = results.filter { $0.isCompleted }.count
        let correctPredictions = results.filter { $0.isCompleted && $0.wasPredictionCorrect }.count
        let incorrectPredictions = totalGames - correctPredictions
        
        let accuracy = totalGames > 0 ? Double(correctPredictions) / Double(totalGames) : 0.0
        
        // Calculate average point error
        let totalPointError = results.filter { $0.isCompleted }.reduce(0.0) { sum, result in
            let team1Error = abs(result.team1ActualScore - result.team1PredictedScore)
            let team2Error = abs(result.team2ActualScore - result.team2PredictedScore)
            return sum + Double(team1Error + team2Error) / 2.0
        }
        let avgPointError = totalGames > 0 ? totalPointError / Double(totalGames) : 0.0
        
        // Calculate average total points error
        let totalPointsError = results.filter { $0.isCompleted }.reduce(0.0) { sum, result in
            let actualTotal = result.team1ActualScore + result.team2ActualScore
            let predictedTotal = result.team1PredictedScore + result.team2PredictedScore
            return sum + Double(abs(actualTotal - predictedTotal))
        }
        let avgTotalPointsError = totalGames > 0 ? totalPointsError / Double(totalGames) : 0.0
        
        // Calculate streaks
        let (currentStreak, bestStreak) = calculateStreaks(from: results)
        
        return AccuracyStats(
            totalGames: totalGames,
            correctPredictions: correctPredictions,
            incorrectPredictions: incorrectPredictions,
            accuracy: accuracy,
            averagePointError: avgPointError,
            averageTotalPointsError: avgTotalPointsError,
            currentStreak: currentStreak,
            bestStreak: bestStreak
        )
    }
    
    private static func calculateStreaks(from results: [GameResultData]) -> (current: Int, best: Int) {
        let completed = results.filter { $0.isCompleted }
        guard !completed.isEmpty else { return (0, 0) }
        
        var currentStreak = 0
        var bestStreak = 0
        var tempStreak = 0
        
        // Find current streak (from most recent)
        for result in completed {
            if result.wasPredictionCorrect {
                currentStreak += 1
            } else {
                break
            }
        }
        
        // Find best streak overall
        for result in completed {
            if result.wasPredictionCorrect {
                tempStreak += 1
                bestStreak = max(bestStreak, tempStreak)
            } else {
                tempStreak = 0
            }
        }
        
        return (currentStreak, bestStreak)
    }
    
    static func calculateTeamStats(from results: [GameResultData]) -> [TeamStats] {
        var teamData: [String: (games: Int, correct: Int, totalError: Double)] = [:]
        
        for result in results.filter({ $0.isCompleted }) {
            // Process team1
            let team1Error = abs(result.team1ActualScore - result.team1PredictedScore)
            if var data = teamData[result.team1Name] {
                data.games += 1
                data.totalError += Double(team1Error)
                if result.wasPredictionCorrect {
                    data.correct += 1
                }
                teamData[result.team1Name] = data
            } else {
                teamData[result.team1Name] = (1, result.wasPredictionCorrect ? 1 : 0, Double(team1Error))
            }
            
            // Process team2
            let team2Error = abs(result.team2ActualScore - result.team2PredictedScore)
            if var data = teamData[result.team2Name] {
                data.games += 1
                data.totalError += Double(team2Error)
                if result.wasPredictionCorrect {
                    data.correct += 1
                }
                teamData[result.team2Name] = data
            } else {
                teamData[result.team2Name] = (1, result.wasPredictionCorrect ? 1 : 0, Double(team2Error))
            }
        }
        
        return teamData.map { name, data in
            TeamStats(
                teamName: name,
                gamesPlayed: data.games,
                correctPredictions: data.correct,
                accuracy: data.games > 0 ? Double(data.correct) / Double(data.games) : 0.0,
                avgPointError: data.games > 0 ? data.totalError / Double(data.games) : 0.0
            )
        }.sorted { $0.accuracy > $1.accuracy }
    }
    
    static func findBestPrediction(from results: [GameResultData]) -> GameResultData? {
        return results
            .filter { $0.isCompleted && $0.wasPredictionCorrect }
            .min { result1, result2 in
                let error1 = abs(result1.team1ActualScore - result1.team1PredictedScore) +
                            abs(result1.team2ActualScore - result1.team2PredictedScore)
                let error2 = abs(result2.team1ActualScore - result2.team1PredictedScore) +
                            abs(result2.team2ActualScore - result2.team2PredictedScore)
                return error1 < error2
            }
    }
    
    static func findWorstPrediction(from results: [GameResultData]) -> GameResultData? {
        return results
            .filter { $0.isCompleted }
            .max { result1, result2 in
                let error1 = abs(result1.team1ActualScore - result1.team1PredictedScore) +
                            abs(result1.team2ActualScore - result1.team2PredictedScore)
                let error2 = abs(result2.team1ActualScore - result2.team1PredictedScore) +
                            abs(result2.team2ActualScore - result2.team2PredictedScore)
                return error1 < error2
            }
    }
}


