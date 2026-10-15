//
//  MemoryGameEngine.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import Foundation

public enum ActivePlayer: String, CaseIterable, Codable {
    case playerOne
    case playerTwo
    
    public var opponent: ActivePlayer {
        self == .playerOne ? .playerTwo : .playerOne
    }
}

public final class MemoryGameEngine: ObservableObject {
    // MARK: - Published State
    @Published public private(set) var roundId: UUID
    @Published public private(set) var mode: GameMode
    @Published public private(set) var difficulty: Difficulty
    @Published public private(set) var cards: [MemoryCard] = []
    @Published public private(set) var currentPlayer: ActivePlayer = .playerOne
    @Published public private(set) var playerOneScore: Int = 0
    @Published public private(set) var playerTwoScore: Int = 0
    @Published public private(set) var isResolvingMismatch: Bool = false
    @Published public private(set) var isPaused: Bool = false
    @Published public private(set) var isCompleted: Bool = false
    
    // Track revealed cards
    @Published public private(set) var firstRevealedCardId: UUID?
    @Published public private(set) var secondRevealedCardId: UUID?
    
    // Dependencies
    private let scheduler: DelaySchedulerProtocol
    private let customCardItems: [CatalogItem]?
    private let customShuffle: (([MemoryCard]) -> [MemoryCard])?
    public var mismatchResolutionDelay: TimeInterval = 1.0
    
    // MARK: - Computed Properties
    public var matchedPairsCount: Int {
        playerOneScore + playerTwoScore
    }
    
    public var totalPairs: Int {
        difficulty.pairCount
    }
    
    public var progressText: String {
        "\(matchedPairsCount) of \(totalPairs) pairs found"
    }
    
    // MARK: - Initialization
    public init(
        mode: GameMode = .classic,
        difficulty: Difficulty = .sixPairs,
        scheduler: DelaySchedulerProtocol = AsyncDelayScheduler(),
        cardItems: [CatalogItem]? = nil,
        shuffle: (([MemoryCard]) -> [MemoryCard])? = nil
    ) {
        self.roundId = UUID()
        self.mode = mode
        self.difficulty = difficulty
        self.scheduler = scheduler
        self.customCardItems = cardItems
        self.customShuffle = shuffle
        
        setupBoard()
    }
    
    // MARK: - Board Setup
    public func startNewRound(mode: GameMode? = nil, difficulty: Difficulty? = nil) {
        cancelPendingResolutions()
        if let mode = mode { self.mode = mode }
        if let difficulty = difficulty { self.difficulty = difficulty }
        
        self.roundId = UUID()
        self.playerOneScore = 0
        self.playerTwoScore = 0
        self.currentPlayer = .playerOne
        self.firstRevealedCardId = nil
        self.secondRevealedCardId = nil
        self.isResolvingMismatch = false
        self.isPaused = false
        self.isCompleted = false
        
        setupBoard()
    }
    
    public func restartRound() {
        startNewRound(mode: self.mode, difficulty: self.difficulty)
    }
    
    private func setupBoard() {
        let pairCount = difficulty.pairCount
        let catalog = customCardItems ?? CardItemCatalog.items(for: pairCount)
        let selectedItems = Array(catalog.prefix(pairCount))
        
        var generatedCards: [MemoryCard] = []
        generatedCards.reserveCapacity(pairCount * 2)
        
        for item in selectedItems {
            let card1Id = UUID()
            let card2Id = UUID()
            
            switch mode {
            case .classic:
                // Both cards are pictures
                generatedCards.append(MemoryCard(id: card1Id, pairId: item.id, item: item, displayType: .picture))
                generatedCards.append(MemoryCard(id: card2Id, pairId: item.id, item: item, displayType: .picture))
            case .learn:
                // One picture card, one word card
                generatedCards.append(MemoryCard(id: card1Id, pairId: item.id, item: item, displayType: .picture))
                generatedCards.append(MemoryCard(id: card2Id, pairId: item.id, item: item, displayType: .word))
            }
        }
        
        // Shuffle cards
        let shuffled: [MemoryCard]
        if let customShuffle = customShuffle {
            shuffled = customShuffle(generatedCards)
        } else {
            shuffled = generatedCards.shuffled()
        }
        
        // Assign row and column positions
        let cols = difficulty.columns
        var positioned: [MemoryCard] = []
        for (index, card) in shuffled.enumerated() {
            var c = card
            c.row = index / cols
            c.column = index % cols
            positioned.append(c)
        }
        
        self.cards = positioned
    }
    
    // MARK: - Gameplay Actions
    @discardableResult
    public func selectCard(at cardId: UUID) -> Bool {
        // Guard conditions
        guard !isPaused else { return false }
        guard !isCompleted else { return false }
        guard !isResolvingMismatch else { return false }
        
        guard let cardIndex = cards.firstIndex(where: { $0.id == cardId }) else { return false }
        let card = cards[cardIndex]
        
        // Cannot select already matched card
        guard !card.isMatched else { return false }
        
        // Cannot re-select the first card already revealed
        if let firstId = firstRevealedCardId, firstId == cardId {
            return false
        }
        
        if firstRevealedCardId == nil {
            // First card flipped
            firstRevealedCardId = cardId
            cards[cardIndex].isRevealed = true
            return true
        } else if secondRevealedCardId == nil {
            // Second card flipped
            secondRevealedCardId = cardId
            cards[cardIndex].isRevealed = true
            evaluateMatch()
            return true
        }
        
        return false
    }
    
    private func evaluateMatch() {
        guard let firstId = firstRevealedCardId,
              let secondId = secondRevealedCardId,
              let firstIndex = cards.firstIndex(where: { $0.id == firstId }),
              let secondIndex = cards.firstIndex(where: { $0.id == secondId }) else {
            return
        }
        
        let firstCard = cards[firstIndex]
        let secondCard = cards[secondIndex]
        
        if firstCard.pairId == secondCard.pairId {
            // Match found!
            cards[firstIndex].isMatched = true
            cards[secondIndex].isMatched = true
            
            // Award point to current player
            if currentPlayer == .playerOne {
                playerOneScore += 1
            } else {
                playerTwoScore += 1
            }
            
            // Reset revealed references (cards remain matched face up)
            firstRevealedCardId = nil
            secondRevealedCardId = nil
            
            // Current player retains turn!
            
            // Check round completion
            if cards.allSatisfy({ $0.isMatched }) {
                isCompleted = true
            }
        } else {
            // Mismatch
            isResolvingMismatch = true
            let capturedRoundId = self.roundId
            
            scheduler.schedule(after: mismatchResolutionDelay) { [weak self] in
                guard let self = self else { return }
                // Ensure callback belongs to the current round
                guard self.roundId == capturedRoundId else { return }
                
                // Turn cards face down
                if let idx1 = self.cards.firstIndex(where: { $0.id == firstId }) {
                    self.cards[idx1].isRevealed = false
                }
                if let idx2 = self.cards.firstIndex(where: { $0.id == secondId }) {
                    self.cards[idx2].isRevealed = false
                }
                
                self.firstRevealedCardId = nil
                self.secondRevealedCardId = nil
                self.isResolvingMismatch = false
                
                // Switch turns
                self.currentPlayer = self.currentPlayer.opponent
            }
        }
    }
    
    // MARK: - Pause / Resume & Cancellation
    public func pauseGame() {
        isPaused = true
    }
    
    public func resumeGame() {
        isPaused = false
    }
    
    public func cancelPendingResolutions() {
        scheduler.cancelAll()
        if isResolvingMismatch {
            // Revert cards if interrupted during mismatch
            if let firstId = firstRevealedCardId, let idx = cards.firstIndex(where: { $0.id == firstId }) {
                cards[idx].isRevealed = false
            }
            if let secondId = secondRevealedCardId, let idx = cards.firstIndex(where: { $0.id == secondId }) {
                cards[idx].isRevealed = false
            }
            firstRevealedCardId = nil
            secondRevealedCardId = nil
            isResolvingMismatch = false
            currentPlayer = currentPlayer.opponent
        }
    }
    
    // MARK: - Result Generation
    public func generateRoundResult(playerOne: PlayerProfile, playerTwo: PlayerProfile) -> GameRoundResult {
        let winnerId: UUID?
        if playerOneScore > playerTwoScore {
            winnerId = playerOne.id
        } else if playerTwoScore > playerOneScore {
            winnerId = playerTwo.id
        } else {
            winnerId = nil // Draw
        }
        
        return GameRoundResult(
            id: roundId,
            date: Date(),
            mode: mode,
            difficulty: difficulty,
            playerOneScore: playerOneScore,
            playerTwoScore: playerTwoScore,
            playerOneSnapshot: PlayerSnapshot(id: playerOne.id, name: playerOne.name),
            playerTwoSnapshot: PlayerSnapshot(id: playerTwo.id, name: playerTwo.name),
            winnerId: winnerId
        )
    }
}
