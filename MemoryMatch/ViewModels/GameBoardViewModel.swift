//
//  GameBoardViewModel.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import Combine
import SwiftUI

@MainActor
public final class GameBoardViewModel: ObservableObject {
    @Published public var showPauseOverlay: Bool = false
    @Published public var showRestartConfirmation: Bool = false
    @Published public var showExitConfirmation: Bool = false
    
    public let engine: MemoryGameEngine
    private unowned let appState: AppState
    private var cancellables = Set<AnyCancellable>()
    
    public init(appState: AppState, scheduler: DelaySchedulerProtocol = AsyncDelayScheduler()) {
        self.appState = appState
        self.engine = MemoryGameEngine(
            mode: appState.selectedMode,
            difficulty: appState.selectedDifficulty,
            scheduler: scheduler
        )
        
        bindEngine()
    }
    
    public var playerOne: PlayerProfile {
        appState.playerOne
    }
    
    public var playerTwo: PlayerProfile {
        appState.playerTwo
    }
    
    public var headerTitle: String {
        "\(engine.mode.title) • \(engine.difficulty.title)"
    }
    
    private func bindEngine() {
        engine.$isCompleted
            .filter { $0 }
            .sink { [weak self] _ in
                self?.handleRoundCompletion()
            }
            .store(in: &cancellables)
    }
    
    public func selectCard(_ card: MemoryCard) {
        engine.selectCard(at: card.id)
    }
    
    // MARK: - Pause & Confirmation Flows
    public func pauseGame() {
        engine.pauseGame()
        showPauseOverlay = true
    }
    
    public func resumeGame() {
        engine.resumeGame()
        showPauseOverlay = false
        showRestartConfirmation = false
        showExitConfirmation = false
    }
    
    public func promptRestart() {
        showRestartConfirmation = true
    }
    
    public func confirmRestart() {
        showRestartConfirmation = false
        showPauseOverlay = false
        engine.restartRound()
    }
    
    public func cancelRestart() {
        showRestartConfirmation = false
    }
    
    public func promptExit() {
        showExitConfirmation = true
    }
    
    public func confirmExit() {
        engine.cancelPendingResolutions()
        showExitConfirmation = false
        showPauseOverlay = false
        appState.navigateToHome()
    }
    
    public func cancelExit() {
        showExitConfirmation = false
    }
    
    // MARK: - Completion & Navigation
    private func handleRoundCompletion() {
        let result = engine.generateRoundResult(
            playerOne: appState.playerOne,
            playerTwo: appState.playerTwo
        )
        
        // Persist immediately
        try? appState.roundRepository.save(round: result)
        
        // Small delay to allow final card match animation to settle before navigating
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.appState.navigateToResults(result: result)
        }
    }
}
