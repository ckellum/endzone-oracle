//
//  NFLTeams.swift
//  NFLPredictions
//
//  NFL team data including colors and metadata
//

import SwiftUI

struct NFLTeam: Identifiable {
    let id = UUID()
    let name: String
    let abbreviation: String
    let primaryColor: Color
    let secondaryColor: Color
    let helmetAssetName: String
}

class NFLTeams {
    static let allTeams: [NFLTeam] = [
        // AFC East
        NFLTeam(name: "Buffalo Bills", abbreviation: "BUF", 
                primaryColor: Color(hex: "00338D"), secondaryColor: Color(hex: "C60C30"),
                helmetAssetName: "bills"),
        NFLTeam(name: "Miami Dolphins", abbreviation: "MIA",
                primaryColor: Color(hex: "008E97"), secondaryColor: Color(hex: "FC4C02"),
                helmetAssetName: "dolphins"),
        NFLTeam(name: "New England Patriots", abbreviation: "NE",
                primaryColor: Color(hex: "002244"), secondaryColor: Color(hex: "C60C30"),
                helmetAssetName: "patriots"),
        NFLTeam(name: "New York Jets", abbreviation: "NYJ",
                primaryColor: Color(hex: "125740"), secondaryColor: Color(hex: "FFFFFF"),
                helmetAssetName: "jets"),
        
        // AFC North
        NFLTeam(name: "Baltimore Ravens", abbreviation: "BAL",
                primaryColor: Color(hex: "241773"), secondaryColor: Color(hex: "000000"),
                helmetAssetName: "ravens"),
        NFLTeam(name: "Cincinnati Bengals", abbreviation: "CIN",
                primaryColor: Color(hex: "FB4F14"), secondaryColor: Color(hex: "000000"),
                helmetAssetName: "bengals"),
        NFLTeam(name: "Cleveland Browns", abbreviation: "CLE",
                primaryColor: Color(hex: "311D00"), secondaryColor: Color(hex: "FF3C00"),
                helmetAssetName: "browns"),
        NFLTeam(name: "Pittsburgh Steelers", abbreviation: "PIT",
                primaryColor: Color(hex: "FFB612"), secondaryColor: Color(hex: "000000"),
                helmetAssetName: "steelers"),
        
        // AFC South
        NFLTeam(name: "Houston Texans", abbreviation: "HOU",
                primaryColor: Color(hex: "03202F"), secondaryColor: Color(hex: "A71930"),
                helmetAssetName: "texans"),
        NFLTeam(name: "Indianapolis Colts", abbreviation: "IND",
                primaryColor: Color(hex: "002C5F"), secondaryColor: Color(hex: "A2AAAD"),
                helmetAssetName: "colts"),
        NFLTeam(name: "Jacksonville Jaguars", abbreviation: "JAX",
                primaryColor: Color(hex: "006778"), secondaryColor: Color(hex: "D7A22A"),
                helmetAssetName: "jaguars"),
        NFLTeam(name: "Tennessee Titans", abbreviation: "TEN",
                primaryColor: Color(hex: "0C2340"), secondaryColor: Color(hex: "4B92DB"),
                helmetAssetName: "titans"),
        
        // AFC West
        NFLTeam(name: "Denver Broncos", abbreviation: "DEN",
                primaryColor: Color(hex: "FB4F14"), secondaryColor: Color(hex: "002244"),
                helmetAssetName: "broncos"),
        NFLTeam(name: "Kansas City Chiefs", abbreviation: "KC",
                primaryColor: Color(hex: "E31837"), secondaryColor: Color(hex: "FFB81C"),
                helmetAssetName: "chiefs"),
        NFLTeam(name: "Las Vegas Raiders", abbreviation: "LV",
                primaryColor: Color(hex: "000000"), secondaryColor: Color(hex: "A5ACAF"),
                helmetAssetName: "raiders"),
        NFLTeam(name: "Los Angeles Chargers", abbreviation: "LAC",
                primaryColor: Color(hex: "0080C6"), secondaryColor: Color(hex: "FFC20E"),
                helmetAssetName: "chargers"),
        
        // NFC East
        NFLTeam(name: "Dallas Cowboys", abbreviation: "DAL",
                primaryColor: Color(hex: "041E42"), secondaryColor: Color(hex: "869397"),
                helmetAssetName: "cowboys"),
        NFLTeam(name: "New York Giants", abbreviation: "NYG",
                primaryColor: Color(hex: "0B2265"), secondaryColor: Color(hex: "A71930"),
                helmetAssetName: "giants"),
        NFLTeam(name: "Philadelphia Eagles", abbreviation: "PHI",
                primaryColor: Color(hex: "004C54"), secondaryColor: Color(hex: "A5ACAF"),
                helmetAssetName: "eagles"),
        NFLTeam(name: "Washington Commanders", abbreviation: "WAS",
                primaryColor: Color(hex: "5A1414"), secondaryColor: Color(hex: "FFB612"),
                helmetAssetName: "commanders"),
        
        // NFC North
        NFLTeam(name: "Chicago Bears", abbreviation: "CHI",
                primaryColor: Color(hex: "0B162A"), secondaryColor: Color(hex: "C83803"),
                helmetAssetName: "bears"),
        NFLTeam(name: "Detroit Lions", abbreviation: "DET",
                primaryColor: Color(hex: "0076B6"), secondaryColor: Color(hex: "B0B7BC"),
                helmetAssetName: "lions"),
        NFLTeam(name: "Green Bay Packers", abbreviation: "GB",
                primaryColor: Color(hex: "203731"), secondaryColor: Color(hex: "FFB612"),
                helmetAssetName: "packers"),
        NFLTeam(name: "Minnesota Vikings", abbreviation: "MIN",
                primaryColor: Color(hex: "4F2683"), secondaryColor: Color(hex: "FFC62F"),
                helmetAssetName: "vikings"),
        
        // NFC South
        NFLTeam(name: "Atlanta Falcons", abbreviation: "ATL",
                primaryColor: Color(hex: "A71930"), secondaryColor: Color(hex: "000000"),
                helmetAssetName: "falcons"),
        NFLTeam(name: "Carolina Panthers", abbreviation: "CAR",
                primaryColor: Color(hex: "0085CA"), secondaryColor: Color(hex: "101820"),
                helmetAssetName: "panthers"),
        NFLTeam(name: "New Orleans Saints", abbreviation: "NO",
                primaryColor: Color(hex: "D3BC8D"), secondaryColor: Color(hex: "101820"),
                helmetAssetName: "saints"),
        NFLTeam(name: "Tampa Bay Buccaneers", abbreviation: "TB",
                primaryColor: Color(hex: "D50A0A"), secondaryColor: Color(hex: "34302B"),
                helmetAssetName: "buccaneers"),
        
        // NFC West
        NFLTeam(name: "Arizona Cardinals", abbreviation: "ARI",
                primaryColor: Color(hex: "97233F"), secondaryColor: Color(hex: "000000"),
                helmetAssetName: "cardinals"),
        NFLTeam(name: "Los Angeles Rams", abbreviation: "LAR",
                primaryColor: Color(hex: "003594"), secondaryColor: Color(hex: "FFA300"),
                helmetAssetName: "rams"),
        NFLTeam(name: "San Francisco 49ers", abbreviation: "SF",
                primaryColor: Color(hex: "AA0000"), secondaryColor: Color(hex: "B3995D"),
                helmetAssetName: "49ers"),
        NFLTeam(name: "Seattle Seahawks", abbreviation: "SEA",
                primaryColor: Color(hex: "002244"), secondaryColor: Color(hex: "69BE28"),
                helmetAssetName: "seahawks"),
    ]
    
    static func team(named name: String) -> NFLTeam? {
        return allTeams.first { $0.name.lowercased() == name.lowercased() }
    }
    
    static func team(byAbbreviation abbr: String) -> NFLTeam? {
        return allTeams.first { $0.abbreviation.lowercased() == abbr.lowercased() }
    }
}

