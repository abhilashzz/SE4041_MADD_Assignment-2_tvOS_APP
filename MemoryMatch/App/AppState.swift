//
//  AppState.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public enum LeaderboardOrigin {
    case home
    case results
}

public enum AppRoute: Equatable {
    case home
    case playerSetup
    case gameBoard
    case results
    case leaderboard(origin: LeaderboardOrigin)
}

@MainActor
public final class AppState: ObservableObject {
    // MARK: - Navigation
    @Published public var currentRoute: AppRoute = .home
    
    // MARK: - Game Configuration
    @Published public var selectedMode: GameMode = .classic
    @Published public var selectedDifficulty: Difficulty = .sixPairs
    
    // MARK: - Current Players
    @Published public var playerOne: PlayerProfile = PlayerProfile.defaultPlayerOne
    @Published public var playerTwo: PlayerProfile = PlayerProfile.defaultPlayerTwo
    
    // MARK: - Active Round Result (for Results screen)
    @Published public var latestRoundResult: GameRoundResult?
    
    // MARK: - Repositories
    public let playerRepository: PlayerProfileRepositoryProtocol
    public let roundRepository: GameRoundRepositoryProtocol
    
    public init(
        playerRepository: PlayerProfileRepositoryProtocol = PlayerProfileRepository(),
        roundRepository: GameRoundRepositoryProtocol = GameRoundRepository()
    ) {
        self.playerRepository = playerRepository
        self.roundRepository = roundRepository
        
        // Ensure initial defaults exist
        try? playerRepository.seedDefaultsIfNeeded()
        loadInitialPlayers()
    }
    
    public func loadInitialPlayers() {
        if let profiles = try? playerRepository.fetchAll(), profiles.count >= 2 {
            self.playerOne = profiles[0]
            self.playerTwo = profiles[1]
        } else if let profiles = try? playerRepository.fetchAll(), profiles.count == 1 {
            self.playerOne = profiles[0]
            self.playerTwo = PlayerProfile.defaultPlayerTwo
        }
    }
    
    // MARK: - Navigation Actions
    public func navigateToHome() {
        currentRoute = .home
    }
    
    public func navigateToPlayerSetup() {
        currentRoute = .playerSetup
    }
    
    public func navigateToGameBoard() {
        currentRoute = .gameBoard
    }
    
    public func navigateToResults(result: GameRoundResult) {
        self.latestRoundResult = result
        currentRoute = .results
    }
    
    public func navigateToLeaderboard(origin: LeaderboardOrigin) {
        currentRoute = .leaderboard(origin: origin)
    }
    
    public func navigateBackFromLeaderboard() {
        if case .leaderboard(let origin) = currentRoute {
            switch origin {
            case .home:
                currentRoute = .home
            case .results:
                currentRoute = .results
            }
        } else {
            currentRoute = .home
        }
    }
}
