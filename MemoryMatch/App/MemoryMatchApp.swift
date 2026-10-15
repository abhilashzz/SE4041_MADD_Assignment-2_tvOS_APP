//
//  MemoryMatchApp.swift
//  MemoryMatch
//
//  Created for SE4041 - MADD Assignment 2 Part B (tvOS)
//  Student: Abhilash K A T W (IT22081698)
//

import SwiftUI

@main
struct MemoryMatchApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}

public struct ContentView: View {
    @EnvironmentObject private var appState: AppState
    
    public init() {}
    
    public var body: some View {
        ZStack {
            switch appState.currentRoute {
            case .home:
                HomeScreen(viewModel: HomeViewModel(appState: appState))
            case .playerSetup:
                PlayerSetupScreen(viewModel: PlayerSetupViewModel(appState: appState))
            case .gameBoard:
                GameBoardScreen(viewModel: GameBoardViewModel(appState: appState))
            case .results:
                ResultsScreen(viewModel: ResultsViewModel(appState: appState))
            case .leaderboard:
                LocalLeaderboardScreen(viewModel: LeaderboardViewModel(appState: appState))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: appState.currentRoute)
    }
}
