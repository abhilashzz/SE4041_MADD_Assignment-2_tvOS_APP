# MemoryMatch – Native tvOS Application

MemoryMatch is a native Apple tvOS multiplayer memory puzzle game designed for living room entertainment and cognitive learning. Featuring an intuitive **"Two Players, One Remote"** local co-op mechanic, MemoryMatch allows two players to sit together on the couch and compete or learn using a single Apple TV Remote.

---

## What the App Does

MemoryMatch provides a fast, engaging living room puzzle experience tailored for the 10-foot TV experience:

1. **Two Players, One Remote:**
   - Designed specifically for shared household play without needing multiple game controllers.
   - Distinct color-coded identities: Player 1 (Mint-Teal) and Player 2 (Amber).
   - Clear active turn indicators and focus halos on the big screen.

2. **Two Game Modes:**
   - **Classic Mode:** Traditional memory matching with paired everyday illustrations (Apple, Book, Car, House, Fish, Sun, Leaf, Bicycle).
   - **Learn Mode:** Educational vocabulary matching where one card shows the illustration and its matching card displays the English word.

3. **Difficulty Selection:**
   - **6 Pairs (12 Cards):** Arranged in a 4-column by 3-row grid.
   - **8 Pairs (16 Cards):** Arranged in a 4-column by 4-row grid.

4. **Dynamic Turn Rules:**
   - Matching a pair awards +1 point and allows the current player to keep their turn.
   - Mismatched cards stay revealed for 1 second for memorization, then automatically flip face down and hand the turn to the opponent.
   - Input is locked during mismatch resolution to prevent unintended card flips.

5. **Local Player Profile Management:**
   - Create and manage local player profiles with custom names and auto-generated initials.
   - Validation prevents empty names, excessively long names, or selecting the same profile in both slots.
   - Deleting a profile preserves historical match records through name snapshots.

6. **Persistent Local Leaderboard:**
   - Core Data offline persistence saves every completed match.
   - Filter standings by game mode (All, Classic, Learn) and difficulty (All, 6 pairs, 8 pairs).
   - Deterministic ranking: Wins descending, Pairs matched descending, and Name alphabetical tie-breaking.
   - View match details for recent rounds and delete individual records with instant table recalculation.

7. **TV Focus Engine & Accessibility:**
   - Native Apple TV directional focus navigation via D-pad and Touch surface.
   - Smooth 3D card flip animations and TV-safe layout margins.
   - Non-revealing accessibility labels shield face-down cards from VoiceOver to prevent cheating.

---

## App Screens

The app contains five core functional screens:

- **Home:** Mode selection (Classic / Learn), difficulty selection (6 / 8 pairs), "Start Game", "Leaderboard", and "How to play" rules overlay.
- **Player Setup:** Player 1 and Player 2 selection cards, Add Player, Manage Players (rename and delete), and Start Round.
- **Game Board:** Live scoreboard with turn indicator, 4-column interactive card grid, progress counter, and Pause overlay with Resume, Restart, and Exit options.
- **Results:** Winner celebration with golden trophy and confetti, pair scores, round save status, "Play Again", "Leaderboard", and "Home" navigation.
- **Local Leaderboard:** Filterable player rankings table (Rank, Player, Wins, Pairs, Played), recent match history, round detail overlay, and Clear Results action.

---

## Technology Stack

- **Platform:** Apple tvOS 17.0+
- **Language:** Swift 5.0
- **UI Framework:** SwiftUI
- **Persistence:** Core Data (`NSPersistentContainer`)
- **Reactive State:** Combine (`ObservableObject`, `@Published`)
- **Testing:** XCTest (Unit Tests & UI Automation Tests)

---

## Project Structure

```text
MemoryMatch/
├── App/
│   ├── MemoryMatchApp.swift          # Main app entry point (@main)
│   └── AppState.swift                # App routing & session coordinator
├── Theme/
│   └── MemoryMatchTheme.swift        # TV color palette, tokens & modifiers
├── Model/
│   ├── GameMode.swift                # Classic & Learn mode definitions
│   ├── Difficulty.swift              # 6 pairs & 8 pairs configurations
│   ├── CardItemCatalog.swift         # Everyday item catalog & SF Symbols
│   ├── MemoryCard.swift              # Card struct with accessibility shielding
│   ├── PlayerProfile.swift           # Player model with validation & initials
│   └── GameRoundResult.swift         # Match result & aggregate statistics
├── Engine/
│   ├── MemoryGameEngine.swift        # Pure domain game logic & turn state
│   └── DelayScheduler.swift          # Timer protocol for async and test runs
├── Persistence/
│   ├── MemoryMatch.xcdatamodeld      # Core Data model
│   ├── PersistenceController.swift   # Core Data stack with tvOS path resilience
│   ├── PlayerProfileRepository.swift # Profile CRUD operations
│   └── GameRoundRepository.swift     # Match CRUD and leaderboard calculations
├── Components/
│   ├── MemoryCardView.swift          # Animated 3D card with focus scaling
│   ├── PlayerScoreCardView.swift     # Scoreboard panel with active turn glow
│   ├── TVButtonStyles.swift          # Focus-aware button styles
│   ├── TVSegmentedPicker.swift       # Mode and difficulty selectors
│   ├── TVCardIllustrationView.swift # Floating 3D decorative cards
│   ├── ConfettiView.swift            # Celebratory post-match confetti
│   └── TVModalOverlay.swift          # TV modal container
├── ViewModels/
│   ├── HomeViewModel.swift           # Home screen logic
│   ├── PlayerSetupViewModel.swift    # Profile selection and management
│   ├── GameBoardViewModel.swift      # Board and pause menu coordinator
│   ├── ResultsViewModel.swift        # Post-game presentation & save status
│   └── LeaderboardViewModel.swift    # Standings filter and deletion logic
├── Views/
│   ├── Home/                         # HomeScreen & HowToPlayOverlay
│   ├── PlayerSetup/                  # PlayerSetupScreen & modals
│   ├── GameBoard/                    # GameBoardScreen & PauseOverlay
│   ├── Results/                      # ResultsScreen
│   └── Leaderboard/                  # LocalLeaderboardScreen & RoundDetailModal
└── Resources/
    ├── Info.plist                    # tvOS bundle configuration
    └── Assets.xcassets               # App icon & brand assets
```

---

## How to Build and Run

1. Open `MemoryMatch.xcodeproj` in **Xcode 15+** on macOS.
2. Select the **`MemoryMatch`** scheme.
3. Choose an **Apple TV 4K** simulator destination running **tvOS 17.0+**.
4. Press **`Cmd + R`** to build and run the app.
5. Press **`Cmd + U`** to run unit and UI automation tests.

### Simulator Keyboard Controls

- **Arrow Keys:** Navigate focus across cards and buttons.
- **Return / Enter:** Select or flip highlighted card.
- **Escape / Delete:** Back or dismiss dialogs.
- **Spacebar:** Pause / Resume gameplay.
