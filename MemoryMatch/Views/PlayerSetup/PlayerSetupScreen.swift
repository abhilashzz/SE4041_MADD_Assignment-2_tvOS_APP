//
//  PlayerSetupScreen.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct PlayerSetupScreen: View {
    @ObservedObject public var viewModel: PlayerSetupViewModel
    
    public init(viewModel: PlayerSetupViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            // Background
            MemoryMatchTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Header Bar
                topHeaderBar
                
                Spacer()
                
                // Main Setup Center Area
                VStack(spacing: 34) {
                    // Two Player Columns
                    HStack(spacing: 48) {
                        playerCard(
                            slotNumber: 1,
                            profile: viewModel.playerOne,
                            accentColor: MemoryMatchTheme.playerOneTeal
                        ) {
                            viewModel.openChoosePlayer(for: .playerOne)
                        }
                        
                        playerCard(
                            slotNumber: 2,
                            profile: viewModel.playerTwo,
                            accentColor: MemoryMatchTheme.playerTwoAmber
                        ) {
                            viewModel.openChoosePlayer(for: .playerTwo)
                        }
                    }
                    
                    // Auxiliary Management Actions
                    HStack(spacing: 24) {
                        Button(action: {
                            viewModel.openAddPlayer()
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 20))
                                Text("Add player")
                                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                            }
                        }
                        .buttonStyle(TVSecondaryButtonStyle(minWidth: 220, height: 64))
                        
                        Button(action: {
                            viewModel.openManagePlayers()
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "person.2.fill")
                                    .font(.system(size: 20))
                                Text("Manage players")
                                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                            }
                        }
                        .buttonStyle(TVSecondaryButtonStyle(minWidth: 240, height: 64))
                    }
                    
                    // Match a pair to keep your turn note
                    Text("Match a pair to keep your turn.")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(MemoryMatchTheme.textSecondary)
                    
                    // Big Start Round Button
                    Button(action: {
                        viewModel.startRound()
                    }) {
                        HStack(spacing: 14) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 26))
                            Text("Start Round")
                        }
                    }
                    .buttonStyle(TVPrimaryButtonStyle(minWidth: 320, height: 76))
                }
                
                Spacer()
            }
            .tvSafeScreenPadding()
            
            // Choose Player Modal
            if let slot = viewModel.activeChoosingSlot {
                let opponentId = slot == .playerOne ? viewModel.playerTwo.id : viewModel.playerOne.id
                ChoosePlayerModal(
                    slot: slot,
                    profiles: viewModel.availableProfiles,
                    currentOpponentId: opponentId,
                    onSelect: { chosen in
                        viewModel.selectPlayer(chosen, for: slot)
                    },
                    onAddNew: {
                        viewModel.dismissChoosePlayer()
                        viewModel.openAddPlayer()
                    },
                    onDismiss: {
                        viewModel.dismissChoosePlayer()
                    }
                )
                .transition(.opacity)
            }
            
            // Add Player Modal
            if viewModel.showAddPlayerModal {
                AddPlayerModal(
                    playerName: $viewModel.newPlayerName,
                    errorMessage: viewModel.addPlayerErrorMessage,
                    onSave: {
                        _ = viewModel.saveNewPlayer()
                    },
                    onDismiss: {
                        viewModel.dismissAddPlayer()
                    }
                )
                .transition(.opacity)
            }
            
            // Manage Players Modal
            if viewModel.showManagePlayersModal {
                ManagePlayersModal(viewModel: viewModel)
                    .transition(.opacity)
            }
            
            // Delete Confirmation Alert Overlay
            if viewModel.showDeleteConfirmation, let target = viewModel.profileToDelete {
                TVModalOverlay(
                    title: "Delete Profile?",
                    subtitle: "Are you sure you want to delete \(target.name)?",
                    onDismiss: { viewModel.cancelDeleteProfile() }
                ) {
                    VStack(spacing: 24) {
                        Text("Deleting this profile will not erase past game scores. Past rounds retain \(target.name)'s historical name snapshot.")
                            .font(.system(size: 20, weight: .regular, design: .rounded))
                            .foregroundColor(MemoryMatchTheme.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 24) {
                            Button("Yes, Delete Profile") {
                                viewModel.confirmDeleteProfile()
                            }
                            .buttonStyle(TVDestructiveButtonStyle())
                            
                            Button("Cancel") {
                                viewModel.cancelDeleteProfile()
                            }
                            .buttonStyle(TVSecondaryButtonStyle(minWidth: 160, height: 64))
                        }
                    }
                    .padding(.vertical, 10)
                }
                .transition(.opacity)
            }
        }
    }
    
    // MARK: - Top Header Bar
    private var topHeaderBar: some View {
        HStack {
            Button(action: {
                viewModel.backToHome()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                    Text("Back")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                }
            }
            .buttonStyle(TVSmallPillButtonStyle())
            
            Spacer()
            
            Text("Who's playing?")
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundColor(MemoryMatchTheme.textPrimary)
            
            Spacer()
            
            // Empty placeholder for balanced header alignment
            Color.clear
                .frame(width: 100, height: 40)
        }
        .padding(.bottom, 16)
    }
    
    // MARK: - Player Card Component
    private func playerCard(
        slotNumber: Int,
        profile: PlayerProfile,
        accentColor: Color,
        onChoose: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 16) {
            Text("PLAYER \(slotNumber)")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(MemoryMatchTheme.textSecondary)
                .tracking(2)
            
            // Initials Avatar
            ZStack {
                Circle()
                    .fill(accentColor)
                    .frame(width: 100, height: 100)
                
                Text(profile.initials)
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textDark)
            }
            .shadow(color: accentColor.opacity(0.4), radius: 16, x: 0, y: 6)
            
            // Name
            Text(profile.name)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(MemoryMatchTheme.textPrimary)
                .lineLimit(1)
            
            // Choose Player Button
            Button(action: onChoose) {
                HStack(spacing: 8) {
                    Text("Choose player")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .bold))
                }
            }
            .buttonStyle(TVSecondaryButtonStyle(minWidth: 200, height: 58))
        }
        .padding(.horizontal, 36)
        .padding(.vertical, 28)
        .frame(width: 340, height: 330)
        .background(MemoryMatchTheme.slatePanel)
        .clipShape(RoundedRectangle(cornerRadius: MemoryMatchTheme.panelCornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: MemoryMatchTheme.panelCornerRadius, style: .continuous)
                .stroke(MemoryMatchTheme.slateBorder, lineWidth: 1.5)
        )
        .shadow(color: Color.black.opacity(0.3), radius: 14, x: 0, y: 6)
    }
}
