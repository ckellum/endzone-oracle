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
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                PredictionsListView(
                    viewModel: PredictionsViewModel(
                        predictionService: predictionService,
                        dataPersistenceService: dataPersistenceService
                    )
                )
            }
            .tabItem {
                Label("Predictions", systemImage: "football.fill")
            }
            .tag(0)
            
            NavigationStack {
                StatsDashboardView(
                    viewModel: StatsViewModel(
                        dataPersistenceService: dataPersistenceService
                    )
                )
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
    }
}

#Preview {
    ContentView()
        .environmentObject(PredictionService())
        .environmentObject(DataPersistenceService())
}

