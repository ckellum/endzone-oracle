//
//  DataPersistenceService.swift
//  NFLPredictions
//
//  Service for managing game results in CoreData
//

import Foundation
import CoreData

class DataPersistenceService: ObservableObject {
    private let persistenceController: PersistenceController
    @Published var savedResults: [GameResultData] = []
    
    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
        fetchResults()
    }
    
    var context: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
    
    func saveResult(for prediction: Prediction, 
                   team1Score: Int, 
                   team2Score: Int,
                   timestamp: String) {
        let result = GameResult(context: context)
        result.id = UUID()
        result.team1Name = prediction.team1
        result.team2Name = prediction.team2
        result.team1ActualScore = Int16(team1Score)
        result.team2ActualScore = Int16(team2Score)
        result.team1PredictedScore = Int16(prediction.team1PredictedPoints)
        result.team2PredictedScore = Int16(prediction.team2PredictedPoints)
        result.predictedWinner = prediction.predictedWinner
        result.gameDate = Date()
        result.timestamp = timestamp
        result.isCompleted = true
        
        persistenceController.save()
        fetchResults()
    }
    
    func fetchResults() {
        let request: NSFetchRequest<GameResult> = GameResult.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \GameResult.gameDate, ascending: false)]
        
        do {
            let results = try context.fetch(request)
            savedResults = results.map { GameResultData(from: $0) }
        } catch {
            print("Failed to fetch results: \(error)")
        }
    }
    
    func getResult(for prediction: Prediction, timestamp: String) -> GameResultData? {
        let request: NSFetchRequest<GameResult> = GameResult.fetchRequest()
        request.predicate = NSPredicate(
            format: "team1Name == %@ AND team2Name == %@ AND timestamp == %@",
            prediction.team1, prediction.team2, timestamp
        )
        
        do {
            let results = try context.fetch(request)
            return results.first.map { GameResultData(from: $0) }
        } catch {
            print("Failed to fetch result: \(error)")
            return nil
        }
    }
    
    func deleteResult(_ result: GameResultData) {
        let request: NSFetchRequest<GameResult> = GameResult.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", result.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            persistenceController.save()
            fetchResults()
        } catch {
            print("Failed to delete result: \(error)")
        }
    }
    
    func clearAllResults() {
        let request: NSFetchRequest<NSFetchRequestResult> = GameResult.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
            persistenceController.save()
            fetchResults()
        } catch {
            print("Failed to clear results: \(error)")
        }
    }
}

extension GameResult {
    static func fetchRequest() -> NSFetchRequest<GameResult> {
        return NSFetchRequest<GameResult>(entityName: "GameResult")
    }
}

