//
//  StatCard.swift
//  NFLPredictions
//
//  Reusable card component for displaying stats
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 16) {
            StatCard(title: "Total Games", value: "45", icon: "football.fill", color: .blue)
            StatCard(title: "Correct", value: "31", icon: "checkmark.circle.fill", color: .green)
        }
        
        VStack(spacing: 8) {
            InfoRow(label: "Accuracy", value: "68.9%")
            InfoRow(label: "Current Streak", value: "5")
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
    .padding()
    .background(Color.appBackground)
}

