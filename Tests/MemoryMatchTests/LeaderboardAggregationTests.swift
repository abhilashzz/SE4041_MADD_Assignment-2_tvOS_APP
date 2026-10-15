//
//  LeaderboardAggregationTests.swift
//  MemoryMatchTests
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import XCTest
@testable import MemoryMatch

final class LeaderboardAggregationTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var roundRepository: GameRoundRepository!
    
    let mayaId = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
    let leoId = UUID(uuidString: "22222222-2222-2222-2222-222222222222")!
    let alexId = UUID(uuidString: "33333333-3333-3333-3333-333333333333")!
    
    override func setUp() {
        super.setUp()
        persistenceController = PersistenceController.createInMemoryController()
        roundRepository = GameRoundRepository(context: persistenceController.viewContext)
    }
    
    override func tearDown() {
        persistenceController = nil
        roundRepository = nil
        super.tearDown()
    }
    
    func testLeaderboardAggregationAndDeterministicRanking() throws {
        // Round 1: Maya (4 pairs) vs Leo (2 pairs) -> Maya wins
        let r1 = GameRoundResult(
            id: UUID(),
            mode: .classic,
            difficulty: .sixPairs,
            playerOneScore: 4,
            playerTwoScore: 2,
            playerOneSnapshot: PlayerSnapshot(id: mayaId, name: "Maya"),
            playerTwoSnapshot: PlayerSnapshot(id: leoId, name: "Leo"),
            winnerId: mayaId
        )
        
        // Round 2: Maya (3 pairs) vs Leo (3 pairs) -> Draw
        let r2 = GameRoundResult(
            id: UUID(),
            mode: .classic,
            difficulty: .sixPairs,
            playerOneScore: 3,
            playerTwoScore: 3,
            playerOneSnapshot: PlayerSnapshot(id: mayaId, name: "Maya"),
            playerTwoSnapshot: PlayerSnapshot(id: leoId, name: "Leo"),
            winnerId: nil // Draw
        )
        
        // Round 3: Leo (5 pairs) vs Alex (3 pairs) -> Leo wins
        let r3 = GameRoundResult(
            id: UUID(),
            mode: .classic,
            difficulty: .eightPairs,
            playerOneScore: 5,
            playerTwoScore: 3,
            playerOneSnapshot: PlayerSnapshot(id: leoId, name: "Leo"),
            playerTwoSnapshot: PlayerSnapshot(id: alexId, name: "Alex"),
            winnerId: leoId
        )
        
        try roundRepository.save(round: r1)
        try roundRepository.save(round: r2)
        try roundRepository.save(round: r3)
        
        let stats = try roundRepository.computeLeaderboard()
        XCTAssertEqual(stats.count, 3)
        
        // Both Maya and Leo have 1 win.
        // Maya pairs: 4 + 3 = 7 pairs.
        // Leo pairs: 2 + 3 + 5 = 10 pairs.
        // With equal wins (1 vs 1), Leo has more pairs (10 > 7), so Leo ranks 1st!
        XCTAssertEqual(stats[0].name, "Leo")
        XCTAssertEqual(stats[0].wins, 1)
        XCTAssertEqual(stats[0].pairsMatched, 10)
        XCTAssertEqual(stats[0].gamesPlayed, 3)
        
        XCTAssertEqual(stats[1].name, "Maya")
        XCTAssertEqual(stats[1].wins, 1)
        XCTAssertEqual(stats[1].pairsMatched, 7)
        XCTAssertEqual(stats[1].gamesPlayed, 2)
        
        XCTAssertEqual(stats[2].name, "Alex")
        XCTAssertEqual(stats[2].wins, 0)
        XCTAssertEqual(stats[2].pairsMatched, 3)
        XCTAssertEqual(stats[2].gamesPlayed, 1)
    }
    
    func testLeaderboardFilteringByModeAndDifficulty() throws {
        // Classic 6 pairs
        let r1 = GameRoundResult(
            id: UUID(),
            mode: .classic,
            difficulty: .sixPairs,
            playerOneScore: 4,
            playerTwoScore: 2,
            playerOneSnapshot: PlayerSnapshot(id: mayaId, name: "Maya"),
            playerTwoSnapshot: PlayerSnapshot(id: leoId, name: "Leo"),
            winnerId: mayaId
        )
        // Learn 8 pairs
        let r2 = GameRoundResult(
            id: UUID(),
            mode: .learn,
            difficulty: .eightPairs,
            playerOneScore: 5,
            playerTwoScore: 3,
            playerOneSnapshot: PlayerSnapshot(id: mayaId, name: "Maya"),
            playerTwoSnapshot: PlayerSnapshot(id: leoId, name: "Leo"),
            winnerId: mayaId
        )
        
        try roundRepository.save(round: r1)
        try roundRepository.save(round: r2)
        
        // Filter by Classic mode only
        let classicStats = try roundRepository.computeLeaderboard(mode: .classic, difficulty: nil)
        XCTAssertEqual(classicStats.count, 2)
        let mayaClassic = classicStats.first { $0.id == mayaId }
        XCTAssertEqual(mayaClassic?.pairsMatched, 4)
        XCTAssertEqual(mayaClassic?.gamesPlayed, 1)
        
        // Filter by 8 pairs difficulty only
        let eightPairStats = try roundRepository.computeLeaderboard(mode: nil, difficulty: .eightPairs)
        XCTAssertEqual(eightPairStats.count, 2)
        let mayaEight = eightPairStats.first { $0.id == mayaId }
        XCTAssertEqual(mayaEight?.pairsMatched, 5)
        XCTAssertEqual(mayaEight?.gamesPlayed, 1)
    }
    
    func testRecalculationImmediatelyAfterDeletion() throws {
        let r1 = GameRoundResult(
            id: UUID(),
            mode: .classic,
            difficulty: .sixPairs,
            playerOneScore: 4,
            playerTwoScore: 2,
            playerOneSnapshot: PlayerSnapshot(id: mayaId, name: "Maya"),
            playerTwoSnapshot: PlayerSnapshot(id: leoId, name: "Leo"),
            winnerId: mayaId
        )
        try roundRepository.save(round: r1)
        XCTAssertEqual(try roundRepository.computeLeaderboard().count, 2)
        
        try roundRepository.delete(id: r1.id)
        XCTAssertEqual(try roundRepository.computeLeaderboard().count, 0)
    }
}
