//
//  PickBadge.swift
//  NFLPredictions
//
//  Badge to indicate the predicted winner
//

import SwiftUI

struct PickBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.caption2)
            Text("PICK")
                .font(.caption)
                .fontWeight(.bold)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            LinearGradient(
                colors: [Color.yellow, Color.orange],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(8)
    }
}

struct TieBadge: View {
    var body: some View {
        Text("TIE")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(Color.gray)
            .cornerRadius(8)
    }
}

#Preview {
    VStack(spacing: 20) {
        PickBadge()
        TieBadge()
    }
    .padding()
}

