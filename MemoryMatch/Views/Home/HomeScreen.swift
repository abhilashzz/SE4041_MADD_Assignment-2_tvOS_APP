//
//  HomeScreen.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

public struct HomeScreen: View {
    @ObservedObject public var viewModel: HomeViewModel
    
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            // Background
            MemoryMatchTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top Navigation Bar
                topNavigationBar
                
                Spacer()
                
                // Main Content (Split Hero Layout)
                HStack(alignment: .center, spacing: 60) {
                    // Left Column: Headline, Mode & Difficulty, Actions
                    leftHeroColumn
                    
                    Spacer()
                    
                    // Right Column: Floating 3D Illustrated Cards
                    TVCardIllustrationView()
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .tvSafeScreenPadding()
            
            // How To Play Modal Overlay
            if viewModel.showHowToPlay {
                HowToPlayOverlay {
                    viewModel.dismissHowToPlay()
                }
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
    }
    
    // MARK: - Top Navigation Bar
    private var topNavigationBar: some View {
        HStack {
            // Brand Logo
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(MemoryMatchTheme.mintTeal)
                        .frame(width: 38, height: 38)
                        .offset(x: -4, y: -4)
                    
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(MemoryMatchTheme.amber)
                        .frame(width: 38, height: 38)
                        .offset(x: 4, y: 4)
                        .opacity(0.85)
                }
                .frame(width: 48, height: 48)
                
                Text("MemoryMatch")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textPrimary)
            }
            
            Spacer()
            
            // "How to play" Pill Button
            Button(action: {
                viewModel.openHowToPlay()
            }) {
                HStack(spacing: 10) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 20))
                    Text("How to play")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                }
            }
            .buttonStyle(TVSmallPillButtonStyle())
        }
        .padding(.bottom, 20)
    }
    
    // MARK: - Left Hero Column
    private var leftHeroColumn: some View {
        VStack(alignment: .leading, spacing: 28) {
            // Main Hero Text
            VStack(alignment: .leading, spacing: 8) {
                Text("Find a pair. Share the fun.")
                    .font(.system(size: 52, weight: .heavy, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textPrimary)
                
                Text("Two players. One remote.")
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundColor(MemoryMatchTheme.textSecondary)
            }
            
            // Game Mode Selection Cards
            HStack(spacing: 20) {
                TVModeCardButton(
                    mode: .classic,
                    isSelected: viewModel.selectedMode == .classic
                ) {
                    viewModel.selectMode(.classic)
                }
                
                TVModeCardButton(
                    mode: .learn,
                    isSelected: viewModel.selectedMode == .learn
                ) {
                    viewModel.selectMode(.learn)
                }
            }
            
            // Difficulty Selection Pills
            HStack(spacing: 20) {
                TVDifficultyPillButton(
                    difficulty: .sixPairs,
                    isSelected: viewModel.selectedDifficulty == .sixPairs
                ) {
                    viewModel.selectDifficulty(.sixPairs)
                }
                
                TVDifficultyPillButton(
                    difficulty: .eightPairs,
                    isSelected: viewModel.selectedDifficulty == .eightPairs
                ) {
                    viewModel.selectDifficulty(.eightPairs)
                }
            }
            
            // Action Buttons
            HStack(spacing: 24) {
                Button(action: {
                    viewModel.startGame()
                }) {
                    HStack(spacing: 14) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 24))
                        Text("Start Game")
                    }
                }
                .buttonStyle(TVPrimaryButtonStyle(minWidth: 260, height: 72))
                
                Button(action: {
                    viewModel.openLeaderboard()
                }) {
                    HStack(spacing: 14) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 22))
                        Text("Leaderboard")
                    }
                }
                .buttonStyle(TVSecondaryButtonStyle(minWidth: 220, height: 72))
            }
            .padding(.top, 10)
        }
    }
}
