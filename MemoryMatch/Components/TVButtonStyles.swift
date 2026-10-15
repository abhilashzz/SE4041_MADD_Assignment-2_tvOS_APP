//
//  TVButtonStyles.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct TVPrimaryButtonStyle: ButtonStyle {
    @Environment(\.isFocused) var isFocused
    var minWidth: CGFloat = 260
    var height: CGFloat = 72
    
    public init(minWidth: CGFloat = 260, height: CGFloat = 72) {
        self.minWidth = minWidth
        self.height = height
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 26, weight: .bold, design: .rounded))
            .foregroundColor(MemoryMatchTheme.textDark)
            .padding(.horizontal, 36)
            .frame(minWidth: minWidth, minHeight: height)
            .background(MemoryMatchTheme.mintTealGradient)
            .clipShape(RoundedRectangle(cornerRadius: MemoryMatchTheme.pillCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: MemoryMatchTheme.pillCornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(isFocused ? 0.9 : 0.2), lineWidth: isFocused ? 4 : 1)
            )
            .shadow(color: MemoryMatchTheme.mintTeal.opacity(isFocused ? 0.6 : 0.2), radius: isFocused ? 20 : 6, x: 0, y: isFocused ? 8 : 3)
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.18), value: isFocused)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

public struct TVSecondaryButtonStyle: ButtonStyle {
    @Environment(\.isFocused) var isFocused
    var minWidth: CGFloat = 200
    var height: CGFloat = 72
    
    public init(minWidth: CGFloat = 200, height: CGFloat = 72) {
        self.minWidth = minWidth
        self.height = height
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 24, weight: .semibold, design: .rounded))
            .foregroundColor(MemoryMatchTheme.textPrimary)
            .padding(.horizontal, 32)
            .frame(minWidth: minWidth, minHeight: height)
            .background(isFocused ? MemoryMatchTheme.raisedSlate : MemoryMatchTheme.slatePanel)
            .clipShape(RoundedRectangle(cornerRadius: MemoryMatchTheme.pillCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: MemoryMatchTheme.pillCornerRadius, style: .continuous)
                    .stroke(isFocused ? MemoryMatchTheme.mintTeal : MemoryMatchTheme.slateBorder, lineWidth: isFocused ? 3 : 1.5)
            )
            .shadow(color: Color.black.opacity(isFocused ? 0.5 : 0.2), radius: isFocused ? 16 : 6, x: 0, y: isFocused ? 6 : 2)
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeInOut(duration: 0.18), value: isFocused)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

public struct TVDestructiveButtonStyle: ButtonStyle {
    @Environment(\.isFocused) var isFocused
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 22, weight: .semibold, design: .rounded))
            .foregroundColor(MemoryMatchTheme.destructiveRed)
            .padding(.horizontal, 28)
            .frame(minHeight: 64)
            .background(isFocused ? MemoryMatchTheme.destructiveRed.opacity(0.2) : MemoryMatchTheme.slatePanel)
            .clipShape(RoundedRectangle(cornerRadius: MemoryMatchTheme.pillCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: MemoryMatchTheme.pillCornerRadius, style: .continuous)
                    .stroke(MemoryMatchTheme.destructiveRed.opacity(isFocused ? 0.9 : 0.4), lineWidth: isFocused ? 3 : 1.5)
            )
            .shadow(color: MemoryMatchTheme.destructiveRed.opacity(isFocused ? 0.4 : 0.0), radius: isFocused ? 14 : 0)
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.18), value: isFocused)
    }
}

public struct TVSmallPillButtonStyle: ButtonStyle {
    @Environment(\.isFocused) var isFocused
    
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20, weight: .medium, design: .rounded))
            .foregroundColor(isFocused ? MemoryMatchTheme.textDark : MemoryMatchTheme.textSecondary)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(isFocused ? MemoryMatchTheme.mintTeal : MemoryMatchTheme.raisedSlate.opacity(0.8))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(isFocused ? Color.white : MemoryMatchTheme.slateBorder, lineWidth: isFocused ? 2.5 : 1)
            )
            .scaleEffect(isFocused ? 1.08 : 1.0)
            .animation(.easeInOut(duration: 0.16), value: isFocused)
    }
}
