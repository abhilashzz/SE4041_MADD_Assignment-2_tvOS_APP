//
//  GameMode.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import Foundation

public enum GameMode: String, CaseIterable, Identifiable, Codable {
    case classic
    case learn
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .classic:
            return "Classic"
        case .learn:
            return "Learn"
        }
    }
    
    public var subtitle: String {
        switch self {
        case .classic:
            return "Picture + Picture"
        case .learn:
            return "Picture + Word"
        }
    }
    
    public var systemIcon: String {
        switch self {
        case .classic:
            return "photo.on.rectangle.angled"
        case .learn:
            return "book.closed.fill"
        }
    }
    
    public var description: String {
        switch self {
        case .classic:
            return "Find two identical pictures hidden beneath the cards."
        case .learn:
            return "Match the picture card with its corresponding English word card."
        }
    }
}
