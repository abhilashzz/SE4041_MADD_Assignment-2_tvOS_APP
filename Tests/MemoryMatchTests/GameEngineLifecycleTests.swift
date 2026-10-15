//
//  GameEngineLifecycleTests.swift
//  MemoryMatchTests
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import XCTest
@testable import MemoryMatch

final class GameEngineLifecycleTests: XCTestCase {
    
    func testPausePreventsCardSelectionUntilResumed() {
        let engine = MemoryGameEngine(mode: .classic, difficulty: .sixPairs)
        
        engine.pauseGame()
        XCTAssertTrue(engine.isPaused)
        
        let card = engine.cards[0]
        let selectedWhilePaused = engine.selectCard(at: card.id)
        XCTAssertFalse(selectedWhilePaused, "Card selection must be ignored while game is paused")
        XCTAssertFalse(engine.cards[0].isRevealed)
        
        engine.resumeGame()
        XCTAssertFalse(engine.isPaused)
        
        let selectedAfterResume = engine.selectCard(at: card.id)
        XCTAssertTrue(selectedAfterResume, "Card selection must work normally after game is resumed")
        XCTAssertTrue(engine.cards[0].isRevealed)
    }
    
    func testRestartGeneratesNewRoundUUIDAndResetsScores() {
        let engine = MemoryGameEngine(mode: .classic, difficulty: .sixPairs)
        let initialRoundId = engine.roundId
        
        _ = engine.selectCard(at: engine.cards[0].id)
        
        engine.restartRound()
        
        XCTAssertNotEqual(engine.roundId, initialRoundId, "Restart must assign a new round UUID")
        XCTAssertEqual(engine.playerOneScore, 0)
        XCTAssertEqual(engine.playerTwoScore, 0)
        XCTAssertEqual(engine.currentPlayer, .playerOne)
        XCTAssertNil(engine.firstRevealedCardId)
        XCTAssertNil(engine.secondRevealedCardId)
        XCTAssertFalse(engine.isResolvingMismatch)
        XCTAssertFalse(engine.isPaused)
        XCTAssertFalse(engine.isCompleted)
        XCTAssertTrue(engine.cards.allSatisfy { !$0.isRevealed && !$0.isMatched })
    }
    
    func testStaleCallbacksFromOldRoundCannotMutateNewRound() {
        let scheduler = ImmediateDelayScheduler(executeImmediately: false)
        let engine = MemoryGameEngine(
            mode: .classic,
            difficulty: .sixPairs,
            scheduler: scheduler,
            shuffle: { $0 }
        )
        
        // Trigger mismatch in Round 1 (Card 0 & Card 2)
        _ = engine.selectCard(at: engine.cards[0].id)
        _ = engine.selectCard(at: engine.cards[2].id)
        XCTAssertTrue(engine.isResolvingMismatch)
        
        // User restarts before delayed mismatch callback fires!
        engine.restartRound()
        XCTAssertFalse(engine.isResolvingMismatch)
        
        // Old delayed callback now executes (scheduler flushes queue)
        scheduler.flush()
        
        // The old callback must check roundId and abort! Current player should remain player 1, not be switched to player 2!
        XCTAssertEqual(engine.currentPlayer, .playerOne, "Stale callback must not switch players or mutate cards in a new round")
        XCTAssertFalse(engine.isResolvingMismatch)
    }
    
    func testCancelPendingResolutionsClearsLockWithoutPermanentFreeze() {
        let scheduler = ImmediateDelayScheduler(executeImmediately: false)
        let engine = MemoryGameEngine(
            mode: .classic,
            difficulty: .sixPairs,
            scheduler: scheduler,
            shuffle: { $0 }
        )
        
        // Trigger mismatch
        _ = engine.selectCard(at: engine.cards[0].id)
        _ = engine.selectCard(at: engine.cards[2].id)
        XCTAssertTrue(engine.isResolvingMismatch)
        
        // User pauses or navigates away -> cancel resolutions
        engine.cancelPendingResolutions()
        
        XCTAssertFalse(engine.isResolvingMismatch, "Resolution lock must be released immediately")
        XCTAssertNil(engine.firstRevealedCardId)
        XCTAssertNil(engine.secondRevealedCardId)
        
        // Board can be played again without being locked
        let nextSelection = engine.selectCard(at: engine.cards[4].id)
        XCTAssertTrue(nextSelection, "Board must not be permanently frozen after cancelling pending work")
    }
}
