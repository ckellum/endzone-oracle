//
//  StatsDashboardView.swift
//  NFLPredictions
//
//  Main statistics dashboard view
//

import SwiftUI

struct StatsDashboardView: View {
    @ObservedObject var viewModel: StatsViewModel
    
    var body: some View {
        ScrollView {
            if !viewModel.hasData {
                emptyStateView
            } else {
                LazyVStack(spacing: 20) {
                    // Overall accuracy card
                    overallPerformanceCard
                    
                    // Quick stats grid
                    quickStatsGrid
                    
                    // Performance chart
                    PerformanceChartView(results: viewModel.dataPersistenceService.savedResults)
                        .padding(.horizontal)
                    
                    // Best and worst predictions
                    insightsSection
                    
                    // Team stats
                    TeamStatsListView(teamStats: viewModel.teamStats)
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.large)
        .refreshable {
            viewModel.refreshData()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No Statistics Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Enter game results to see performance statistics")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxHeight: .infinity)
    }
    
    private var overallPerformanceCard: some View {
        VStack(spacing: 20) {
            Text("Overall Performance")
                .font(.title2)
                .fontWeight(.bold)
            
            AccuracyCircleView(
                accuracy: viewModel.accuracyStats.accuracy,
                totalGames: viewModel.accuracyStats.totalGames,
                correctPredictions: viewModel.accuracyStats.correctPredictions
            )
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .padding(.horizontal)
    }
    
    private var quickStatsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StatCard(
                title: "Total Games",
                value: "\(viewModel.accuracyStats.totalGames)",
                icon: "football.fill",
                color: .blue
            )
            
            StatCard(
                title: "Correct",
                value: "\(viewModel.accuracyStats.correctPredictions)",
                icon: "checkmark.circle.fill",
                color: .green
            )
            
            StatCard(
                title: "Incorrect",
                value: "\(viewModel.accuracyStats.incorrectPredictions)",
                icon: "xmark.circle.fill",
                color: .red
            )
            
            StatCard(
                title: "Current Streak",
                value: "\(viewModel.accuracyStats.currentStreak)",
                icon: "flame.fill",
                color: .orange
            )
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights")
                .font(.headline)
            
            VStack(spacing: 12) {
                // Average errors
                insightRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Avg Point Error",
                    value: String(format: "±%.1f points", viewModel.accuracyStats.averagePointError),
                    color: .blue
                )
                
                insightRow(
                    icon: "sum",
                    title: "Avg Total Points Error",
                    value: String(format: "±%.1f points", viewModel.accuracyStats.averageTotalPointsError),
                    color: .purple
                )
                
                insightRow(
                    icon: "trophy.fill",
                    title: "Best Streak",
                    value: "\(viewModel.accuracyStats.bestStreak) games",
                    color: .yellow
                )
                
                // Best prediction
                if let best = viewModel.bestPrediction {
                    Divider()
                        .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Best Prediction")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        
                        Text("\(best.team1Name) \(best.team1PredictedScore) - \(best.team2PredictedScore) \(best.team2Name)")
                            .font(.caption)
                        Text("Actual: \(best.team1ActualScore) - \(best.team2ActualScore)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Worst prediction
                if let worst = viewModel.worstPrediction {
                    Divider()
                        .padding(.vertical, 4)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("Biggest Miss")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        
                        Text("\(worst.team1Name) \(worst.team1PredictedScore) - \(worst.team2PredictedScore) \(worst.team2Name)")
                            .font(.caption)
                        Text("Actual: \(worst.team1ActualScore) - \(worst.team2ActualScore)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func insightRow(icon: String, title: String, value: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    NavigationStack {
        StatsDashboardView(viewModel: StatsViewModel())
    }
}

