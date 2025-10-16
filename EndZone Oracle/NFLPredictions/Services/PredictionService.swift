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

