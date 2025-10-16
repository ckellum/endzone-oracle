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
        // Create prediction service and auto-load predictions from bundle on app launch
        let service = PredictionService()
        service.loadPredictionsFromBundle(filename: "enhanced_predictions_20251014_160158")
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

