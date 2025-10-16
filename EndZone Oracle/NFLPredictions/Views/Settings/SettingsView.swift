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
    @State private var showingKalshiAPIKey = false
    @State private var kalshiAPIKey: String = ""
    
    @AppStorage("defaultSortOption") private var defaultSortOption = "pointDifferential"
    @AppStorage("showConfidenceBadges") private var showConfidenceBadges = true
    @AppStorage("kalshi_api_key_id") private var savedKalshiAPIKeyID: String = ""
    @AppStorage("kalshi_private_key") private var savedKalshiPrivateKey: String = ""
    @AppStorage("kalshi_odds_enabled") private var kalshiOddsEnabled = true
    
    var body: some View {
        Form {
            // Data Management
            Section("Data Management") {
                Button(action: {
                    Task {
                        await predictionService.refreshFromGitHub()
                    }
                }) {
                    HStack {
                        Label("Refresh from GitHub", systemImage: "arrow.clockwise")
                            .foregroundColor(.blue)
                        if predictionService.isLoading {
                            Spacer()
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                    }
                }
                .disabled(predictionService.isLoading)

                Button(action: {
                    predictionService.loadPredictionsFromBundle(filename: "predictions")
                }) {
                    Label("Load Bundled Predictions", systemImage: "doc.fill")
                        .foregroundColor(.secondary)
                }

                Button(action: { showingFilePicker = true }) {
                    Label("Import JSON File", systemImage: "square.and.arrow.down")
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
            
            // Kalshi Integration
            Section {
                Toggle("Enable Kalshi Odds", isOn: $kalshiOddsEnabled)
                
                if kalshiOddsEnabled {
                    Button(action: { showingKalshiAPIKey = true }) {
                        HStack {
                            Label("Configure Credentials", systemImage: "key.fill")
                            Spacer()
                            Text(savedKalshiAPIKeyID.isEmpty ? "Not Set" : "Configured")
                                .foregroundColor(savedKalshiAPIKeyID.isEmpty ? .secondary : .green)
                                .font(.caption)
                        }
                    }
                    
                    if !savedKalshiAPIKeyID.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("API Key ID: \(savedKalshiAPIKeyID.prefix(8))...")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            Text("Private Key: \(savedKalshiPrivateKey.isEmpty ? "Not Set" : "Set")")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading, 32)
                        
                        Button(action: { 
                            savedKalshiAPIKeyID = ""
                            savedKalshiPrivateKey = ""
                        }) {
                            Label("Remove Credentials", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            } header: {
                Text("Kalshi Integration")
            } footer: {
                Text("Connect to Kalshi to view prediction market odds alongside your predictions. Requires a Kalshi API key.")
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
                    Label("About EndZone Oracle", systemImage: "info.circle")
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
        .sheet(isPresented: $showingKalshiAPIKey) {
            KalshiCredentialsSheet(
                apiKeyID: $savedKalshiAPIKeyID,
                privateKey: $savedKalshiPrivateKey,
                isPresented: $showingKalshiAPIKey
            )
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
                    // App logo
                    Image("AppLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .padding()
                    
                    Text("EndZone Oracle")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("NFL Predictions")
                        .font(.title3)
                        .foregroundColor(.secondary)

                    Text("Version 1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("About")
                            .font(.headline)

                        Text("A premium iOS app for viewing and tracking NFL game predictions powered by advanced machine learning models.")
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

struct KalshiCredentialsSheet: View {
    @Binding var apiKeyID: String
    @Binding var privateKey: String
    @Binding var isPresented: Bool
    
    @State private var inputKeyID: String = ""
    @State private var inputPrivateKey: String = ""
    @FocusState private var focusedField: Field?
    
    enum Field {
        case keyID, privateKey
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("API Key ID", text: $inputKeyID)
                        .focused($focusedField, equals: .keyID)
                        .textContentType(.username)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } header: {
                    Text("API Key ID")
                } footer: {
                    Text("The UUID identifier for your Kalshi API key (e.g., cfa8951b-eff3-...)")
                        .font(.caption)
                }
                
                Section {
                    TextEditor(text: $inputPrivateKey)
                        .focused($focusedField, equals: .privateKey)
                        .font(.system(.caption, design: .monospaced))
                        .frame(minHeight: 200)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } header: {
                    Text("Private Key")
                } footer: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Paste your complete RSA private key including the BEGIN and END lines.")
                        
                        Text("Example format:")
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                        
                        Text("-----BEGIN RSA PRIVATE KEY-----")
                        Text("MIIEowIBAAKCAQEA...")
                        Text("...")
                        Text("-----END RSA PRIVATE KEY-----")
                        
                        Text("Your credentials are stored securely on your device and never shared.")
                            .fontWeight(.semibold)
                            .padding(.top, 8)
                    }
                    .font(.caption)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("To get your Kalshi API credentials:")
                            .fontWeight(.semibold)
                        
                        Text("1. Log in to your Kalshi account")
                        Text("2. Navigate to Settings → API")
                        Text("3. Generate a new API key")
                        Text("4. Copy both the Key ID and Private Key")
                        Text("5. Paste them above")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Kalshi Credentials")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        apiKeyID = inputKeyID.trimmingCharacters(in: .whitespacesAndNewlines)
                        privateKey = inputPrivateKey.trimmingCharacters(in: .whitespacesAndNewlines)
                        isPresented = false
                    }
                    .disabled(inputKeyID.isEmpty || inputPrivateKey.isEmpty)
                }
            }
            .onAppear {
                inputKeyID = apiKeyID
                inputPrivateKey = privateKey
                if apiKeyID.isEmpty {
                    focusedField = .keyID
                }
            }
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

