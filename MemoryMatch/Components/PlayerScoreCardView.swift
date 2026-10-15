//
//  PlayerScoreCardView.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct PlayerScoreCardView: View {
    public let player: PlayerProfile
    public let score: Int
    public let isPlayerOne: Bool
    public let isActiveTurn: Bool
    
    public init(
        player: PlayerProfile,
        score: Int,
        isPlayerOne: Bool,
        isActiveTurn: Bool
    ) {
        self.player = player
        self.score = score
        self.isPlayerOne = isPlayerOne
        self.isActiveTurn = isActiveTurn
    }
    
    private var accentColor: Color {
        isPlayerOne ? MemoryMatchTheme.playerOneTeal : MemoryMatchTheme.playerTwoAmber
    }
    
    public var body: some View {
        HStack(spacing: 20) {
            // Player Avatar Circle with Initial
            ZStack {
                Circle()
                    .fill(accentColor)
                    .frame(width: 58, height: 58)
                
                Text(player.initials)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textDark)
            }
            
            // Name and Active Turn Indicator
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textPrimary)
                    .lineLimit(1)
                
                if isActiveTurn {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(accentColor)
                            .frame(width: 8, height: 8)
                        Text("Your turn")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(accentColor)
                    }
                    .transition(.opacity)
                }
            }
            
            Spacer()
            
            // Score Display
            Text("\(score)")
                .font(.system(size: 42, weight: .heavy, design: .rounded))
                .foregroundColor(MemoryMatchTheme.textPrimary)
                .padding(.horizontal, 12)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .frame(minWidth: 320, minHeight: 90)
        .background(
            RoundedRectangle(cornerRadius: MemoryMatchTheme.panelCornerRadius, style: .continuous)
                .fill(isActiveTurn ? MemoryMatchTheme.raisedSlate : MemoryMatchTheme.slatePanel)
        )
        .overlay(
            RoundedRectangle(cornerRadius: MemoryMatchTheme.panelCornerRadius, style: .continuous)
                .stroke(
                    isActiveTurn ? accentColor : MemoryMatchTheme.slateBorder,
                    lineWidth: isActiveTurn ? 2.5 : 1.5
                )
        )
        .shadow(
            color: isActiveTurn ? accentColor.opacity(0.3) : Color.black.opacity(0.2),
            radius: isActiveTurn ? 14 : 6,
            x: 0,
            y: 4
        )
        .animation(.easeInOut(duration: 0.2), value: isActiveTurn)
    }
}
