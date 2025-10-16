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

    @StateObject private var predictionService: PredictionService
    @StateObject private var dataPersistenceService = DataPersistenceService()

    init() {
        // Create prediction service - will load from GitHub on app launch
        let service = PredictionService()
        _predictionService = StateObject(wrappedValue: service)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(predictionService)
                .environmentObject(dataPersistenceService)
        }
    }
}

