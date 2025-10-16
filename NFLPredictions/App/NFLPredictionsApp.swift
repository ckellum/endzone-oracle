//
//  NFLPredictionsApp.swift
//  NFLPredictions
//
//  Main app entry point
//

import SwiftUI

@main
struct NFLPredictionsApp: App {
    let persistenceController = PersistenceController.shared
    
    @StateObject private var predictionService = PredictionService()
    @StateObject private var dataPersistenceService = DataPersistenceService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(predictionService)
                .environmentObject(dataPersistenceService)
        }
    }
}


