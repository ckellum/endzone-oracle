//
//  SettingsView.swift
//  NFLPredictions
//
//  Settings and configuration view
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var predictionService: PredictionService
    @EnvironmentObject var dataPersistenceService: DataPersistenceService
    
    @State private var showingClearConfirmation = false
    @State private var showingFilePicker = false
    @State private var showingAbout = false
    
    @AppStorage("defaultSortOption") private var defaultSortOption = "pointDifferential"
    @AppStorage("showConfidenceBadges") private var showConfidenceBadges = true
    
    var body: some View {
        Form {
            // Data Management
            Section("Data Management") {
                Button(action: { showingFilePicker = true }) {
                    Label("Import Predictions", systemImage: "square.and.arrow.down")
                }
                
                if predictionService.currentPredictions != nil {
                    Button(action: { predictionService.clearPredictions() }) {
                        Label("Clear Predictions", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
                
                if !dataPersistenceService.savedResults.isEmpty {
                    Button(action: { showingClearConfirmation = true }) {
                        Label("Clear All Results", systemImage: "trash.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            
            // Display Preferences
            Section("Display Preferences") {
                Picker("Default Sort", selection: $defaultSortOption) {
                    Text("Point Differential").tag("pointDifferential")
                    Text("Total Points").tag("totalPoints")
                    Text("Team Name").tag("teamName")
                }
                
                Toggle("Show Confidence Badges", isOn: $showConfidenceBadges)
            }
            
            // Model Information
            if let predictions = predictionService.currentPredictions {
                Section("Current Model") {
                    InfoRow(label: "Version", value: predictions.modelVersion)
                    InfoRow(label: "Timestamp", value: predictions.timestamp)
                    
                    if let date = predictions.formattedGeneratedDate {
                        InfoRow(label: "Generated", value: date.mediumDateTime)
                    }
                    
                    NavigationLink {
                        DataSourcesView(dataSources: predictions.dataSources)
                    } label: {
                        Text("Data Sources")
                    }
                }
            }
            
            // Statistics
            Section("Statistics") {
                InfoRow(
                    label: "Total Results",
                    value: "\(dataPersistenceService.savedResults.count)"
                )
                
                if let predictions = predictionService.currentPredictions {
                    InfoRow(
                        label: "Loaded Predictions",
                        value: "\(predictions.predictions.count)"
                    )
                }
            }
            
            // About
            Section("About") {
                Button(action: { showingAbout = true }) {
                    Label("About NFL Predictions", systemImage: "info.circle")
                }
                
                InfoRow(label: "Version", value: "1.0.0")
            }
        }
        .navigationTitle("Settings")
        .sheet(isPresented: $showingFilePicker) {
            DocumentPickerForSettings()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        .alert("Clear All Results?", isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                dataPersistenceService.clearAllResults()
            }
        } message: {
            Text("This will permanently delete all game results. This action cannot be undone.")
        }
    }
}

struct DataSourcesView: View {
    let dataSources: DataSources
    
    var body: some View {
        Form {
            Section("Offensive Stats") {
                Text(dataSources.offensiveStats)
                    .font(.caption)
            }
            
            Section("Defensive Stats") {
                Text(dataSources.defensiveStats)
                    .font(.caption)
            }
        }
        .navigationTitle("Data Sources")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // App icon placeholder
                    Image(systemName: "football.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                        .padding()
                    
                    Text("NFL Predictions")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Version 1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About")
                            .font(.headline)
                        
                        Text("A premium iOS app for viewing and tracking NFL game predictions powered by machine learning models.")
                            .font(.body)
                        
                        Text("Features")
                            .font(.headline)
                            .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            featureRow(icon: "brain.head.profile", text: "AI-powered predictions")
                            featureRow(icon: "chart.bar.fill", text: "Detailed analytics")
                            featureRow(icon: "checkmark.circle.fill", text: "Accuracy tracking")
                            featureRow(icon: "sportscourt.fill", text: "All 32 NFL teams")
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    @ViewBuilder
    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
        }
    }
}

struct DocumentPickerForSettings: UIViewControllerRepresentable {
    @EnvironmentObject var predictionService: PredictionService
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.json])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPickerForSettings
        
        init(_ parent: DocumentPickerForSettings) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            guard url.startAccessingSecurityScopedResource() else { return }
            defer { url.stopAccessingSecurityScopedResource() }
            
            parent.predictionService.loadPredictionsFromFile(url: url)
            parent.dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environmentObject(PredictionService())
    .environmentObject(DataPersistenceService())
}


