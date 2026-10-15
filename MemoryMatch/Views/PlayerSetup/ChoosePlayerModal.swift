//
//  ChoosePlayerModal.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct ChoosePlayerModal: View {
    public let slot: ChoosingSlot
    public let profiles: [PlayerProfile]
    public let currentOpponentId: UUID
    public let onSelect: (PlayerProfile) -> Void
    public let onAddNew: () -> Void
    public let onDismiss: () -> Void
    
    public init(
        slot: ChoosingSlot,
        profiles: [PlayerProfile],
        currentOpponentId: UUID,
        onSelect: @escaping (PlayerProfile) -> Void,
        onAddNew: @escaping () -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.slot = slot
        self.profiles = profiles
        self.currentOpponentId = currentOpponentId
        self.onSelect = onSelect
        self.onAddNew = onAddNew
        self.onDismiss = onDismiss
    }
    
    private var slotTitle: String {
        slot == .playerOne ? "Choose Player 1" : "Choose Player 2"
    }
    
    public var body: some View {
        TVModalOverlay(
            title: slotTitle,
            subtitle: "Select a saved local player profile",
            onDismiss: onDismiss
        ) {
            VStack(spacing: 20) {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 14) {
                        ForEach(profiles) { profile in
                            let isAlreadyChosenAsOpponent = profile.id == currentOpponentId
                            
                            Button(action: {
                                if !isAlreadyChosenAsOpponent {
                                    onSelect(profile)
                                }
                            }) {
                                HStack(spacing: 20) {
                                    ZStack {
                                        Circle()
                                            .fill(slot == .playerOne ? MemoryMatchTheme.mintTeal : MemoryMatchTheme.amber)
                                            .frame(width: 52, height: 52)
                                        
                                        Text(profile.initials)
                                            .font(.system(size: 22, weight: .bold, design: .rounded))
                                            .foregroundColor(MemoryMatchTheme.textDark)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(profile.name)
                                            .font(.system(size: 24, weight: .bold, design: .rounded))
                                            .foregroundColor(isAlreadyChosenAsOpponent ? MemoryMatchTheme.textSecondary : MemoryMatchTheme.textPrimary)
                                        
                                        if isAlreadyChosenAsOpponent {
                                            Text("Already selected in opposite slot")
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                                .foregroundColor(MemoryMatchTheme.amber)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    if !isAlreadyChosenAsOpponent {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(MemoryMatchTheme.mintTeal)
                                            .opacity(0.8)
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 14)
                                .background(MemoryMatchTheme.raisedSlate)
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(MemoryMatchTheme.slateBorder, lineWidth: 1)
                                )
                            }
                            .buttonStyle(TVSecondaryButtonStyle(minWidth: 400, height: 80))
                            .disabled(isAlreadyChosenAsOpponent)
                        }
                    }
                    .padding(.vertical, 10)
                }
                .frame(maxHeight: 380)
                
                HStack(spacing: 20) {
                    Button(action: onAddNew) {
                        HStack(spacing: 10) {
                            Image(systemName: "plus.circle.fill")
                            Text("Create New Player")
                        }
                    }
                    .buttonStyle(TVPrimaryButtonStyle(minWidth: 260, height: 64))
                    
                    Button("Cancel", action: onDismiss)
                        .buttonStyle(TVSecondaryButtonStyle(minWidth: 160, height: 64))
                }
                .padding(.top, 10)
            }
        }
    }
}
