//
//  ContentView.swift
//  NFLPredictions
//
//  Main tab view container
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var predictionService: PredictionService
    @EnvironmentObject var dataPersistenceService: DataPersistenceService
    @StateObject private var predictionsViewModel: PredictionsViewModel
    @StateObject private var statsViewModel: StatsViewModel
    
    @State private var selectedTab = 0
    @State private var showingFilePicker = false
    
    init() {
        let predService = PredictionService()
        let dataService = DataPersistenceService()
        _predictionsViewModel = StateObject(wrappedValue: PredictionsViewModel(
            predictionService: predService,
            dataPersistenceService: dataService
        ))
        _statsViewModel = StateObject(wrappedValue: StatsViewModel(
            dataPersistenceService: dataService
        ))
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                PredictionsListView(viewModel: predictionsViewModel)
            }
            .tabItem {
                Label("Predictions", systemImage: "football.fill")
            }
            .tag(0)
            
            NavigationStack {
                StatsDashboardView(viewModel: statsViewModel)
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar.fill")
            }
            .tag(1)
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(2)
        }
        .onAppear {
            // Sync environment objects with view models
            predictionsViewModel.predictionService = predictionService
            predictionsViewModel.dataPersistenceService = dataPersistenceService
            statsViewModel.dataPersistenceService = dataPersistenceService
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PredictionService())
        .environmentObject(DataPersistenceService())
}


