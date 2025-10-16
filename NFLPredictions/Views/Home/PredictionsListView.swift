//
//  PredictionsListView.swift
//  NFLPredictions
//
//  Main list view of all predictions
//

import SwiftUI
import UniformTypeIdentifiers

struct PredictionsListView: View {
    @ObservedObject var viewModel: PredictionsViewModel
    @State private var showingFilePicker = false
    @State private var showingFilterSheet = false
    @State private var selectedPrediction: Prediction?
    
    var body: some View {
        ZStack {
            if viewModel.predictionService.currentPredictions == nil {
                // Empty state
                emptyStateView
            } else {
                // Predictions list
                ScrollView {
                    LazyVStack(spacing: 16) {
                        // Header
                        if let modelInfo = viewModel.modelInfo,
                           let statistics = viewModel.statistics {
                            PredictionHeaderView(
                                modelVersion: modelInfo.version,
                                timestamp: modelInfo.timestamp,
                                statistics: statistics
                            )
                            .padding(.horizontal)
                        }
                        
                        // Predictions
                        ForEach(viewModel.filteredAndSortedPredictions) { prediction in
                            GameCardView(
                                prediction: prediction,
                                result: viewModel.getResult(for: prediction),
                                onTap: { selectedPrediction = prediction }
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .refreshable {
                    viewModel.dataPersistenceService.fetchResults()
                }
            }
        }
        .navigationTitle("Predictions")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { showingFilterSheet = true }) {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingFilePicker = true }) {
                    Label("Import", systemImage: "square.and.arrow.down")
                }
            }
        }
        .sheet(isPresented: $showingFilePicker) {
            DocumentPicker(viewModel: viewModel)
        }
        .sheet(item: $selectedPrediction) { prediction in
            NavigationStack {
                GameDetailView(
                    prediction: prediction,
                    result: viewModel.getResult(for: prediction),
                    timestamp: viewModel.predictionService.currentPredictions?.timestamp ?? ""
                )
            }
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilterSheet(viewModel: viewModel)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Predictions Loaded")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Import a predictions JSON file to get started")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: { showingFilePicker = true }) {
                Label("Import Predictions", systemImage: "square.and.arrow.down")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            
            Button(action: { viewModel.loadSampleData() }) {
                Text("Load Sample Data")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

struct FilterSheet: View {
    @ObservedObject var viewModel: PredictionsViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Sort By") {
                    Picker("Sort Option", selection: $viewModel.sortOption) {
                        ForEach(PredictionSortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.inline)
                }
                
                Section("Filter") {
                    Picker("Filter Option", selection: $viewModel.filterOption) {
                        ForEach(PredictionFilterOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.inline)
                }
                
                Section("Search") {
                    TextField("Team name", text: $viewModel.searchText)
                }
            }
            .navigationTitle("Filter & Sort")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    @ObservedObject var viewModel: PredictionsViewModel
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.json])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            // Access the file
            guard url.startAccessingSecurityScopedResource() else { return }
            defer { url.stopAccessingSecurityScopedResource() }
            
            parent.viewModel.predictionService.loadPredictionsFromFile(url: url)
            parent.dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        PredictionsListView(viewModel: PredictionsViewModel())
    }
}


