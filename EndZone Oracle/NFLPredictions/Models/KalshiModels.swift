//
//  KalshiModels.swift
//  NFLPredictions
//
//  Models for Kalshi prediction market data
//

import Foundation

// MARK: - Kalshi Market Response Models

struct KalshiMarketsResponse: Codable {
    let markets: [KalshiMarket]?
    let cursor: String?
}

struct KalshiOrderbookResponse: Codable {
    let orderbook: KalshiOrderbook?
}

struct KalshiOrderbook: Codable {
    let yes: [KalshiOrder]?
    let no: [KalshiOrder]?

    // Helper to get the best yes price (highest bid)
    var yesBestBid: Int? {
        yes?.first?.price
    }

    // Helper to get the best yes ask (lowest ask)
    var yesBestAsk: Int? {
        yes?.last?.price
    }
}

struct KalshiOrder: Codable {
    let price: Int  // Price in cents (0-100)
    let size: Int   // Size of the order
}

struct KalshiMarket: Codable, Identifiable {
    let ticker: String
    let eventTicker: String
    let title: String
    let subtitle: String?
    let openTime: String?
    let closeTime: String?
    let expirationTime: String?
    let status: String
    let yesSubtitle: String?
    let noSubtitle: String?
    let yesBid: Int?
    let yesAsk: Int?
    let noBid: Int?
    let noAsk: Int?
    let lastPrice: Int?
    let volume: Int?
    let openInterest: Int?
    let liquidityProbability: Double?
    
    var id: String { ticker }
    
    enum CodingKeys: String, CodingKey {
        case ticker
        case eventTicker = "event_ticker"
        case title
        case subtitle
        case openTime = "open_time"
        case closeTime = "close_time"
        case expirationTime = "expiration_time"
        case status
        case yesSubtitle = "yes_sub_title"
        case noSubtitle = "no_sub_title"
        case yesBid = "yes_bid"
        case yesAsk = "yes_ask"
        case noBid = "no_bid"
        case noAsk = "no_ask"
        case lastPrice = "last_price"
        case volume
        case openInterest = "open_interest"
        case liquidityProbability = "liquidity"
    }
    
    // Calculate implied probability from price (prices are in cents, 0-100)
    var impliedProbability: Double? {
        guard let price = lastPrice else { return nil }
        return Double(price) / 100.0
    }
    
    var midPrice: Double? {
        if let bid = yesBid, let ask = yesAsk {
            return Double(bid + ask) / 2.0 / 100.0
        }
        return impliedProbability
    }
}

struct KalshiEvent: Codable, Identifiable {
    let eventTicker: String
    let seriesTicker: String
    let title: String
    let subtitle: String?
    let category: String
    let mutuallyExclusive: Bool
    let strike: String?
    let strikeDate: String?
    
    var id: String { eventTicker }
    
    enum CodingKeys: String, CodingKey {
        case eventTicker = "event_ticker"
        case seriesTicker = "series_ticker"
        case title
        case subtitle
        case category
        case mutuallyExclusive = "mutually_exclusive"
        case strike
        case strikeDate = "strike_date"
    }
}

// MARK: - Enriched Prediction with Kalshi Data

struct PredictionWithOdds: Identifiable {
    let prediction: Prediction
    var kalshiMarkets: [KalshiMarket]
    
    var id: UUID { prediction.id }
    
    // Find the most relevant market for this matchup
    var primaryMarket: KalshiMarket? {
        // Prefer winner markets over other types
        kalshiMarkets.first { market in
            market.title.localizedCaseInsensitiveContains("win") ||
            market.title.localizedCaseInsensitiveContains("winner")
        } ?? kalshiMarkets.first
    }
    
    // Calculate edge (difference between our prediction and market)
    var predictionEdge: Double? {
        guard let marketProb = primaryMarket?.midPrice else { return nil }
        
        // Our model's implied probability for team1
        let team1Points = Double(prediction.team1PredictedPoints)
        let team2Points = Double(prediction.team2PredictedPoints)
        let totalPoints = team1Points + team2Points
        let ourProbability = team1Points / totalPoints
        
        return ourProbability - marketProb
    }
    
    var hasPositiveEdge: Bool {
        guard let edge = predictionEdge else { return false }
        return edge > 0.05 // 5% edge threshold
    }
}

// MARK: - Kalshi API Error

enum KalshiError: Error, LocalizedError {
    case invalidURL
    case unauthorized
    case networkError(Error)
    case decodingError(Error)
    case apiError(String)
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .unauthorized:
            return "Invalid or missing API key"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .apiError(let message):
            return "API error: \(message)"
        case .noData:
            return "No data received from API"
        }
    }
}

// MARK: - Team Name Mapping Helper

struct TeamNameMapper {
    // Map team full names to city names used by Kalshi
    static let teamCityMap: [String: String] = [
        "Arizona Cardinals": "Arizona",
        "Atlanta Falcons": "Atlanta",
        "Baltimore Ravens": "Baltimore",
        "Buffalo Bills": "Buffalo",
        "Carolina Panthers": "Carolina",
        "Chicago Bears": "Chicago",
        "Cincinnati Bengals": "Cincinnati",
        "Cleveland Browns": "Cleveland",
        "Dallas Cowboys": "Dallas",
        "Denver Broncos": "Denver",
        "Detroit Lions": "Detroit",
        "Green Bay Packers": "Green Bay",
        "Houston Texans": "Houston",
        "Indianapolis Colts": "Indianapolis",
        "Jacksonville Jaguars": "Jacksonville",
        "Kansas City Chiefs": "Kansas City",
        "Las Vegas Raiders": "Las Vegas",
        "Los Angeles Chargers": "Los Angeles C",  // Kalshi abbreviates to distinguish from Rams
        "Los Angeles Rams": "Los Angeles R",
        "Miami Dolphins": "Miami",
        "Minnesota Vikings": "Minnesota",
        "New England Patriots": "New England",
        "New Orleans Saints": "New Orleans",
        "New York Giants": "New York G",
        "New York Jets": "New York J",
        "Philadelphia Eagles": "Philadelphia",
        "Pittsburgh Steelers": "Pittsburgh",
        "San Francisco 49ers": "San Francisco",
        "Seattle Seahawks": "Seattle",
        "Tampa Bay Buccaneers": "Tampa Bay",
        "Tennessee Titans": "Tennessee",
        "Washington Commanders": "Washington"
    ]

    static func getCityName(for teamName: String) -> String {
        // Try exact match first
        if let city = teamCityMap[teamName] {
            return city
        }

        // Try to extract city from team name (first word(s) before the team nickname)
        let components = teamName.components(separatedBy: " ")
        if components.count >= 2 {
            // For "Los Angeles Rams", take first 2 words
            if components[0].lowercased() == "los" || components[0].lowercased() == "new" || components[0].lowercased() == "green" || components[0].lowercased() == "kansas" || components[0].lowercased() == "san" || components[0].lowercased() == "tampa" {
                if components.count >= 2 {
                    return components[0] + " " + components[1]
                }
            }
            return components[0]
        }

        return teamName
    }

    static func matchesTeam(_ marketTitle: String, teamName: String) -> Bool {
        let normalizedMarket = marketTitle.lowercased()
        let cityName = getCityName(for: teamName).lowercased()

        // Check if market contains the city name
        // Use word boundaries to avoid partial matches
        let pattern = "\\b\(cityName)\\b"
        if let _ = normalizedMarket.range(of: pattern, options: .regularExpression) {
            return true
        }

        // Also check full team name just in case
        if normalizedMarket.contains(teamName.lowercased()) {
            return true
        }

        return false
    }
}

