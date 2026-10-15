//
//  HowToPlayOverlay.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct HowToPlayOverlay: View {
    public let onDismiss: () -> Void
    
    public init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        TVModalOverlay(
            title: "How to Play MemoryMatch",
            subtitle: "Two players share one Apple TV remote",
            onDismiss: onDismiss
        ) {
            VStack(alignment: .leading, spacing: 20) {
                ruleRow(
                    number: "1",
                    title: "Take Turns with One Remote",
                    description: "Player 1 (Mint Teal) starts the round. Use the Apple TV Remote touch surface / D-pad to navigate cards and press Select to flip."
                )
                
                ruleRow(
                    number: "2",
                    title: "Match a Pair to Keep Your Turn",
                    description: "Flip two cards. If they match, you earn 1 point and get another turn immediately! In Classic mode, match identical pictures. In Learn mode, match pictures with their English words."
                )
                
                ruleRow(
                    number: "3",
                    title: "Mismatch Passes the Turn",
                    description: "If the two cards do not match, they stay revealed for 1 second so both players can memorize their positions, then flip back down and switch to Player 2 (Amber)."
                )
                
                ruleRow(
                    number: "4",
                    title: "Winning & Leaderboards",
                    description: "The game completes when all pairs are found. The player with the most pairs wins! Every completed round is automatically saved to the Local Leaderboard."
                )
                
                HStack {
                    Spacer()
                    Button("Got it, Let's Play!") {
                        onDismiss()
                    }
                    .buttonStyle(TVPrimaryButtonStyle(minWidth: 260, height: 64))
                    Spacer()
                }
                .padding(.top, 10)
            }
        }
    }
    
    private func ruleRow(number: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 18) {
            ZStack {
                Circle()
                    .fill(MemoryMatchTheme.mintTeal)
                    .frame(width: 44, height: 44)
                
                Text(number)
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textDark)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textPrimary)
                
                Text(description)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
