//
//  MemoryMatchTheme.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public enum MemoryMatchTheme {
    // MARK: - Color Palette
    public static let deepNavyBackground = Color(red: 16/255, green: 27/255, blue: 45/255)
    public static let slatePanel = Color(red: 27/255, green: 45/255, blue: 67/255)
    public static let raisedSlate = Color(red: 35/255, green: 56/255, blue: 82/255)
    public static let slateBorder = Color(red: 42/255, green: 66/255, blue: 99/255)
    public static let slateBorderFocused = Color(red: 96/255, green: 213/255, blue: 198/255)
    
    // Player Accents
    public static let playerOneTeal = Color(red: 96/255, green: 213/255, blue: 198/255) // Mint-teal #60D5C6
    public static let playerTwoAmber = Color(red: 241/255, green: 188/255, blue: 103/255) // Amber #F1BC67
    
    // UI Accents
    public static let mintTeal = Color(red: 96/255, green: 213/255, blue: 198/255)
    public static let amber = Color(red: 241/255, green: 188/255, blue: 103/255)
    public static let goldTrophy = Color(red: 246/255, green: 196/255, blue: 69/255)
    
    // Typography Colors
    public static let textPrimary = Color(red: 244/255, green: 246/255, blue: 248/255) // Off-white #F4F6F8
    public static let textSecondary = Color(red: 142/255, green: 172/255, blue: 199/255) // Light slate #8EACC7
    public static let textDark = Color(red: 16/255, green: 27/255, blue: 45/255)
    
    // Functional Colors
    public static let successGreen = Color(red: 74/255, green: 222/255, blue: 128/255)
    public static let destructiveRed = Color(red: 239/255, green: 68/255, blue: 68/255)
    public static let modalBackdrop = Color.black.opacity(0.80)
    
    // MARK: - Gradients
    public static let mintTealGradient = LinearGradient(
        colors: [
            Color(red: 110/255, green: 228/255, blue: 215/255),
            Color(red: 75/255, green: 198/255, blue: 183/255)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let amberGradient = LinearGradient(
        colors: [
            Color(red: 248/255, green: 204/255, blue: 128/255),
            Color(red: 234/255, green: 172/255, blue: 78/255)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    public static let slateGradient = LinearGradient(
        colors: [
            Color(red: 32/255, green: 52/255, blue: 76/255),
            Color(red: 23/255, green: 39/255, blue: 59/255)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    public static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 16/255, green: 27/255, blue: 45/255),
            Color(red: 10/255, green: 18/255, blue: 31/255)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    // MARK: - Spacing & Corner Radii
    public static let cardCornerRadius: CGFloat = 18
    public static let panelCornerRadius: CGFloat = 24
    public static let pillCornerRadius: CGFloat = 30
    public static let smallCornerRadius: CGFloat = 12
    
    // TV Safe Margin (tvOS standard)
    public static let tvHorizontalMargin: CGFloat = 80
    public static let tvVerticalMargin: CGFloat = 50
}

// MARK: - View Modifiers
public struct TVGlassPanelModifier: ViewModifier {
    var cornerRadius: CGFloat = MemoryMatchTheme.panelCornerRadius
    var strokeColor: Color = MemoryMatchTheme.slateBorder
    var lineWidth: CGFloat = 1.5
    
    public func body(content: Content) -> some View {
        content
            .background(MemoryMatchTheme.slatePanel)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(strokeColor, lineWidth: lineWidth)
            )
            .shadow(color: Color.black.opacity(0.35), radius: 12, x: 0, y: 6)
    }
}

public extension View {
    func tvGlassPanel(cornerRadius: CGFloat = MemoryMatchTheme.panelCornerRadius,
                      strokeColor: Color = MemoryMatchTheme.slateBorder,
                      lineWidth: CGFloat = 1.5) -> some View {
        self.modifier(TVGlassPanelModifier(cornerRadius: cornerRadius, strokeColor: strokeColor, lineWidth: lineWidth))
    }
    
    func tvSafeScreenPadding() -> some View {
        self.padding(.horizontal, MemoryMatchTheme.tvHorizontalMargin)
            .padding(.vertical, MemoryMatchTheme.tvVerticalMargin)
    }
}
