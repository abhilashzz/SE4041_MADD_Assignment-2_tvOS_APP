//
//  HomeViewModel.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

@MainActor
public final class HomeViewModel: ObservableObject {
    @Published public var showHowToPlay: Bool = false
    
    private unowned let appState: AppState
    
    public init(appState: AppState) {
        self.appState = appState
    }
    
    public var selectedMode: GameMode {
        get { appState.selectedMode }
        set { appState.selectedMode = newValue }
    }
    
    public var selectedDifficulty: Difficulty {
        get { appState.selectedDifficulty }
        set { appState.selectedDifficulty = newValue }
    }
    
    public func selectMode(_ mode: GameMode) {
        selectedMode = mode
    }
    
    public func selectDifficulty(_ difficulty: Difficulty) {
        selectedDifficulty = difficulty
    }
    
    public func startGame() {
        appState.navigateToPlayerSetup()
    }
    
    public func openLeaderboard() {
        appState.navigateToLeaderboard(origin: .home)
    }
    
    public func openHowToPlay() {
        showHowToPlay = true
    }
    
    public func dismissHowToPlay() {
        showHowToPlay = false
    }
}
