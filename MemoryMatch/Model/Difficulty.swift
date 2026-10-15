//
//  Difficulty.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import Foundation

public enum Difficulty: Int, CaseIterable, Identifiable, Codable {
    case sixPairs = 6
    case eightPairs = 8
    
    public var id: Int { rawValue }
    
    public var pairCount: Int { rawValue }
    
    public var totalCards: Int { rawValue * 2 }
    
    public var columns: Int { 4 }
    
    public var rows: Int {
        switch self {
        case .sixPairs:
            return 3
        case .eightPairs:
            return 4
        }
    }
    
    public var title: String {
        "\(rawValue) pairs"
    }
}
