//
//  CoreDataPersistenceTests.swift
//  MemoryMatchTests
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import CoreData
import XCTest
@testable import MemoryMatch

final class CoreDataPersistenceTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    var playerRepository: PlayerProfileRepository!
    var roundRepository: GameRoundRepository!
    
    override func setUp() {
        super.setUp()
        persistenceController = PersistenceController.createInMemoryController()
        playerRepository = PlayerProfileRepository(context: persistenceController.viewContext)
        roundRepository = GameRoundRepository(context: persistenceController.viewContext)
    }
    
    override func tearDown() {
        persistenceController = nil
        playerRepository = nil
        roundRepository = nil
        super.tearDown()
    }
    
    func testSeedDefaultsIfNeededCreatesMayaAndLeo() throws {
        try playerRepository.seedDefaultsIfNeeded()
        let profiles = try playerRepository.fetchAll()
        
        XCTAssertEqual(profiles.count, 2)
        XCTAssertEqual(profiles[0].name, "Maya")
        XCTAssertEqual(profiles[1].name, "Leo")
        
        // Seeding a second time must not duplicate
        try playerRepository.seedDefaultsIfNeeded()
        let profilesAfter = try playerRepository.fetchAll()
        XCTAssertEqual(profilesAfter.count, 2)
    }
    
    func testPlayerProfileCreateReadUpdate() throws {
        let created = try playerRepository.create(name: "Charlie")
        XCTAssertEqual(created.name, "Charlie")
        
        let fetched = try playerRepository.fetch(by: created.id)
        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.name, "Charlie")
        
        let updated = try playerRepository.update(id: created.id, newName: "Charlie Brown")
        XCTAssertEqual(updated.name, "Charlie Brown")
        
        let fetchedAfter = try playerRepository.fetch(by: created.id)
        XCTAssertEqual(fetchedAfter?.name, "Charlie Brown")
    }
    
    func testSaveRoundAndDeduplicationByUUID() throws {
        let roundId = UUID()
        let p1 = PlayerSnapshot(id: UUID(), name: "Maya")
        let p2 = PlayerSnapshot(id: UUID(), name: "Leo")
        
        let round = GameRoundResult(
            id: roundId,
            date: Date(),
            mode: .classic,
            difficulty: .sixPairs,
            playerOneScore: 4,
            playerTwoScore: 2,
            playerOneSnapshot: p1,
            playerTwoSnapshot: p2,
            winnerId: p1.id
        )
        
        // Save first time
        try roundRepository.save(round: round)
        var rounds = try roundRepository.fetchAll()
        XCTAssertEqual(rounds.count, 1)
        
        // Save second time with same UUID (idempotency check)
        try roundRepository.save(round: round)
        rounds = try roundRepository.fetchAll()
        XCTAssertEqual(rounds.count, 1, "Idempotent save must not create duplicate records for same round UUID")
    }
    
    func testProfileDeletionPreservesHistoricalRoundSnapshots() throws {
        let p1 = try playerRepository.create(name: "Maya")
        let p2 = try playerRepository.create(name: "Leo")
        
        let roundId = UUID()
        let round = GameRoundResult(
            id: roundId,
            date: Date(),
            mode: .classic,
            difficulty: .sixPairs,
            playerOneScore: 4,
            playerTwoScore: 2,
            playerOneSnapshot: PlayerSnapshot(id: p1.id, name: p1.name),
            playerTwoSnapshot: PlayerSnapshot(id: p2.id, name: p2.name),
            winnerId: p1.id
        )
        
        try roundRepository.save(round: round)
        
        // Delete Player 1 profile
        try playerRepository.delete(id: p1.id)
        
        // Profile is gone
        let fetchedP1 = try playerRepository.fetch(by: p1.id)
        XCTAssertNil(fetchedP1)
        
        // Historical round is preserved with name snapshots!
        let rounds = try roundRepository.fetchAll()
        XCTAssertEqual(rounds.count, 1)
        XCTAssertEqual(rounds[0].playerOneSnapshot.name, "Maya")
        XCTAssertEqual(rounds[0].playerTwoSnapshot.name, "Leo")
        XCTAssertEqual(rounds[0].playerOneScore, 4)
        XCTAssertEqual(rounds[0].playerTwoScore, 2)
    }
    
    func testDeleteSingleRoundAndClearAll() throws {
        let r1 = GameRoundResult(
            id: UUID(),
            mode: .classic,
            difficulty: .sixPairs,
            playerOneScore: 4,
            playerTwoScore: 2,
            playerOneSnapshot: PlayerSnapshot(id: UUID(), name: "Maya"),
            playerTwoSnapshot: PlayerSnapshot(id: UUID(), name: "Leo"),
            winnerId: nil
        )
        let r2 = GameRoundResult(
            id: UUID(),
            mode: .learn,
            difficulty: .eightPairs,
            playerOneScore: 5,
            playerTwoScore: 3,
            playerOneSnapshot: PlayerSnapshot(id: UUID(), name: "Maya"),
            playerTwoSnapshot: PlayerSnapshot(id: UUID(), name: "Leo"),
            winnerId: nil
        )
        
        try roundRepository.save(round: r1)
        try roundRepository.save(round: r2)
        XCTAssertEqual(try roundRepository.fetchAll().count, 2)
        
        // Delete r1
        try roundRepository.delete(id: r1.id)
        let remaining = try roundRepository.fetchAll()
        XCTAssertEqual(remaining.count, 1)
        XCTAssertEqual(remaining[0].id, r2.id)
        
        // Clear all
        try roundRepository.clearAll()
        XCTAssertEqual(try roundRepository.fetchAll().count, 0)
    }
}
