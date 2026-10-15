//
//  TVSegmentedPicker.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct TVModeCardButton: View {
    public let mode: GameMode
    public let isSelected: Bool
    public let onSelect: () -> Void
    
    @Environment(\.isFocused) private var isFocused
    
    public init(mode: GameMode, isSelected: Bool, onSelect: @escaping () -> Void) {
        self.mode = mode
        self.isSelected = isSelected
        self.onSelect = onSelect
    }
    
    public var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 18) {
                // Icon Container
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(isSelected ? MemoryMatchTheme.mintTeal.opacity(0.18) : MemoryMatchTheme.raisedSlate)
                        .frame(width: 54, height: 54)
                    
                    Image(systemName: mode.systemIcon)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(isSelected ? MemoryMatchTheme.mintTeal : MemoryMatchTheme.textSecondary)
                }
                
                // Titles
                VStack(alignment: .leading, spacing: 4) {
                    Text(mode.title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(MemoryMatchTheme.textPrimary)
                    
                    Text(mode.subtitle)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(MemoryMatchTheme.textSecondary)
                }
                
                Spacer()
                
                // Selected Checkmark Badge
                if isSelected {
                    ZStack {
                        Circle()
                            .fill(MemoryMatchTheme.mintTeal)
                            .frame(width: 26, height: 26)
                        Image(systemName: "checkmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(MemoryMatchTheme.textDark)
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 16)
            .frame(width: 280, height: 96)
            .background(isFocused ? MemoryMatchTheme.raisedSlate : MemoryMatchTheme.slatePanel)
            .clipShape(RoundedRectangle(cornerRadius: MemoryMatchTheme.panelCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: MemoryMatchTheme.panelCornerRadius, style: .continuous)
                    .stroke(
                        isFocused
                            ? Color.white
                            : (isSelected ? MemoryMatchTheme.mintTeal : MemoryMatchTheme.slateBorder),
                        lineWidth: isFocused ? 3.5 : (isSelected ? 2.5 : 1.5)
                    )
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .shadow(
                color: isFocused ? MemoryMatchTheme.mintTeal.opacity(0.4) : Color.black.opacity(0.2),
                radius: isFocused ? 16 : 6,
                x: 0,
                y: 4
            )
            .animation(.easeInOut(duration: 0.16), value: isFocused)
        }
        .buttonStyle(.plain)
    }
}

public struct TVDifficultyPillButton: View {
    public let difficulty: Difficulty
    public let isSelected: Bool
    public let onSelect: () -> Void
    
    @Environment(\.isFocused) private var isFocused
    
    public init(difficulty: Difficulty, isSelected: Bool, onSelect: @escaping () -> Void) {
        self.difficulty = difficulty
        self.isSelected = isSelected
        self.onSelect = onSelect
    }
    
    public var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 12) {
                Text(difficulty.title)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textPrimary)
                
                if isSelected {
                    ZStack {
                        Circle()
                            .fill(MemoryMatchTheme.mintTeal)
                            .frame(width: 22, height: 22)
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(MemoryMatchTheme.textDark)
                    }
                }
            }
            .padding(.horizontal, 28)
            .frame(width: 210, height: 64)
            .background(isFocused ? MemoryMatchTheme.raisedSlate : MemoryMatchTheme.slatePanel)
            .clipShape(RoundedRectangle(cornerRadius: MemoryMatchTheme.pillCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: MemoryMatchTheme.pillCornerRadius, style: .continuous)
                    .stroke(
                        isFocused
                            ? Color.white
                            : (isSelected ? MemoryMatchTheme.mintTeal : MemoryMatchTheme.slateBorder),
                        lineWidth: isFocused ? 3.5 : (isSelected ? 2.5 : 1.5)
                    )
            )
            .scaleEffect(isFocused ? 1.06 : 1.0)
            .shadow(
                color: isFocused ? MemoryMatchTheme.mintTeal.opacity(0.4) : Color.black.opacity(0.2),
                radius: isFocused ? 14 : 4
            )
            .animation(.easeInOut(duration: 0.16), value: isFocused)
        }
        .buttonStyle(.plain)
    }
}
