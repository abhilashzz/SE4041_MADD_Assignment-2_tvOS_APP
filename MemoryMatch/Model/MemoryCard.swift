//
//  MemoryCard.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import Foundation

public enum CardDisplayType: String, Codable {
    case picture
    case word
}

public struct MemoryCard: Identifiable, Equatable, Hashable {
    public let id: UUID
    public let pairId: Int
    public let item: CatalogItem
    public let displayType: CardDisplayType
    public var isRevealed: Bool
    public var isMatched: Bool
    
    // Grid position for deterministic remote focus navigation
    public var row: Int
    public var column: Int
    
    public init(
        id: UUID = UUID(),
        pairId: Int,
        item: CatalogItem,
        displayType: CardDisplayType = .picture,
        isRevealed: Bool = false,
        isMatched: Bool = false,
        row: Int = 0,
        column: Int = 0
    ) {
        self.id = id
        self.pairId = pairId
        self.item = item
        self.displayType = displayType
        self.isRevealed = isRevealed
        self.isMatched = isMatched
        self.row = row
        self.column = column
    }
    
    // Non-revealing accessibility identifier for UI automation and VoiceOver
    public var accessibilityIdentifier: String {
        "card_r\(row)_c\(column)"
    }
    
    // Accessible label: hides item identity when face down to prevent cheating
    public var accessibilityLabel: String {
        if isMatched {
            return "Matched card, row \(row + 1), column \(column + 1), \(item.word)"
        } else if isRevealed {
            switch displayType {
            case .picture:
                return "Revealed picture card, row \(row + 1), column \(column + 1), \(item.word)"
            case .word:
                return "Revealed word card, row \(row + 1), column \(column + 1), word: \(item.word)"
            }
        } else {
            return "Hidden card, row \(row + 1), column \(column + 1)"
        }
    }
}
