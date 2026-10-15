//
//  LocalLeaderboardScreen.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct LocalLeaderboardScreen: View {
    @ObservedObject public var viewModel: LeaderboardViewModel
    
    public init(viewModel: LeaderboardViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            // Background
            MemoryMatchTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Top Header Row
                topHeaderRow
                
                // Filter Row (Mode & Difficulty Filters)
                filterBar
                
                // Scrollable Content
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 28) {
                        // Leaderboard Aggregation Table
                        leaderboardTable
                        
                        // Recent Completed Rounds
                        recentRoundsSection
                        
                        // Clear Results Action
                        if !viewModel.recentRounds.isEmpty {
                            Button(action: {
                                viewModel.promptClearAll()
                            }) {
                                HStack(spacing: 10) {
                                    Image(systemName: "trash.fill")
                                    Text("Clear Results")
                                }
                            }
                            .buttonStyle(TVDestructiveButtonStyle())
                            .padding(.top, 8)
                            .padding(.bottom, 24)
                        }
                    }
                    .frame(maxWidth: 1080)
                    .padding(.horizontal, 20)
                }
            }
            .tvSafeScreenPadding()
            
            // Round Detail Modal
            if let selectedRound = viewModel.selectedRoundForDetail {
                RoundDetailModal(
                    round: selectedRound,
                    isConfirmingDelete: viewModel.showDeleteRoundConfirmation,
                    onDeletePrompt: { viewModel.promptDeleteSelectedRound() },
                    onDeleteConfirm: { viewModel.confirmDeleteSelectedRound() },
                    onDeleteCancel: { viewModel.cancelDeleteSelectedRound() },
                    onDismiss: { viewModel.dismissRoundDetail() }
                )
                .transition(.opacity)
            }
            
            // Clear All Confirmation Overlay
            if viewModel.showClearAllConfirmation {
                TVModalOverlay(
                    title: "Clear All Results?",
                    subtitle: "This will permanently erase all match history from this Apple TV",
                    onDismiss: { viewModel.cancelClearAll() }
                ) {
                    VStack(spacing: 24) {
                        Text("This action cannot be undone. All player wins and match statistics will be reset to zero.")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                            .foregroundColor(MemoryMatchTheme.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 24) {
                            Button("Yes, Clear All Results") {
                                viewModel.confirmClearAll()
                            }
                            .buttonStyle(TVDestructiveButtonStyle())
                            
                            Button("Cancel") {
                                viewModel.cancelClearAll()
                            }
                            .buttonStyle(TVSecondaryButtonStyle(minWidth: 160, height: 64))
                        }
                    }
                    .padding(.vertical, 12)
                }
                .transition(.opacity)
            }
        }
    }
    
    // MARK: - Top Header Row
    private var topHeaderRow: some View {
        HStack {
            Button(action: {
                viewModel.back()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                    Text("Back")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                }
            }
            .buttonStyle(TVSmallPillButtonStyle())
            
            Spacer()
            
            Text("Local Leaderboard")
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundColor(MemoryMatchTheme.textPrimary)
            
            Spacer()
            
            // Placeholder for symmetric balance
            Color.clear
                .frame(width: 100, height: 40)
        }
    }
    
    // MARK: - Filter Bar
    private var filterBar: some View {
        HStack(spacing: 24) {
            // Mode Filters
            HStack(spacing: 12) {
                ForEach(ModeFilter.allCases) { filter in
                    Button(action: {
                        viewModel.setModeFilter(filter)
                    }) {
                        Text(filter.rawValue)
                            .font(.system(size: 19, weight: .semibold, design: .rounded))
                            .foregroundColor(viewModel.selectedModeFilter == filter ? MemoryMatchTheme.textDark : MemoryMatchTheme.textSecondary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(viewModel.selectedModeFilter == filter ? MemoryMatchTheme.mintTeal : MemoryMatchTheme.slatePanel)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(viewModel.selectedModeFilter == filter ? Color.white : MemoryMatchTheme.slateBorder, lineWidth: 1.5)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Divider()
                .frame(height: 32)
                .background(MemoryMatchTheme.slateBorder)
            
            // Difficulty Filters
            HStack(spacing: 12) {
                ForEach(DifficultyFilter.allCases) { filter in
                    Button(action: {
                        viewModel.setDifficultyFilter(filter)
                    }) {
                        Text(filter.rawValue)
                            .font(.system(size: 19, weight: .semibold, design: .rounded))
                            .foregroundColor(viewModel.selectedDifficultyFilter == filter ? MemoryMatchTheme.textDark : MemoryMatchTheme.textSecondary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(viewModel.selectedDifficultyFilter == filter ? MemoryMatchTheme.mintTeal : MemoryMatchTheme.slatePanel)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(viewModel.selectedDifficultyFilter == filter ? Color.white : MemoryMatchTheme.slateBorder, lineWidth: 1.5)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 6)
    }
    
    // MARK: - Leaderboard Table
    private var leaderboardTable: some View {
        VStack(spacing: 0) {
            // Table Header
            HStack {
                Text("#")
                    .frame(width: 60, alignment: .leading)
                Text("Player")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Wins")
                    .frame(width: 120, alignment: .trailing)
                Text("Pairs")
                    .frame(width: 120, alignment: .trailing)
                Text("Played")
                    .frame(width: 120, alignment: .trailing)
            }
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .foregroundColor(MemoryMatchTheme.textSecondary)
            .padding(.horizontal, 28)
            .padding(.vertical, 16)
            
            Divider()
                .background(MemoryMatchTheme.slateBorder)
            
            if viewModel.playerStats.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "trophy")
                        .font(.system(size: 40))
                        .foregroundColor(MemoryMatchTheme.textSecondary.opacity(0.5))
                    Text("No player records found for the selected filter.")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(MemoryMatchTheme.textSecondary)
                }
                .padding(.vertical, 36)
            } else {
                ForEach(Array(viewModel.playerStats.enumerated()), id: \.element.id) { index, stat in
                    HStack {
                        // Rank
                        Text("\(index + 1)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(index == 0 ? MemoryMatchTheme.goldTrophy : MemoryMatchTheme.textPrimary)
                            .frame(width: 60, alignment: .leading)
                        
                        // Player Info (Initials & Name)
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(index % 2 == 0 ? MemoryMatchTheme.playerOneTeal : MemoryMatchTheme.playerTwoAmber)
                                    .frame(width: 44, height: 44)
                                
                                Text(stat.initials)
                                    .font(.system(size: 19, weight: .bold, design: .rounded))
                                    .foregroundColor(MemoryMatchTheme.textDark)
                            }
                            
                            Text(stat.name)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(MemoryMatchTheme.textPrimary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Wins
                        Text("\(stat.wins)")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(MemoryMatchTheme.textPrimary)
                            .frame(width: 120, alignment: .trailing)
                        
                        // Pairs
                        Text("\(stat.pairsMatched)")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .foregroundColor(MemoryMatchTheme.textPrimary)
                            .frame(width: 120, alignment: .trailing)
                        
                        // Played
                        Text("\(stat.gamesPlayed)")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                            .foregroundColor(MemoryMatchTheme.textSecondary)
                            .frame(width: 120, alignment: .trailing)
                    }
                    .padding(.horizontal, 28)
                    .padding(.vertical, 16)
                    
                    if index < viewModel.playerStats.count - 1 {
                        Divider()
                            .background(MemoryMatchTheme.slateBorder.opacity(0.5))
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
        .background(MemoryMatchTheme.slatePanel)
        .clipShape(RoundedRectangle(cornerRadius: MemoryMatchTheme.panelCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: MemoryMatchTheme.panelCornerRadius, style: .continuous)
                .stroke(MemoryMatchTheme.slateBorder, lineWidth: 1.5)
        )
    }
    
    // MARK: - Recent Rounds Section
    private var recentRoundsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Recent rounds")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(MemoryMatchTheme.textPrimary)
                .padding(.horizontal, 4)
            
            if viewModel.recentRounds.isEmpty {
                HStack {
                    Spacer()
                    Text("No recent rounds played yet.")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(MemoryMatchTheme.textSecondary)
                    Spacer()
                }
                .padding(.vertical, 24)
                .background(MemoryMatchTheme.slatePanel)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.recentRounds.prefix(6)) { round in
                        Button(action: {
                            viewModel.openRoundDetail(round)
                        }) {
                            HStack(spacing: 20) {
                                // Trophy icon
                                ZStack {
                                    Circle()
                                        .fill(MemoryMatchTheme.goldTrophy.opacity(0.2))
                                        .frame(width: 52, height: 52)
                                    Image(systemName: "trophy.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(MemoryMatchTheme.goldTrophy)
                                }
                                
                                // Scores & Names
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(round.scoreHeadline)
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundColor(MemoryMatchTheme.textPrimary)
                                    
                                    Text("\(round.mode.title) • \(round.difficulty.title) • \(round.formattedDate)")
                                        .font(.system(size: 16, weight: .medium, design: .rounded))
                                        .foregroundColor(MemoryMatchTheme.textSecondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(MemoryMatchTheme.textSecondary)
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(MemoryMatchTheme.slatePanel)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(MemoryMatchTheme.slateBorder, lineWidth: 1.5)
                            )
                        }
                        .buttonStyle(TVSecondaryButtonStyle(minWidth: 400, height: 80))
                    }
                }
            }
        }
    }
}
