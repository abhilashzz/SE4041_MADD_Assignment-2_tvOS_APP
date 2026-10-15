//
//  LeaderboardViewModel.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public enum ModeFilter: String, CaseIterable, Identifiable {
    case all = "All modes"
    case classic = "Classic"
    case learn = "Learn"
    
    public var id: String { rawValue }
    
    public var gameMode: GameMode? {
        switch self {
        case .all: return nil
        case .classic: return .classic
        case .learn: return .learn
        }
    }
}

public enum DifficultyFilter: String, CaseIterable, Identifiable {
    case all = "All difficulties"
    case sixPairs = "6 pairs"
    case eightPairs = "8 pairs"
    
    public var id: String { rawValue }
    
    public var difficulty: Difficulty? {
        switch self {
        case .all: return nil
        case .sixPairs: return .sixPairs
        case .eightPairs: return .eightPairs
        }
    }
}

@MainActor
public final class LeaderboardViewModel: ObservableObject {
    @Published public var selectedModeFilter: ModeFilter = .all
    @Published public var selectedDifficultyFilter: DifficultyFilter = .all
    
    @Published public var playerStats: [PlayerAggregateStats] = []
    @Published public var recentRounds: [GameRoundResult] = []
    
    // Details & Confirmation Overlays
    @Published public var selectedRoundForDetail: GameRoundResult? = nil
    @Published public var showDeleteRoundConfirmation: Bool = false
    @Published public var showClearAllConfirmation: Bool = false
    @Published public var errorMessage: String? = nil
    
    private unowned let appState: AppState
    private let roundRepository: GameRoundRepositoryProtocol
    
    public init(appState: AppState) {
        self.appState = appState
        self.roundRepository = appState.roundRepository
        refreshData()
    }
    
    public func refreshData() {
        do {
            let mode = selectedModeFilter.gameMode
            let diff = selectedDifficultyFilter.difficulty
            
            self.playerStats = try roundRepository.computeLeaderboard(mode: mode, difficulty: diff)
            self.recentRounds = try roundRepository.fetchAll(mode: mode, difficulty: diff)
            self.errorMessage = nil
        } catch {
            self.errorMessage = "Failed to load leaderboard: \(error.localizedDescription)"
        }
    }
    
    public func setModeFilter(_ filter: ModeFilter) {
        selectedModeFilter = filter
        refreshData()
    }
    
    public func setDifficultyFilter(_ filter: DifficultyFilter) {
        selectedDifficultyFilter = filter
        refreshData()
    }
    
    // MARK: - Round Details & Deletion
    public func openRoundDetail(_ round: GameRoundResult) {
        selectedRoundForDetail = round
        showDeleteRoundConfirmation = false
    }
    
    public func dismissRoundDetail() {
        selectedRoundForDetail = nil
        showDeleteRoundConfirmation = false
    }
    
    public func promptDeleteSelectedRound() {
        showDeleteRoundConfirmation = true
    }
    
    public func confirmDeleteSelectedRound() {
        guard let round = selectedRoundForDetail else { return }
        do {
            try roundRepository.delete(id: round.id)
            selectedRoundForDetail = nil
            showDeleteRoundConfirmation = false
            refreshData()
        } catch {
            errorMessage = "Failed to delete round: \(error.localizedDescription)"
        }
    }
    
    public func cancelDeleteSelectedRound() {
        showDeleteRoundConfirmation = false
    }
    
    // MARK: - Clear All Results
    public func promptClearAll() {
        showClearAllConfirmation = true
    }
    
    public func confirmClearAll() {
        do {
            try roundRepository.clearAll()
            showClearAllConfirmation = false
            selectedRoundForDetail = nil
            refreshData()
        } catch {
            errorMessage = "Failed to clear results: \(error.localizedDescription)"
        }
    }
    
    public func cancelClearAll() {
        showClearAllConfirmation = false
    }
    
    // MARK: - Navigation
    public func back() {
        appState.navigateBackFromLeaderboard()
    }
}
