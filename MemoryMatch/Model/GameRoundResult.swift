//
//  GameRoundResult.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import Foundation

public struct PlayerSnapshot: Equatable, Hashable, Codable {
    public let id: UUID?
    public let name: String
    
    public init(id: UUID?, name: String) {
        self.id = id
        self.name = name
    }
}

public struct GameRoundResult: Identifiable, Equatable, Hashable, Codable {
    public let id: UUID
    public let date: Date
    public let mode: GameMode
    public let difficulty: Difficulty
    public let playerOneScore: Int
    public let playerTwoScore: Int
    public let playerOneSnapshot: PlayerSnapshot
    public let playerTwoSnapshot: PlayerSnapshot
    public let winnerId: UUID?
    
    public init(
        id: UUID = UUID(),
        date: Date = Date(),
        mode: GameMode,
        difficulty: Difficulty,
        playerOneScore: Int,
        playerTwoScore: Int,
        playerOneSnapshot: PlayerSnapshot,
        playerTwoSnapshot: PlayerSnapshot,
        winnerId: UUID?
    ) {
        self.id = id
        self.date = date
        self.mode = mode
        self.difficulty = difficulty
        self.playerOneScore = playerOneScore
        self.playerTwoScore = playerTwoScore
        self.playerOneSnapshot = playerOneSnapshot
        self.playerTwoSnapshot = playerTwoSnapshot
        self.winnerId = winnerId
    }
    
    public var isDraw: Bool {
        playerOneScore == playerTwoScore
    }
    
    public var winnerSnapshot: PlayerSnapshot? {
        if isDraw { return nil }
        return playerOneScore > playerTwoScore ? playerOneSnapshot : playerTwoSnapshot
    }
    
    public var winnerTitle: String {
        if isDraw {
            return "It's a draw!"
        }
        guard let winner = winnerSnapshot else { return "Game Over" }
        return "\(winner.name) wins!"
    }
    
    public var scoreHeadline: String {
        "\(playerOneSnapshot.name) \(playerOneScore) – \(playerTwoScore) \(playerTwoSnapshot.name)"
    }
    
    public var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Aggregated Player Statistics
public struct PlayerAggregateStats: Identifiable, Equatable {
    public var id: UUID
    public var name: String
    public var initials: String
    public var wins: Int
    public var pairsMatched: Int
    public var gamesPlayed: Int
    
    public init(id: UUID, name: String, initials: String, wins: Int = 0, pairsMatched: Int = 0, gamesPlayed: Int = 0) {
        self.id = id
        self.name = name
        self.initials = initials
        self.wins = wins
        self.pairsMatched = pairsMatched
        self.gamesPlayed = gamesPlayed
    }
}
