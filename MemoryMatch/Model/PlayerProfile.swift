//
//  PlayerProfile.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import Foundation

public struct PlayerProfile: Identifiable, Equatable, Hashable, Codable {
    public let id: UUID
    public var name: String
    public let createdAt: Date
    public var updatedAt: Date
    
    public init(id: UUID = UUID(), name: String, createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public var initials: String {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "?" }
        let components = trimmed.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        if components.count >= 2 {
            let first = components[0].prefix(1)
            let second = components[1].prefix(1)
            return "\(first)\(second)".uppercased()
        } else {
            return String(trimmed.prefix(1)).uppercased()
        }
    }
    
    public static func validateName(_ rawName: String) -> Result<String, PlayerValidationError> {
        let trimmed = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return .failure(.emptyName)
        }
        if trimmed.count > 24 {
            return .failure(.nameTooLong)
        }
        return .success(trimmed)
    }
    
    // Seed defaults matching the reference design board (Maya and Leo)
    public static let defaultPlayerOne = PlayerProfile(
        id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
        name: "Maya"
    )
    
    public static let defaultPlayerTwo = PlayerProfile(
        id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
        name: "Leo"
    )
}

public enum PlayerValidationError: LocalizedError, Equatable {
    case emptyName
    case nameTooLong
    case duplicateSlot
    
    public var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Player name cannot be empty."
        case .nameTooLong:
            return "Player name must be 24 characters or fewer."
        case .duplicateSlot:
            return "Player 1 and Player 2 cannot be the same profile."
        }
    }
}
