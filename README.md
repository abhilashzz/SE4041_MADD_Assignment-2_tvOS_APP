# MemoryMatch – Native tvOS Application

**Module:** SE4041 – Mobile Application Design and Development  
**Assignment:** Assignment 02, Part B (Innovative Application for tvOS)  
**Student:** Abhilash K A T W  
**Student ID:** IT22081698  
**Target Platform:** Apple tvOS 17.0+  
**Technology Stack:** Swift 5.0, SwiftUI, Core Data, Combine, XCTest  
**Repository:** [https://github.com/abhilashzz/SE4041_MADD_Assignment-2_tvOS_APP.git](https://github.com/abhilashzz/SE4041_MADD_Assignment-2_tvOS_APP.git)

---

## 1. Project Overview

**MemoryMatch** is a native Apple tvOS multiplayer memory puzzle application designed specifically for the living room entertainment and cognitive learning experience. Featuring an innovative **"Two Players, One Remote"** co-op interaction model, MemoryMatch allows two local participants to compete and learn together using a single Siri Remote / Apple TV Remote.

The application faithfully implements the five-screen visual design specification from the provided UI design board:
- **Deep Navy Background** (`#101B2D`)
- **Raised Slate Panels** (`#1B2D43` with elevated borders `#2A4263`)
- **Mint-Teal Primary Accents & Player 1 Identity** (`#60D5C6`)
- **Restrained Amber Highlights & Player 2 Identity** (`#F1BC67`)
- **Off-White Legible TV Typography** (`#F4F6F8`)

---

## 2. Exactly Five Main Functional Screens

In strict compliance with project requirements, MemoryMatch consists of exactly five functional top-level destinations (no decorative launch screens, mandatory logins, or fake onboarding):

1. **Screen 01 — Home:**  
   Branding hero ("Find a pair. Share the fun. Two players. One remote."), interactive mode selection (**Classic** picture-to-picture vs. **Learn** picture-to-word), difficulty selection (**6 pairs** / 12 cards vs. **8 pairs** / 16 cards), "Start Game", "Leaderboard", and "How to play" help overlay.

2. **Screen 02 — Player Setup:**  
   Local player slot configuration for Player 1 (Mint Teal avatar circle) and Player 2 (Amber avatar circle). Supported by full profile CRUD (Choose profile, Add profile with validation, Rename profile, confirmed Deletion with historical snapshot preservation).

3. **Screen 03 — Game Board:**  
   Interactive 4-column card grid (4x3 for 6 pairs; 4x4 for 8 pairs) with live dual-player scoreboard, active turn indicators ("• Your turn"), animated 3D card flips (`MemoryCardView`), safe asynchronous mismatch delays, and a remote-accessible Pause overlay (Resume, Restart, Exit).

4. **Screen 04 — Results:**  
   Post-match celebration featuring a golden trophy, confetti celebration, winner or draw announcement, both players' pair counts, completed mode/difficulty tags, real Core Data save verification ("✓ Round saved"), and actions for "Play Again", "Leaderboard", and "Home".

5. **Screen 05 — Local Leaderboard:**  
   Comprehensive persistent statistics with mode filters (All, Classic, Learn) and difficulty filters (All, 6 pairs, 8 pairs). Displays deterministically ranked player standings (Rank, Player, Wins, Pairs, Played), recent match history, focusable round details overlay with single-match deletion, and a confirmed "Clear Results" action.

---

## 3. Core Architecture & Game Rules

### Game Rules
- **Turn Mechanic:** Player 1 starts. A matched pair awards **+1 point** and **retains the current player's turn**.
- **Mismatch Delay:** Mismatched cards remain visible for **1.0 second** so players can memorize item locations, before flipping back face-down and passing the turn to the opponent.
- **Safety Locks:** All remote input is strictly ignored during mismatch resolution to prevent state corruption.
- **Completion:** The round completes when all pairs are matched. Draws (equal pairs) are formally handled and awarded to neither player as a win.

### Core Data Persistence
- **Player Profiles:** App-local profiles stored with UUID and editable name.
- **Game Rounds:** Deduplicated by unique round UUID. Contains match date, mode, difficulty, scores, and **player name snapshots**.
- **Snapshot Preservation:** Deleting or renaming a profile *never* alters or corrupts historical completed game records.
- **tvOS Storage Tolerance:** Storage defaults to Application Support directory with automatic in-memory fallback, accommodating tvOS local cache lifecycle policies.

### tvOS Focus & Accessibility
- **Remote Driven:** Full navigation via Apple TV Remote D-pad / directional swipes and Select button.
- **Anti-Cheating VoiceOver Shielding:** Face-down cards report only `"Hidden card, row X, column Y"` to VoiceOver and UI automation, never revealing the secret hidden picture or word.
- **Distinct Focus vs. Selection:** Selected modes and difficulty buttons maintain clear persistent checkmark badges, distinctly separated from the animated scaling glow of the remote focus engine.

---

## 4. Project Directory Layout

```
SE4041_MADD_Assignment-2_tvOS_APP/
├── MemoryMatch/
│   ├── App/
│   │   ├── MemoryMatchApp.swift
│   │   └── AppState.swift
│   ├── Theme/
│   │   └── MemoryMatchTheme.swift
│   ├── Model/
│   │   ├── GameMode.swift
│   │   ├── Difficulty.swift
│   │   ├── CardItemCatalog.swift
│   │   ├── MemoryCard.swift
│   │   ├── PlayerProfile.swift
│   │   └── GameRoundResult.swift
│   ├── Engine/
│   │   ├── MemoryGameEngine.swift
│   │   └── DelayScheduler.swift
│   ├── Persistence/
│   │   ├── MemoryMatch.xcdatamodeld
│   │   ├── PersistenceController.swift
│   │   ├── PlayerProfileRepository.swift
│   │   └── GameRoundRepository.swift
│   ├── Components/
│   │   ├── TVButtonStyles.swift
│   │   ├── MemoryCardView.swift
│   │   ├── PlayerScoreCardView.swift
│   │   ├── TVSegmentedPicker.swift
│   │   ├── TVCardIllustrationView.swift
│   │   ├── ConfettiView.swift
│   │   └── TVModalOverlay.swift
│   ├── ViewModels/
│   │   ├── HomeViewModel.swift
│   │   ├── PlayerSetupViewModel.swift
│   │   ├── GameBoardViewModel.swift
│   │   ├── ResultsViewModel.swift
│   │   └── LeaderboardViewModel.swift
│   ├── Views/
│   │   ├── Home/
│   │   ├── PlayerSetup/
│   │   ├── GameBoard/
│   │   ├── Results/
│   │   └── Leaderboard/
│   └── Resources/
│       ├── Info.plist
│       └── Assets.xcassets/
├── MemoryMatch.xcodeproj/
│   ├── project.pbxproj
│   └── xcshareddata/xcschemes/MemoryMatch.xcscheme
├── Tests/MemoryMatchTests/
├── UITests/MemoryMatchUITests/
├── Scripts/
│   └── verify_macos.sh
└── Documentation/
    ├── ARCHITECTURE.md
    ├── USER_GUIDE.md
    ├── TECHNICAL_GUIDE.md
    ├── TEST_PLAN_AND_RESULTS.md
    ├── MAC_HANDOFF.md
    ├── UI_DESIGN_SPECIFICATION.md
    ├── PITCH_PRESENTATION.md
    ├── VIVA_EXPLANATIONS.md
    └── AI_ASSISTED_DEVELOPMENT_LOG.md
```

---

## 5. Building and Running on macOS

### Prerequisites
- macOS Sonoma (14.0+) or macOS Sequoia (15.0+)
- Xcode 15.0+ or Xcode 16.0+
- Apple TV Simulator (tvOS 17.0+)

### Automated Verification Script
Run the provided automated verification script from Terminal:
```bash
chmod +x Scripts/verify_macos.sh
./Scripts/verify_macos.sh
```

### Xcode GUI Execution
1. Open `MemoryMatch.xcodeproj` in Xcode.
2. Select the `MemoryMatch` scheme and choose an **Apple TV 4K (3rd generation)** simulator destination.
3. Press `Cmd + R` to build and run the application.
4. Press `Cmd + U` to execute all unit tests and UI automation tests.

---

## 6. Implementation Status

- **Windows Implementation:** Complete. Source code, UI components, view models, Core Data model, asset catalogs, Xcode project structure, unit tests, and UI tests fully authored and validated.
- **Mac Verification:** Pending. (Windows environment validation complete; Apple SDK builds, simulator runtime, and tvOS focus tests marked **NOT RUN** until verified on macOS hardware).
