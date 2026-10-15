//
//  ResultsViewModel.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public enum SaveStatus: Equatable {
    case saving
    case saved
    case failed(message: String)
}

@MainActor
public final class ResultsViewModel: ObservableObject {
    @Published public var saveStatus: SaveStatus = .saved
    
    public let result: GameRoundResult
    private unowned let appState: AppState
    private let roundRepository: GameRoundRepositoryProtocol
    
    public init(appState: AppState, roundRepository: GameRoundRepositoryProtocol? = nil) {
        self.appState = appState
        self.roundRepository = roundRepository ?? appState.roundRepository
        
        if let current = appState.latestRoundResult {
            self.result = current
        } else {
            // Fallback preview result
            self.result = GameRoundResult(
                id: UUID(),
                date: Date(),
                mode: appState.selectedMode,
                difficulty: appState.selectedDifficulty,
                playerOneScore: 4,
                playerTwoScore: 2,
                playerOneSnapshot: PlayerSnapshot(id: appState.playerOne.id, name: appState.playerOne.name),
                playerTwoSnapshot: PlayerSnapshot(id: appState.playerTwo.id, name: appState.playerTwo.name),
                winnerId: appState.playerOne.id
            )
        }
        
        // Ensure saved
        persistRound()
    }
    
    public func persistRound() {
        saveStatus = .saving
        do {
            try roundRepository.save(round: result)
            saveStatus = .saved
        } catch {
            saveStatus = .failed(message: error.localizedDescription)
        }
    }
    
    public func retrySave() {
        persistRound()
    }
    
    public func playAgain() {
        appState.navigateToGameBoard()
    }
    
    public func openLeaderboard() {
        appState.navigateToLeaderboard(origin: .results)
    }
    
    public func goHome() {
        appState.navigateToHome()
    }
}
