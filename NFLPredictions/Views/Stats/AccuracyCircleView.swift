//
//  AccuracyCircleView.swift
//  NFLPredictions
//
//  Circular progress view for accuracy percentage
//

import SwiftUI

struct AccuracyCircleView: View {
    let accuracy: Double
    let totalGames: Int
    let correctPredictions: Int
    
    @State private var animatedAccuracy: Double = 0
    
    private var color: Color {
        if accuracy >= 0.7 { return .green }
        else if accuracy >= 0.5 { return .orange }
        else { return .red }
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color.secondary.opacity(0.2), lineWidth: 20)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: animatedAccuracy)
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: animatedAccuracy)
            
            // Center content
            VStack(spacing: 8) {
                Text(String(format: "%.1f%%", animatedAccuracy * 100))
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(color)
                
                Text("Accuracy")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text("\(correctPredictions) of \(totalGames)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 200, height: 200)
        .onAppear {
            withAnimation {
                animatedAccuracy = accuracy
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        AccuracyCircleView(accuracy: 0.75, totalGames: 45, correctPredictions: 34)
        AccuracyCircleView(accuracy: 0.55, totalGames: 20, correctPredictions: 11)
        AccuracyCircleView(accuracy: 0.35, totalGames: 10, correctPredictions: 3)
    }
    .padding()
}


