//
//  CardItemCatalog.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct CatalogItem: Identifiable, Hashable, Codable {
    public let id: Int
    public let word: String
    public let systemImage: String
    public let hexColor: String
    
    public init(id: Int, word: String, systemImage: String, hexColor: String) {
        self.id = id
        self.word = word
        self.systemImage = systemImage
        self.hexColor = hexColor
    }
    
    public var accentColor: Color {
        Color(hex: hexColor)
    }
}

public enum CardItemCatalog {
    public static let standardItems: [CatalogItem] = [
        CatalogItem(id: 1, word: "Apple", systemImage: "apple.logo", hexColor: "#EF4444"),
        CatalogItem(id: 2, word: "Book", systemImage: "book.fill", hexColor: "#3B82F6"),
        CatalogItem(id: 3, word: "Car", systemImage: "car.fill", hexColor: "#F59E0B"),
        CatalogItem(id: 4, word: "House", systemImage: "house.fill", hexColor: "#10B981"),
        CatalogItem(id: 5, word: "Fish", systemImage: "fish.fill", hexColor: "#06B6D4"),
        CatalogItem(id: 6, word: "Sun", systemImage: "sun.max.fill", hexColor: "#FBBF24"),
        CatalogItem(id: 7, word: "Leaf", systemImage: "leaf.fill", hexColor: "#22C55E"),
        CatalogItem(id: 8, word: "Bicycle", systemImage: "bicycle", hexColor: "#8B5CF6"),
        // Additional reserve items for expansion
        CatalogItem(id: 9, word: "Star", systemImage: "star.fill", hexColor: "#EAB308"),
        CatalogItem(id: 10, word: "Airplane", systemImage: "airplane", hexColor: "#38BDF8")
    ]
    
    public static func items(for count: Int) -> [CatalogItem] {
        Array(standardItems.prefix(max(1, min(count, standardItems.count))))
    }
}

// MARK: - Color Hex Extension
public extension Color {
    init(hex: String) {
        let hexClean = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexClean).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hexClean.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 128, 128, 128)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
