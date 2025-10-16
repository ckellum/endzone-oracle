//
//  KalshiService.swift
//  NFLPredictions
//
//  Service for fetching Kalshi prediction market data
//

import Foundation
import Combine

class KalshiService: ObservableObject {
    @Published var isLoading = false
    @Published var error: KalshiError?
    @Published var markets: [KalshiMarket] = []
    
    private let baseURL = "https://trading-api.kalshi.com"
    private let demoBaseURL = "https://demo-api.kalshi.com"
    private var apiKeyID: String?
    private var privateKey: String?
    private var useDemo: Bool
    
    private var cancellables = Set<AnyCancellable>()
    
    init(apiKeyID: String? = nil, privateKey: String? = nil, useDemo: Bool = false) {
        self.apiKeyID = apiKeyID ?? UserDefaults.standard.string(forKey: "kalshi_api_key_id")
        self.privateKey = privateKey ?? UserDefaults.standard.string(forKey: "kalshi_private_key")
        self.useDemo = useDemo
    }
    
    // MARK: - Public Methods
    
    /// Fetch all NFL markets
    func fetchNFLMarkets() async throws -> [KalshiMarket] {
        guard let keyID = apiKeyID, !keyID.isEmpty,
              let privKey = privateKey, !privKey.isEmpty else {
            throw KalshiError.unauthorized
        }
        
        await MainActor.run {
            isLoading = true
            error = nil
        }
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        // Try different potential endpoints for NFL data
        let seriesTickers = ["NFL", "FOOTBALL", "NFLGAME"]
        var allMarkets: [KalshiMarket] = []
        
        for ticker in seriesTickers {
            do {
                let markets = try await fetchMarkets(seriesTicker: ticker)
                allMarkets.append(contentsOf: markets)
            } catch {
                // Continue trying other tickers
                print("Failed to fetch markets for \(ticker): \(error)")
            }
        }
        
        await MainActor.run {
            self.markets = allMarkets
        }
        
        return allMarkets
    }
    
    /// Fetch markets for a specific series
    func fetchMarkets(seriesTicker: String? = nil, status: String? = nil) async throws -> [KalshiMarket] {
        var components = URLComponents(string: "\(currentBaseURL)/trade-api/v2/markets")
        
        var queryItems: [URLQueryItem] = []
        if let ticker = seriesTicker {
            queryItems.append(URLQueryItem(name: "series_ticker", value: ticker))
        }
        if let status = status {
            queryItems.append(URLQueryItem(name: "status", value: status))
        }
        queryItems.append(URLQueryItem(name: "limit", value: "200"))
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            throw KalshiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add Kalshi API key authentication
        if let keyID = apiKeyID {
            request.addValue(keyID, forHTTPHeaderField: "X-Kalshi-Api-Key-Id")
        }
        
        // Note: Full RSA signature implementation would go here
        // For now, trying with just the key ID to see if Kalshi also supports simpler auth
        // The private key would be used to sign the request timestamp
        // Signature format: KALSHI-ECDSA-SHA256 Signature=<base64_signature>, Timestamp=<timestamp>
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw KalshiError.noData
            }
            
            if httpResponse.statusCode == 401 {
                throw KalshiError.unauthorized
            }
            
            guard httpResponse.statusCode == 200 else {
                let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                throw KalshiError.apiError("Status \(httpResponse.statusCode): \(errorMessage)")
            }
            
            let decoder = JSONDecoder()
            let marketsResponse = try decoder.decode(KalshiMarketsResponse.self, from: data)
            
            return marketsResponse.markets ?? []
            
        } catch let error as KalshiError {
            await MainActor.run {
                self.error = error
            }
            throw error
        } catch let error as DecodingError {
            let kalshiError = KalshiError.decodingError(error)
            await MainActor.run {
                self.error = kalshiError
            }
            throw kalshiError
        } catch {
            let kalshiError = KalshiError.networkError(error)
            await MainActor.run {
                self.error = kalshiError
            }
            throw kalshiError
        }
    }
    
    /// Find markets relevant to a specific prediction
    func findMarketsForPrediction(_ prediction: Prediction) async throws -> [KalshiMarket] {
        let allMarkets = try await fetchNFLMarkets()
        
        // Filter markets that match the teams in the prediction
        let relevantMarkets = allMarkets.filter { market in
            let titleLower = market.title.lowercased()
            let team1Lower = prediction.team1.lowercased()
            let team2Lower = prediction.team2.lowercased()
            
            // Check if market mentions both teams or one of them as winner
            return (titleLower.contains(team1Lower) || titleLower.contains(team2Lower)) ||
                   (TeamNameMapper.matchesTeam(market.title, teamName: prediction.team1) ||
                    TeamNameMapper.matchesTeam(market.title, teamName: prediction.team2))
        }
        
        return relevantMarkets
    }
    
    /// Enrich predictions with Kalshi market data
    func enrichPredictionsWithOdds(_ predictions: [Prediction]) async throws -> [PredictionWithOdds] {
        let allMarkets = try await fetchNFLMarkets()
        
        return predictions.map { prediction in
            // Find markets for this prediction
            let matchingMarkets = allMarkets.filter { market in
                TeamNameMapper.matchesTeam(market.title, teamName: prediction.team1) ||
                TeamNameMapper.matchesTeam(market.title, teamName: prediction.team2)
            }
            
            return PredictionWithOdds(
                prediction: prediction,
                kalshiMarkets: matchingMarkets
            )
        }
    }
    
    // MARK: - API Key Management
    
    func setCredentials(keyID: String, privateKey: String) {
        self.apiKeyID = keyID
        self.privateKey = privateKey
        UserDefaults.standard.set(keyID, forKey: "kalshi_api_key_id")
        UserDefaults.standard.set(privateKey, forKey: "kalshi_private_key")
    }
    
    func getAPIKeyID() -> String? {
        return apiKeyID
    }
    
    func hasAPIKey() -> Bool {
        guard let keyID = apiKeyID, !keyID.isEmpty,
              let privKey = privateKey, !privKey.isEmpty else {
            return false
        }
        return true
    }
    
    // MARK: - Private Helpers
    
    private var currentBaseURL: String {
        useDemo ? demoBaseURL : baseURL
    }
}

// MARK: - Kalshi Authentication Service

class KalshiAuthService {
    static let shared = KalshiAuthService()
    
    private let baseURL = "https://trading-api.kalshi.com"
    private let demoBaseURL = "https://demo-api.kalshi.com"
    
    private init() {}
    
    /// Login to Kalshi and get API token
    /// Note: This is for email/password auth. For API key, use it directly in KalshiService
    func login(email: String, password: String, useDemo: Bool = false) async throws -> String {
        let url = URL(string: "\(useDemo ? demoBaseURL : baseURL)/trade-api/v2/login")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email, "password": password]
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw KalshiError.unauthorized
        }
        
        struct LoginResponse: Codable {
            let token: String
        }
        
        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
        return loginResponse.token
    }
}

