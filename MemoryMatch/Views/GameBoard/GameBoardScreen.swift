//
//  GameBoardScreen.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct GameBoardScreen: View {
    @ObservedObject public var viewModel: GameBoardViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 22),
        GridItem(.flexible(), spacing: 22),
        GridItem(.flexible(), spacing: 22),
        GridItem(.flexible(), spacing: 22)
    ]
    
    public init(viewModel: GameBoardViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            // Background
            MemoryMatchTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Top Header Row (Mode/Difficulty & Pause)
                headerRow
                
                // Scoreboard Row (Both Players with Active Turn Glow)
                scoreboardRow
                
                Spacer(minLength: 10)
                
                // 4-Column Card Grid
                cardGrid
                
                Spacer(minLength: 10)
                
                // Footer Progress Indicator ("X of Y pairs found")
                footerProgress
            }
            .tvSafeScreenPadding()
            
            // Pause Overlay Sheet
            if viewModel.showPauseOverlay {
                PauseOverlay(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
    }
    
    // MARK: - Header Row
    private var headerRow: some View {
        HStack {
            Text(viewModel.headerTitle)
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(MemoryMatchTheme.textPrimary)
            
            Spacer()
            
            Button(action: {
                viewModel.pauseGame()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "pause.fill")
                        .font(.system(size: 18))
                    Text("Pause")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                }
            }
            .buttonStyle(TVSmallPillButtonStyle())
        }
    }
    
    // MARK: - Scoreboard Row
    private var scoreboardRow: some View {
        HStack(spacing: 36) {
            PlayerScoreCardView(
                player: viewModel.playerOne,
                score: viewModel.engine.playerOneScore,
                isPlayerOne: true,
                isActiveTurn: viewModel.engine.currentPlayer == .playerOne
            )
            
            PlayerScoreCardView(
                player: viewModel.playerTwo,
                score: viewModel.engine.playerTwoScore,
                isPlayerOne: false,
                isActiveTurn: viewModel.engine.currentPlayer == .playerTwo
            )
        }
    }
    
    // MARK: - Card Grid
    private var cardGrid: some View {
        LazyVGrid(columns: columns, spacing: 22) {
            ForEach(viewModel.engine.cards) { card in
                MemoryCardView(
                    card: card,
                    isCurrentPlayerTeal: viewModel.engine.currentPlayer == .playerOne
                ) {
                    viewModel.selectCard(card)
                }
            }
        }
        .frame(maxWidth: 1200)
    }
    
    // MARK: - Footer Progress
    private var footerProgress: some View {
        Text(viewModel.engine.progressText)
            .font(.system(size: 22, weight: .semibold, design: .rounded))
            .foregroundColor(MemoryMatchTheme.textSecondary)
            .padding(.bottom, 6)
    }
}
