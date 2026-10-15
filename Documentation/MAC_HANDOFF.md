# Mac Handoff & Execution Guide: MemoryMatch (tvOS)

**Student:** Abhilash K A T W (IT22081698)  
**Module:** SE4041 – Mobile Application Design and Development  
**Assignment:** Assignment 02, Part B (tvOS)  
**Handover Status:** Windows implementation complete; Mac verification pending.  

---

## 1. Overview for Mac Testing & Evaluation

This codebase was developed on Windows with complete native Swift, SwiftUI, and Core Data implementations, verified PBX project files, asset catalogs, and comprehensive test suites. This document provides step-by-step instructions to clone, build, run, and evaluate the application on a Mac running Xcode 15+ and the Apple TV Simulator.

---

## 2. Quick Start: Automated Verification Script

An automated verification shell script is provided in the repository:

1. Open **Terminal** on macOS.
2. Navigate to the project root:
   ```bash
   cd path/to/SE4041_MADD_Assignment-2_tvOS_APP
   ```
3. Grant execution permissions and run the script:
   ```bash
   chmod +x Scripts/verify_macos.sh
   ./Scripts/verify_macos.sh
   ```
4. The script will:
   - Check for `xcodebuild` and `xcrun simctl`.
   - Auto-discover an available Apple TV Simulator (e.g. `Apple TV 4K (3rd generation)`).
   - Build the `MemoryMatch` scheme cleanly (`CODE_SIGNING_ALLOWED=NO`).
   - Run the full suite of Unit Tests (`MemoryMatchTests`).
   - Run the full suite of UI Automation Tests (`MemoryMatchUITests`).
   - Log detailed outputs to `build_logs/`.

---

## 3. Manual Execution via Xcode GUI

If you prefer testing through Xcode's interactive interface:

1. Double-click `MemoryMatch.xcodeproj` to launch Xcode.
2. In the top toolbar, ensure the active scheme is set to **`MemoryMatch`**.
3. In the device destination dropdown, select an available **Apple TV Simulator** (e.g., `Apple TV 4K (3rd generation) - tvOS 17.0+`).
4. **Build and Run (`Cmd + R`):**
   - The Apple TV Simulator will launch.
   - Use your Mac keyboard arrow keys (`Up`, `Down`, `Left`, `Right`) to simulate Apple TV remote swipes.
   - Press `Enter` / `Return` to simulate the remote **Select** button.
   - Press `Esc` or `Delete` to simulate the remote **Menu / Back** button.
   - Press the Spacebar or `Cmd + P` to simulate the remote **Play / Pause** button.
5. **Run All Tests (`Cmd + U`):**
   - Xcode will compile and execute all 25+ unit tests and UI tests.
   - Verify green checkmarks across the Test Navigator (`Cmd + 6`).

---

## 4. Key Verification Checkpoints

When evaluating MemoryMatch on the Apple TV Simulator, please test these key flows:

1. **Screen 1 — Home:**
   - Toggle between **Classic** and **Learn** modes; observe that the selected mode has a clear teal outline and checkmark badge.
   - Toggle difficulty between **6 pairs** and **8 pairs**.
   - Click "How to play" to verify the glassmorphic modal opens and dismisses cleanly.
   - Click "Start Game" to advance to Player Setup.

2. **Screen 2 — Player Setup:**
   - Observe Player 1 (Maya) and Player 2 (Leo) default cards.
   - Click "+ Add player", type a new name (e.g., "Sarah"), and confirm it saves.
   - Click "Manage players", rename a player, and observe immediate updates.
   - Attempt to assign the same player to both slots; verify validation error.
   - Click "Start Round".

3. **Screen 3 — Game Board:**
   - Verify the 4-column layout (4x3 for 6 pairs, 4x4 for 8 pairs).
   - Flip a card; observe the smooth 3D flip animation.
   - Make a matching pair; observe that the active player scores +1 and **keeps their turn**.
   - Make a mismatch; observe the cards remain face-up for 1 second, then flip back down and switch players.
   - Click "Pause"; verify Resume, Restart, and Exit with confirmation dialogs.

4. **Screen 4 — Results:**
   - Complete all pairs on the board; verify automatic transition to Results.
   - Verify winner or draw announcement with trophy and confetti.
   - Observe `"✓ Round saved"` verifying successful Core Data persistence.
   - Click "Leaderboard" to review records.

5. **Screen 5 — Local Leaderboard:**
   - Verify both players appear with accurate Wins, Pairs, and Played counts.
   - Toggle Mode (All, Classic, Learn) and Difficulty filters.
   - Click a recent completed match to open the Round Summary; test deleting that single match and observe immediate recalculation.
   - Click "< Back" to return to the Results screen.

---

## 5. Troubleshooting Common tvOS Simulator Issues

- **Simulator Not Found:** Open Xcode > Settings > Platforms and ensure the **tvOS 17.0+** runtime is installed.
- **Code Signing Error:** In project build settings, code signing is configured to `Automatic` with `CODE_SIGNING_ALLOWED=NO` for simulator testing, so no paid developer account is required.
- **Focus Ring Clipping:** If controls appear clipped during focus zoom, ensure TV-safe margins are enabled (`MemoryMatchTheme.tvSafeScreenPadding()`).
