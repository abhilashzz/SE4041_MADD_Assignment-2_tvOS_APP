//
//  PlayerSetupViewModel.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public enum ChoosingSlot {
    case playerOne
    case playerTwo
}

@MainActor
public final class PlayerSetupViewModel: ObservableObject {
    @Published public var availableProfiles: [PlayerProfile] = []
    @Published public var activeChoosingSlot: ChoosingSlot? = nil
    @Published public var showAddPlayerModal: Bool = false
    @Published public var showManagePlayersModal: Bool = false
    
    // Form Inputs & Validation
    @Published public var newPlayerName: String = ""
    @Published public var addPlayerErrorMessage: String? = nil
    
    // Rename & Delete in Manage modal
    @Published public var editingProfile: PlayerProfile? = nil
    @Published public var editedName: String = ""
    @Published public var profileToDelete: PlayerProfile? = nil
    @Published public var showDeleteConfirmation: Bool = false
    @Published public var manageErrorMessage: String? = nil
    
    private unowned let appState: AppState
    private let playerRepository: PlayerProfileRepositoryProtocol
    
    public init(appState: AppState) {
        self.appState = appState
        self.playerRepository = appState.playerRepository
        refreshProfiles()
    }
    
    public var playerOne: PlayerProfile {
        appState.playerOne
    }
    
    public var playerTwo: PlayerProfile {
        appState.playerTwo
    }
    
    public func refreshProfiles() {
        do {
            self.availableProfiles = try playerRepository.fetchAll()
        } catch {
            self.manageErrorMessage = "Failed to load profiles: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Slot Selection
    public func openChoosePlayer(for slot: ChoosingSlot) {
        refreshProfiles()
        activeChoosingSlot = slot
    }
    
    public func dismissChoosePlayer() {
        activeChoosingSlot = nil
    }
    
    public func selectPlayer(_ profile: PlayerProfile, for slot: ChoosingSlot) {
        switch slot {
        case .playerOne:
            if profile.id == appState.playerTwo.id {
                // Swap or prevent duplicate
                addPlayerErrorMessage = "Player 1 and Player 2 cannot be the same profile."
                return
            }
            appState.playerOne = profile
        case .playerTwo:
            if profile.id == appState.playerOne.id {
                addPlayerErrorMessage = "Player 1 and Player 2 cannot be the same profile."
                return
            }
            appState.playerTwo = profile
        }
        activeChoosingSlot = nil
        addPlayerErrorMessage = nil
    }
    
    // MARK: - Add Player
    public func openAddPlayer() {
        newPlayerName = ""
        addPlayerErrorMessage = nil
        showAddPlayerModal = true
    }
    
    public func dismissAddPlayer() {
        showAddPlayerModal = false
        newPlayerName = ""
        addPlayerErrorMessage = nil
    }
    
    public func saveNewPlayer() -> Bool {
        let validation = PlayerProfile.validateName(newPlayerName)
        switch validation {
        case .failure(let error):
            addPlayerErrorMessage = error.localizedDescription
            return false
        case .success(let trimmed):
            do {
                let created = try playerRepository.create(name: trimmed)
                refreshProfiles()
                
                // If user was choosing a slot, assign directly
                if let slot = activeChoosingSlot {
                    selectPlayer(created, for: slot)
                }
                
                showAddPlayerModal = false
                newPlayerName = ""
                addPlayerErrorMessage = nil
                return true
            } catch {
                addPlayerErrorMessage = "Save failed: \(error.localizedDescription)"
                return false
            }
        }
    }
    
    // MARK: - Manage Players (Rename & Delete)
    public func openManagePlayers() {
        refreshProfiles()
        manageErrorMessage = nil
        showManagePlayersModal = true
    }
    
    public func dismissManagePlayers() {
        showManagePlayersModal = false
        editingProfile = nil
        profileToDelete = nil
        showDeleteConfirmation = false
        manageErrorMessage = nil
    }
    
    public func startEditing(_ profile: PlayerProfile) {
        editingProfile = profile
        editedName = profile.name
        manageErrorMessage = nil
    }
    
    public func cancelEditing() {
        editingProfile = nil
        editedName = ""
    }
    
    public func saveEditedPlayer() -> Bool {
        guard let target = editingProfile else { return false }
        let validation = PlayerProfile.validateName(editedName)
        switch validation {
        case .failure(let error):
            manageErrorMessage = error.localizedDescription
            return false
        case .success(let trimmed):
            do {
                let updated = try playerRepository.update(id: target.id, newName: trimmed)
                refreshProfiles()
                
                // Repair active selections if updated profile is active
                if appState.playerOne.id == target.id {
                    appState.playerOne = updated
                }
                if appState.playerTwo.id == target.id {
                    appState.playerTwo = updated
                }
                
                editingProfile = nil
                editedName = ""
                manageErrorMessage = nil
                return true
            } catch {
                manageErrorMessage = "Update failed: \(error.localizedDescription)"
                return false
            }
        }
    }
    
    public func promptDeleteProfile(_ profile: PlayerProfile) {
        profileToDelete = profile
        showDeleteConfirmation = true
    }
    
    public func confirmDeleteProfile() {
        guard let target = profileToDelete else { return }
        do {
            try playerRepository.delete(id: target.id)
            refreshProfiles()
            
            // Repair active slots if deleted profile was currently selected
            if appState.playerOne.id == target.id {
                if let alternative = availableProfiles.first(where: { $0.id != appState.playerTwo.id && $0.id != target.id }) {
                    appState.playerOne = alternative
                } else {
                    appState.playerOne = PlayerProfile.defaultPlayerOne
                }
            }
            if appState.playerTwo.id == target.id {
                if let alternative = availableProfiles.first(where: { $0.id != appState.playerOne.id && $0.id != target.id }) {
                    appState.playerTwo = alternative
                } else {
                    appState.playerTwo = PlayerProfile.defaultPlayerTwo
                }
            }
            
            profileToDelete = nil
            showDeleteConfirmation = false
            manageErrorMessage = nil
        } catch {
            manageErrorMessage = "Failed to delete: \(error.localizedDescription)"
        }
    }
    
    public func cancelDeleteProfile() {
        profileToDelete = nil
        showDeleteConfirmation = false
    }
    
    // MARK: - Navigation
    public func startRound() {
        appState.navigateToGameBoard()
    }
    
    public func backToHome() {
        appState.navigateToHome()
    }
}
