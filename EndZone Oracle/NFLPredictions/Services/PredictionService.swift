//
//  PredictionService.swift
//  NFLPredictions
//
//  Service for loading and parsing prediction JSON files
//

import Foundation

class PredictionService: ObservableObject {
    @Published var currentPredictions: PredictionData?
    @Published var isLoading = false
    @Published var error: String?

    private let githubService = GitHubPredictionsService()

    /// Load predictions - tries GitHub first, falls back to bundle
    func loadPredictions() async {
        isLoading = true
        error = nil

        // Try loading from GitHub
        do {
            let predictions = try await githubService.fetchLatestPredictions()
            DispatchQueue.main.async {
                self.currentPredictions = predictions
                self.isLoading = false
                self.error = nil
            }
            return
        } catch {
            print("GitHub fetch failed: \(error.localizedDescription)")
            // Fall through to try cached or bundle
        }

        // Try cached predictions
        if let cached = githubService.loadCachedPredictions() {
            DispatchQueue.main.async {
                self.currentPredictions = cached
                self.isLoading = false
                self.error = nil
            }
            return
        }

        // Fall back to bundled predictions
        loadPredictionsFromBundle(filename: "predictions")
    }

    /// Check if should auto-update
    func shouldAutoUpdate() -> Bool {
        return githubService.shouldCheckForUpdate()
    }

    /// Manual refresh from GitHub
    func refreshFromGitHub() async {
        isLoading = true
        error = nil

        do {
            let predictions = try await githubService.refreshPredictions()
            DispatchQueue.main.async {
                self.currentPredictions = predictions
                self.isLoading = false
                self.error = nil
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "Failed to fetch updates: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }

    func loadPredictionsFromJSON(data: Data) {
        isLoading = true
        error = nil

        do {
            let decoder = JSONDecoder()
            let predictions = try decoder.decode(PredictionData.self, from: data)

            DispatchQueue.main.async {
                self.currentPredictions = predictions
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.error = "Failed to parse JSON: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func loadPredictionsFromFile(url: URL) {
        isLoading = true
        error = nil
        
        do {
            let data = try Data(contentsOf: url)
            loadPredictionsFromJSON(data: data)
        } catch {
            DispatchQueue.main.async {
                self.error = "Failed to read file: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    func clearPredictions() {
        currentPredictions = nil
        error = nil
    }

    func loadPredictionsFromBundle(filename: String) {
        isLoading = true
        error = nil

        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            DispatchQueue.main.async {
                self.error = "Could not find \(filename).json in app bundle"
                self.isLoading = false
            }
            return
        }

        loadPredictionsFromFile(url: url)
    }
}

