//
//  ManagePlayersModal.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct ManagePlayersModal: View {
    @ObservedObject public var viewModel: PlayerSetupViewModel
    
    public init(viewModel: PlayerSetupViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        TVModalOverlay(
            title: "Manage Player Profiles",
            subtitle: "Rename or remove local players without affecting completed game history",
            onDismiss: { viewModel.dismissManagePlayers() }
        ) {
            VStack(spacing: 20) {
                if let error = viewModel.manageErrorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(MemoryMatchTheme.destructiveRed)
                        Text(error)
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(MemoryMatchTheme.destructiveRed)
                    }
                }
                
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 14) {
                        ForEach(viewModel.availableProfiles) { profile in
                            HStack(spacing: 18) {
                                // Initials
                                ZStack {
                                    Circle()
                                        .fill(MemoryMatchTheme.mintTeal)
                                        .frame(width: 48, height: 48)
                                    Text(profile.initials)
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(MemoryMatchTheme.textDark)
                                }
                                
                                // Name or Editing Field
                                if viewModel.editingProfile?.id == profile.id {
                                    TextField("Edit name", text: $viewModel.editedName)
                                        .font(.system(size: 22, weight: .bold, design: .rounded))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(MemoryMatchTheme.slatePanel)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                    Button("Save") {
                                        _ = viewModel.saveEditedPlayer()
                                    }
                                    .buttonStyle(TVSmallPillButtonStyle())
                                    
                                    Button("Cancel") {
                                        viewModel.cancelEditing()
                                    }
                                    .buttonStyle(TVSmallPillButtonStyle())
                                } else {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(profile.name)
                                            .font(.system(size: 24, weight: .bold, design: .rounded))
                                            .foregroundColor(MemoryMatchTheme.textPrimary)
                                        
                                        if profile.id == viewModel.playerOne.id {
                                            Text("Selected as Player 1")
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                                .foregroundColor(MemoryMatchTheme.playerOneTeal)
                                        } else if profile.id == viewModel.playerTwo.id {
                                            Text("Selected as Player 2")
                                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                                .foregroundColor(MemoryMatchTheme.playerTwoAmber)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    // Rename Button
                                    Button(action: {
                                        viewModel.startEditing(profile)
                                    }) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "pencil")
                                            Text("Rename")
                                        }
                                    }
                                    .buttonStyle(TVSmallPillButtonStyle())
                                    
                                    // Delete Button
                                    Button(action: {
                                        viewModel.promptDeleteProfile(profile)
                                    }) {
                                        HStack(spacing: 6) {
                                            Image(systemName: "trash")
                                            Text("Delete")
                                        }
                                    }
                                    .buttonStyle(TVDestructiveButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .background(MemoryMatchTheme.raisedSlate)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(MemoryMatchTheme.slateBorder, lineWidth: 1)
                            )
                        }
                    }
                    .padding(.vertical, 6)
                }
                .frame(maxHeight: 380)
                
                // Done Button
                Button("Done") {
                    viewModel.dismissManagePlayers()
                }
                .buttonStyle(TVSecondaryButtonStyle(minWidth: 200, height: 60))
                .padding(.top, 8)
            }
        }
    }
}
