//
//  PauseOverlay.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct PauseOverlay: View {
    @ObservedObject public var viewModel: GameBoardViewModel
    
    public init(viewModel: GameBoardViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        TVModalOverlay(
            title: "Game Paused",
            subtitle: "Current progress is held in memory",
            onDismiss: { viewModel.resumeGame() }
        ) {
            VStack(spacing: 24) {
                if viewModel.showRestartConfirmation {
                    restartConfirmationView
                } else if viewModel.showExitConfirmation {
                    exitConfirmationView
                } else {
                    mainPauseMenu
                }
            }
            .padding(.vertical, 16)
        }
    }
    
    // MARK: - Main Pause Menu
    private var mainPauseMenu: some View {
        VStack(spacing: 20) {
            Button(action: {
                viewModel.resumeGame()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "play.fill")
                    Text("Resume Game")
                }
            }
            .buttonStyle(TVPrimaryButtonStyle(minWidth: 320, height: 70))
            
            Button(action: {
                viewModel.promptRestart()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.clockwise")
                    Text("Restart Round")
                }
            }
            .buttonStyle(TVSecondaryButtonStyle(minWidth: 320, height: 70))
            
            Button(action: {
                viewModel.promptExit()
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "xmark.circle")
                    Text("Exit to Home")
                }
            }
            .buttonStyle(TVSecondaryButtonStyle(minWidth: 320, height: 70))
        }
    }
    
    // MARK: - Restart Confirmation
    private var restartConfirmationView: some View {
        VStack(spacing: 24) {
            Text("Restart this round? All current progress and scores will be reset.")
                .font(.system(size: 22, weight: .medium, design: .rounded))
                .foregroundColor(MemoryMatchTheme.textSecondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 24) {
                Button("Yes, Restart") {
                    viewModel.confirmRestart()
                }
                .buttonStyle(TVPrimaryButtonStyle(minWidth: 220, height: 64))
                
                Button("Cancel") {
                    viewModel.cancelRestart()
                }
                .buttonStyle(TVSecondaryButtonStyle(minWidth: 160, height: 64))
            }
        }
    }
    
    // MARK: - Exit Confirmation
    private var exitConfirmationView: some View {
        VStack(spacing: 24) {
            Text("Abandon this round and return to Home? Unfinished progress will not be saved.")
                .font(.system(size: 22, weight: .medium, design: .rounded))
                .foregroundColor(MemoryMatchTheme.textSecondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 24) {
                Button("Yes, Exit") {
                    viewModel.confirmExit()
                }
                .buttonStyle(TVDestructiveButtonStyle())
                
                Button("Cancel") {
                    viewModel.cancelExit()
                }
                .buttonStyle(TVSecondaryButtonStyle(minWidth: 160, height: 64))
            }
        }
    }
}
