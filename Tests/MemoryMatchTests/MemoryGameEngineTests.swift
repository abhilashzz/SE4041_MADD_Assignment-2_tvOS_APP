//
//  MemoryGameEngineTests.swift
//  MemoryMatchTests
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import XCTest
@testable import MemoryMatch

final class MemoryGameEngineTests: XCTestCase {
    
    func testPairConstructionAndUniqueCardIdentities() {
        let engine = MemoryGameEngine(mode: .classic, difficulty: .sixPairs)
        
        XCTAssertEqual(engine.cards.count, 12, "6 pairs must generate exactly 12 cards")
        
        // Every card must have a unique UUID
        let uniqueIds = Set(engine.cards.map { $0.id })
        XCTAssertEqual(uniqueIds.count, 12, "Every card must have its own unique card ID")
        
        // Exactly 6 distinct pair IDs, each appearing exactly twice
        var pairCounts: [Int: Int] = [:]
        for card in engine.cards {
            pairCounts[card.pairId, default: 0] += 1
        }
        XCTAssertEqual(pairCounts.count, 6, "Must have exactly 6 distinct pair IDs")
        for count in pairCounts.values {
            XCTAssertEqual(count, 2, "Every pair ID must belong to exactly 2 cards")
        }
    }
    
    func testClassicModeCardsAreBothPictures() {
        let engine = MemoryGameEngine(mode: .classic, difficulty: .sixPairs)
        for card in engine.cards {
            XCTAssertEqual(card.displayType, .picture, "All cards in Classic mode must be picture cards")
        }
    }
    
    func testLearnModeCardsContainOnePictureAndOneWordPerPair() {
        let engine = MemoryGameEngine(mode: .learn, difficulty: .sixPairs)
        
        var pairsMap: [Int: [CardDisplayType]] = [:]
        for card in engine.cards {
            pairsMap[card.pairId, default: []].append(card.displayType)
        }
        
        for (pairId, types) in pairsMap {
            XCTAssertEqual(types.count, 2, "Pair \(pairId) must contain 2 cards")
            XCTAssertTrue(types.contains(.picture), "Pair \(pairId) must contain one picture card")
            XCTAssertTrue(types.contains(.word), "Pair \(pairId) must contain one word card")
        }
    }
    
    func testDifficultyEightPairsGeneratesSixteenCards() {
        let engine = MemoryGameEngine(mode: .classic, difficulty: .eightPairs)
        XCTAssertEqual(engine.cards.count, 16)
        XCTAssertEqual(engine.totalPairs, 8)
    }
    
    func testCardSelectionAndTurnRetentionOnMatch() {
        let scheduler = ImmediateDelayScheduler(executeImmediately: true)
        // Deterministic no-shuffle for predictable pair matching
        let engine = MemoryGameEngine(
            mode: .classic,
            difficulty: .sixPairs,
            scheduler: scheduler,
            shuffle: { $0 } // identity: pairs are adjacent: card 0 & 1 match
        )
        
        XCTAssertEqual(engine.currentPlayer, .playerOne)
        XCTAssertEqual(engine.playerOneScore, 0)
        
        let card1 = engine.cards[0]
        let card2 = engine.cards[1]
        XCTAssertEqual(card1.pairId, card2.pairId)
        
        // Flip card 1
        let selectedFirst = engine.selectCard(at: card1.id)
        XCTAssertTrue(selectedFirst)
        XCTAssertTrue(engine.cards[0].isRevealed)
        XCTAssertNil(engine.secondRevealedCardId)
        
        // Flip card 2 (matching pair)
        let selectedSecond = engine.selectCard(at: card2.id)
        XCTAssertTrue(selectedSecond)
        
        // Match verified: score incremented, both cards matched, turn retained!
        XCTAssertEqual(engine.playerOneScore, 1)
        XCTAssertEqual(engine.playerTwoScore, 0)
        XCTAssertTrue(engine.cards[0].isMatched)
        XCTAssertTrue(engine.cards[1].isMatched)
        XCTAssertEqual(engine.currentPlayer, .playerOne, "Player 1 must keep turn after matching a pair")
    }
    
    func testCardSelectionAndTurnSwitchOnMismatch() {
        let scheduler = ImmediateDelayScheduler(executeImmediately: true)
        let engine = MemoryGameEngine(
            mode: .classic,
            difficulty: .sixPairs,
            scheduler: scheduler,
            shuffle: { $0 } // Card 0 (pair 1) and Card 2 (pair 2) mismatch
        )
        
        let card1 = engine.cards[0]
        let card3 = engine.cards[2]
        XCTAssertNotEqual(card1.pairId, card3.pairId)
        
        _ = engine.selectCard(at: card1.id)
        _ = engine.selectCard(at: card3.id)
        
        // With immediate scheduler, mismatch resolved: cards face down, turn passed to Player 2
        XCTAssertFalse(engine.cards[0].isRevealed)
        XCTAssertFalse(engine.cards[2].isRevealed)
        XCTAssertFalse(engine.cards[0].isMatched)
        XCTAssertFalse(engine.cards[2].isMatched)
        XCTAssertEqual(engine.playerOneScore, 0)
        XCTAssertEqual(engine.currentPlayer, .playerTwo, "Mismatch must switch turn to Player 2")
    }
    
    func testIllegalCardSelectionsAreIgnored() {
        let scheduler = ImmediateDelayScheduler(executeImmediately: false)
        let engine = MemoryGameEngine(
            mode: .classic,
            difficulty: .sixPairs,
            scheduler: scheduler,
            shuffle: { $0 }
        )
        
        let card1 = engine.cards[0]
        _ = engine.selectCard(at: card1.id)
        
        // Cannot re-select the same first card
        let reselectedSame = engine.selectCard(at: card1.id)
        XCTAssertFalse(reselectedSame, "Selecting the already revealed first card must be rejected")
        
        // Trigger mismatch
        let card3 = engine.cards[2]
        _ = engine.selectCard(at: card3.id)
        XCTAssertTrue(engine.isResolvingMismatch)
        
        // Cannot select another card while mismatch resolution is pending
        let selectionWhileResolving = engine.selectCard(at: engine.cards[4].id)
        XCTAssertFalse(selectionWhileResolving, "Inputs during mismatch resolution lock must be ignored")
    }
    
    func testRoundCompletionAndDrawVsWinnerHandling() {
        let scheduler = ImmediateDelayScheduler(executeImmediately: true)
        let engine = MemoryGameEngine(
            mode: .classic,
            difficulty: .sixPairs,
            scheduler: scheduler,
            shuffle: { $0 }
        )
        
        let p1 = PlayerProfile(name: "Maya")
        let p2 = PlayerProfile(name: "Leo")
        
        // Match all 6 pairs: Pairs 0, 1, 2 for P1; Pairs 3, 4, 5 for P2 (after passing turn)
        // Pair 0
        _ = engine.selectCard(at: engine.cards[0].id)
        _ = engine.selectCard(at: engine.cards[1].id)
        // Pair 1
        _ = engine.selectCard(at: engine.cards[2].id)
        _ = engine.selectCard(at: engine.cards[3].id)
        // Pair 2
        _ = engine.selectCard(at: engine.cards[4].id)
        _ = engine.selectCard(at: engine.cards[5].id)
        
        XCTAssertEqual(engine.playerOneScore, 3)
        
        // Switch turn to P2 via mismatch
        _ = engine.selectCard(at: engine.cards[6].id)
        _ = engine.selectCard(at: engine.cards[8].id) // mismatch
        XCTAssertEqual(engine.currentPlayer, .playerTwo)
        
        // Pair 3
        _ = engine.selectCard(at: engine.cards[6].id)
        _ = engine.selectCard(at: engine.cards[7].id)
        // Pair 4
        _ = engine.selectCard(at: engine.cards[8].id)
        _ = engine.selectCard(at: engine.cards[9].id)
        // Pair 5
        _ = engine.selectCard(at: engine.cards[10].id)
        _ = engine.selectCard(at: engine.cards[11].id)
        
        XCTAssertEqual(engine.playerTwoScore, 3)
        XCTAssertTrue(engine.isCompleted, "Round must be complete when all pairs are matched")
        
        // Generate Result (Draw scenario)
        let drawResult = engine.generateRoundResult(playerOne: p1, playerTwo: p2)
        XCTAssertTrue(drawResult.isDraw)
        XCTAssertNil(drawResult.winnerId)
        XCTAssertEqual(drawResult.winnerTitle, "It's a draw!")
    }
}
