//
//  MemoryCardView.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct MemoryCardView: View {
    public let card: MemoryCard
    public let isCurrentPlayerTeal: Bool
    public let onSelect: () -> Void
    
    @Environment(\.isFocused) private var isFocused
    
    public init(
        card: MemoryCard,
        isCurrentPlayerTeal: Bool = true,
        onSelect: @escaping () -> Void
    ) {
        self.card = card
        self.isCurrentPlayerTeal = isCurrentPlayerTeal
        self.onSelect = onSelect
    }
    
    private var isFaceUp: Bool {
        card.isRevealed || card.isMatched
    }
    
    public var body: some View {
        Button(action: onSelect) {
            ZStack {
                // Card Back (Face Down)
                cardBackView
                    .opacity(isFaceUp ? 0 : 1)
                    .rotation3DEffect(
                        .degrees(isFaceUp ? 180 : 0),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                
                // Card Front (Face Up)
                cardFrontView
                    .opacity(isFaceUp ? 1 : 0)
                    .rotation3DEffect(
                        .degrees(isFaceUp ? 0 : -180),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1.15, contentMode: .fit)
            .scaleEffect(isFocused ? 1.08 : 1.0)
            .shadow(
                color: isFocused
                    ? (isCurrentPlayerTeal ? MemoryMatchTheme.mintTeal.opacity(0.65) : MemoryMatchTheme.amber.opacity(0.65))
                    : Color.black.opacity(0.35),
                radius: isFocused ? 20 : 8,
                x: 0,
                y: isFocused ? 8 : 4
            )
            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isFaceUp)
            .animation(.easeInOut(duration: 0.16), value: isFocused)
        }
        .buttonStyle(.plain)
        .disabled(card.isMatched)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(card.accessibilityLabel)
        .accessibilityIdentifier(card.accessibilityIdentifier)
    }
    
    // MARK: - Card Back View
    private var cardBackView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: MemoryMatchTheme.cardCornerRadius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 27/255, green: 45/255, blue: 67/255),
                            Color(red: 20/255, green: 34/255, blue: 52/255)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Subdued dual overlapping card icon
            Image(systemName: "square.on.square")
                .font(.system(size: 38, weight: .light))
                .foregroundColor(MemoryMatchTheme.textSecondary.opacity(0.55))
            
            // Focus & Outline border
            RoundedRectangle(cornerRadius: MemoryMatchTheme.cardCornerRadius, style: .continuous)
                .stroke(
                    isFocused
                        ? (isCurrentPlayerTeal ? MemoryMatchTheme.mintTeal : MemoryMatchTheme.amber)
                        : MemoryMatchTheme.slateBorder,
                    lineWidth: isFocused ? 3.5 : 1.5
                )
        }
    }
    
    // MARK: - Card Front View
    private var cardFrontView: some View {
        ZStack {
            // White / bright surface
            RoundedRectangle(cornerRadius: MemoryMatchTheme.cardCornerRadius, style: .continuous)
                .fill(Color.white)
            
            // Card Content (Picture or Word)
            VStack(spacing: 8) {
                switch card.displayType {
                case .picture:
                    Image(systemName: card.item.systemImage)
                        .font(.system(size: 52, weight: .semibold))
                        .foregroundColor(card.item.accentColor)
                case .word:
                    Text(card.item.word)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(MemoryMatchTheme.textDark)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
            }
            
            // Matched badge (Green checkmark badge in corner)
            if card.isMatched {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(MemoryMatchTheme.successGreen)
                                .frame(width: 28, height: 28)
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(10)
                    }
                }
            }
            
            // Border
            RoundedRectangle(cornerRadius: MemoryMatchTheme.cardCornerRadius, style: .continuous)
                .stroke(
                    card.isMatched
                        ? MemoryMatchTheme.successGreen.opacity(0.8)
                        : (isFocused ? MemoryMatchTheme.mintTeal : Color.gray.opacity(0.2)),
                    lineWidth: card.isMatched ? 3 : (isFocused ? 3.5 : 1)
                )
        }
    }
}
