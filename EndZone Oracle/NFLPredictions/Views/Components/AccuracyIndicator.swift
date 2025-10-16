//
//  AccuracyIndicator.swift
//  NFLPredictions
//
//  Component to show if a prediction was correct or incorrect
//

import SwiftUI

struct AccuracyIndicator: View {
    let isCorrect: Bool
    let showLabel: Bool
    
    init(isCorrect: Bool, showLabel: Bool = true) {
        self.isCorrect = isCorrect
        self.showLabel = showLabel
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isCorrect ? .green : .red)
            
            if showLabel {
                Text(isCorrect ? "Prediction Correct!" : "Prediction Incorrect")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isCorrect ? .green : .red)
            }
        }
    }
}

struct ConfidenceBadge: View {
    let confidence: ConfidenceLevel
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: confidence.iconName)
                .font(.caption2)
            Text(confidence.rawValue)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(confidence.color)
        .cornerRadius(8)
    }
}

#Preview {
    VStack(spacing: 20) {
        AccuracyIndicator(isCorrect: true)
        AccuracyIndicator(isCorrect: false)
        AccuracyIndicator(isCorrect: true, showLabel: false)
        
        HStack(spacing: 12) {
            ConfidenceBadge(confidence: .low)
            ConfidenceBadge(confidence: .medium)
            ConfidenceBadge(confidence: .high)
        }
    }
    .padding()
}

