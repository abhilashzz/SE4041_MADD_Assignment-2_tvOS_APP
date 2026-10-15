//
//  ResultsScreen.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct ResultsScreen: View {
    @ObservedObject public var viewModel: ResultsViewModel
    
    public init(viewModel: ResultsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            // Background
            MemoryMatchTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer()
                
                // Top Tag: "ROUND COMPLETE"
                Text("ROUND COMPLETE")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textSecondary)
                    .tracking(3)
                
                // Golden Trophy with Confetti Celebration
                ZStack {
                    ConfettiView()
                        .frame(width: 400, height: 200)
                    
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 96))
                        .foregroundColor(MemoryMatchTheme.goldTrophy)
                        .shadow(color: MemoryMatchTheme.goldTrophy.opacity(0.4), radius: 24, x: 0, y: 10)
                }
                .frame(height: 180)
                
                // Winner Announcement Headline
                Text(viewModel.result.winnerTitle)
                    .font(.system(size: 56, weight: .heavy, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textPrimary)
                
                // Player Result Cards
                HStack(spacing: 36) {
                    playerScoreCard(
                        snapshot: viewModel.result.playerOneSnapshot,
                        score: viewModel.result.playerOneScore,
                        accentColor: MemoryMatchTheme.playerOneTeal
                    )
                    
                    playerScoreCard(
                        snapshot: viewModel.result.playerTwoSnapshot,
                        score: viewModel.result.playerTwoScore,
                        accentColor: MemoryMatchTheme.playerTwoAmber
                    )
                }
                
                // Mode & Difficulty Subtitle
                Text("\(viewModel.result.mode.title) • \(viewModel.result.difficulty.title)")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textSecondary)
                
                // Real Persistence Save Status
                saveStatusView
                
                // Bottom Action Buttons
                HStack(spacing: 24) {
                    Button(action: {
                        viewModel.playAgain()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 22))
                            Text("Play Again")
                        }
                    }
                    .buttonStyle(TVPrimaryButtonStyle(minWidth: 260, height: 68))
                    
                    Button(action: {
                        viewModel.openLeaderboard()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 20))
                            Text("Leaderboard")
                        }
                    }
                    .buttonStyle(TVSecondaryButtonStyle(minWidth: 220, height: 68))
                    
                    Button(action: {
                        viewModel.goHome()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "house.fill")
                                .font(.system(size: 20))
                            Text("Home")
                        }
                    }
                    .buttonStyle(TVSecondaryButtonStyle(minWidth: 200, height: 68))
                }
                .padding(.top, 12)
                
                Spacer()
            }
            .tvSafeScreenPadding()
        }
    }
    
    // MARK: - Player Score Card Component
    private func playerScoreCard(
        snapshot: PlayerSnapshot,
        score: Int,
        accentColor: Color
    ) -> some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(accentColor)
                    .frame(width: 58, height: 58)
                
                Text(initials(from: snapshot.name))
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textDark)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(snapshot.name)
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textSecondary)
                
                Text("\(score) pairs")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textPrimary)
            }
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 16)
        .frame(minWidth: 260, minHeight: 90)
        .background(MemoryMatchTheme.slatePanel)
        .clipShape(RoundedRectangle(cornerRadius: MemoryMatchTheme.panelCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: MemoryMatchTheme.panelCornerRadius, style: .continuous)
                .stroke(MemoryMatchTheme.slateBorder, lineWidth: 1.5)
        )
    }
    
    // MARK: - Save Status View
    @ViewBuilder
    private var saveStatusView: some View {
        switch viewModel.saveStatus {
        case .saving:
            HStack(spacing: 8) {
                ProgressView()
                    .scaleEffect(0.8)
                Text("Saving round to storage...")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textSecondary)
            }
        case .saved:
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(MemoryMatchTheme.mintTeal)
                Text("Round saved")
                    .font(.system(size: 19, weight: .semibold, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textPrimary)
            }
        case .failed(let message):
            HStack(spacing: 14) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(MemoryMatchTheme.destructiveRed)
                Text("Failed to save: \(message)")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.destructiveRed)
                
                Button("Retry Save") {
                    viewModel.retrySave()
                }
                .buttonStyle(TVSmallPillButtonStyle())
            }
        }
    }
    
    private func initials(from name: String) -> String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "?" }
        let components = trimmed.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        if components.count >= 2 {
            let first = components[0].prefix(1)
            let second = components[1].prefix(1)
            return "\(first)\(second)".uppercased()
        } else {
            return String(trimmed.prefix(1)).uppercased()
        }
    }
}
