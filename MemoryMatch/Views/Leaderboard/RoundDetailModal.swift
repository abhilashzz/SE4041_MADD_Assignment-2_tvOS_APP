//
//  RoundDetailModal.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct RoundDetailModal: View {
    public let round: GameRoundResult
    public let isConfirmingDelete: Bool
    public let onDeletePrompt: () -> Void
    public let onDeleteConfirm: () -> Void
    public let onDeleteCancel: () -> Void
    public let onDismiss: () -> Void
    
    public init(
        round: GameRoundResult,
        isConfirmingDelete: Bool,
        onDeletePrompt: @escaping () -> Void,
        onDeleteConfirm: @escaping () -> Void,
        onDeleteCancel: @escaping () -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.round = round
        self.isConfirmingDelete = isConfirmingDelete
        self.onDeletePrompt = onDeletePrompt
        self.onDeleteConfirm = onDeleteConfirm
        self.onDeleteCancel = onDeleteCancel
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        TVModalOverlay(
            title: "Round Summary",
            subtitle: "\(round.mode.title) • \(round.difficulty.title) • \(round.formattedDate)",
            onDismiss: onDismiss
        ) {
            VStack(spacing: 24) {
                if isConfirmingDelete {
                    // Confirmation View
                    VStack(spacing: 20) {
                        Text("Delete this match record? This will immediately update player stats on the leaderboard.")
                            .font(.system(size: 22, weight: .medium, design: .rounded))
                            .foregroundColor(MemoryMatchTheme.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 24) {
                            Button("Yes, Delete Round") {
                                onDeleteConfirm()
                            }
                            .buttonStyle(TVDestructiveButtonStyle())
                            
                            Button("Cancel") {
                                onDeleteCancel()
                            }
                            .buttonStyle(TVSecondaryButtonStyle(minWidth: 160, height: 64))
                        }
                    }
                    .padding(.vertical, 16)
                } else {
                    // Detailed Information
                    HStack(spacing: 36) {
                        participantBox(
                            name: round.playerOneSnapshot.name,
                            score: round.playerOneScore,
                            isWinner: round.winnerId == round.playerOneSnapshot.id,
                            accentColor: MemoryMatchTheme.playerOneTeal
                        )
                        
                        Text("VS")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundColor(MemoryMatchTheme.textSecondary)
                        
                        participantBox(
                            name: round.playerTwoSnapshot.name,
                            score: round.playerTwoScore,
                            isWinner: round.winnerId == round.playerTwoSnapshot.id,
                            accentColor: MemoryMatchTheme.playerTwoAmber
                        )
                    }
                    .padding(.vertical, 10)
                    
                    // Result Headline
                    Text(round.winnerTitle)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(round.isDraw ? MemoryMatchTheme.textSecondary : MemoryMatchTheme.mintTeal)
                    
                    // Action Buttons
                    HStack(spacing: 20) {
                        Button(action: onDeletePrompt) {
                            HStack(spacing: 8) {
                                Image(systemName: "trash")
                                Text("Delete Record")
                            }
                        }
                        .buttonStyle(TVDestructiveButtonStyle())
                        
                        Button("Done", action: onDismiss)
                            .buttonStyle(TVSecondaryButtonStyle(minWidth: 160, height: 60))
                    }
                    .padding(.top, 10)
                }
            }
        }
    }
    
    private func participantBox(name: String, score: Int, isWinner: Bool, accentColor: Color) -> some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(accentColor)
                    .frame(width: 64, height: 64)
                
                Text(String(name.prefix(1)).uppercased())
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textDark)
            }
            
            Text(name)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(MemoryMatchTheme.textPrimary)
            
            Text("\(score) pairs")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(MemoryMatchTheme.textSecondary)
            
            if isWinner {
                HStack(spacing: 4) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 14))
                        .foregroundColor(MemoryMatchTheme.goldTrophy)
                    Text("Winner")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(MemoryMatchTheme.goldTrophy)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(MemoryMatchTheme.goldTrophy.opacity(0.15))
                .clipShape(Capsule())
            }
        }
        .frame(minWidth: 160)
        .padding(16)
        .background(MemoryMatchTheme.raisedSlate)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
