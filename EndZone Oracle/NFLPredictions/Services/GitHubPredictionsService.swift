//
//  GitHubPredictionsService.swift
//  NFLPredictions
//
//  Fetches latest predictions.json from GitHub repository
//

import Foundation

class GitHubPredictionsService: ObservableObject {
    // GitHub raw content URL for predictions.json
    // Format: https://raw.githubusercontent.com/USERNAME/REPO/BRANCH/path/to/file
    private let githubRawURL = "https://raw.githubusercontent.com/ckellum/endzone-oracle/main/EndZone%20Oracle/NFLPredictions/predictions.json"

    @Published var isLoading = false
    @Published var lastUpdateDate: Date?
    @Published var errorMessage: String?
    @Published var updateAvailable = false

    private let userDefaults = UserDefaults.standard
    private let lastUpdateKey = "lastPredictionsUpdate"
    private let cachedPredictionsKey = "cachedPredictions"

    init() {
        // Load last update date
        if let timestamp = userDefaults.object(forKey: lastUpdateKey) as? Date {
            lastUpdateDate = timestamp
        }
    }

    /// Check if predictions should be updated (every 7 days)
    func shouldCheckForUpdate() -> Bool {
        guard let lastUpdate = lastUpdateDate else {
            return true // Never updated before
        }

        let daysSinceUpdate = Calendar.current.dateComponents([.day], from: lastUpdate, to: Date()).day ?? 0
        return daysSinceUpdate >= 7
    }

    /// Fetch latest predictions from GitHub
    func fetchLatestPredictions() async throws -> PredictionData {
        isLoading = true
        errorMessage = nil

        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }

        guard let url = URL(string: githubRawURL) else {
            throw GitHubError.invalidURL
        }

        // Create request with cache policy
        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData // Always get fresh data
        request.timeoutInterval = 30

        // Fetch data
        let (data, response) = try await URLSession.shared.data(for: request)

        // Check response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GitHubError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw GitHubError.httpError(statusCode: httpResponse.statusCode)
        }

        // Decode JSON
        let decoder = JSONDecoder()
        let predictions = try decoder.decode(PredictionData.self, from: data)

        // Cache the data and update timestamp
        DispatchQueue.main.async {
            self.cachePredictions(data)
            self.lastUpdateDate = Date()
            self.userDefaults.set(Date(), forKey: self.lastUpdateKey)
            self.updateAvailable = false
        }

        return predictions
    }

    /// Load cached predictions if available
    func loadCachedPredictions() -> PredictionData? {
        guard let data = userDefaults.data(forKey: cachedPredictionsKey) else {
            return nil
        }

        let decoder = JSONDecoder()
        return try? decoder.decode(PredictionData.self, from: data)
    }

    /// Cache predictions data
    private func cachePredictions(_ data: Data) {
        userDefaults.set(data, forKey: cachedPredictionsKey)
    }

    /// Check if update is available without downloading
    func checkForUpdates() async throws -> Bool {
        guard let url = URL(string: githubRawURL) else {
            throw GitHubError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "HEAD" // Only get headers, not content
        request.timeoutInterval = 10

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            return false
        }

        // Check if Last-Modified date is newer than our last update
        if let lastModifiedString = httpResponse.value(forHTTPHeaderField: "Last-Modified"),
           let lastModifiedDate = parseHTTPDate(lastModifiedString),
           let lastUpdate = lastUpdateDate {
            return lastModifiedDate > lastUpdate
        }

        return false
    }

    /// Manual refresh - force fetch from GitHub
    func refreshPredictions() async throws -> PredictionData {
        return try await fetchLatestPredictions()
    }

    /// Parse HTTP date string
    private func parseHTTPDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter.date(from: dateString)
    }

    /// Clear cache and reset
    func clearCache() {
        userDefaults.removeObject(forKey: cachedPredictionsKey)
        userDefaults.removeObject(forKey: lastUpdateKey)
        lastUpdateDate = nil
        updateAvailable = false
    }
}

// MARK: - Errors

enum GitHubError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case networkError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid GitHub URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .networkError:
            return "Network error. Please check your connection."
        }
    }
}
