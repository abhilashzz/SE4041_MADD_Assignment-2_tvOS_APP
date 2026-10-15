# Technical Guide: MemoryMatch (tvOS)

**Student:** Abhilash K A T W (IT22081698)  
**Module:** SE4041 – Mobile Application Design and Development  
**Assignment:** Assignment 02, Part B (tvOS)  

---

## 1. Technology Stack & Deployment Target

- **Operating System:** Apple tvOS 17.0+
- **Language:** Swift 5.0
- **UI Framework:** SwiftUI
- **Persistence:** Core Data (`NSPersistentContainer`)
- **Reactive State:** Combine (`@Published`, `ObservableObject`, `CurrentValueSubject`)
- **Testing:** XCTest (Unit and UI Automation)
- **Design Metaphor:** 10-foot TV experience, Apple tvOS HIG focus engine

---

## 2. Code Organization & Namespace Architecture

```
MemoryMatch/
├── App/
│   ├── MemoryMatchApp.swift      # Application entry point (@main)
│   └── AppState.swift            # Top-level route & session coordinator
├── Theme/
│   └── MemoryMatchTheme.swift    # Design tokens, TV color palette, view modifiers
├── Model/
│   ├── GameMode.swift            # Classic / Learn enum definitions
│   ├── Difficulty.swift          # 6 pairs / 8 pairs grid dimensions
│   ├── CardItemCatalog.swift     # 8+ everyday items & color mappings
│   ├── MemoryCard.swift          # Card struct with non-revealing accessibility
│   ├── PlayerProfile.swift       # Player model with validation & initials generator
│   └── GameRoundResult.swift     # Result struct with snapshot records & aggregates
├── Engine/
│   ├── MemoryGameEngine.swift    # Pure domain game logic & turn management
│   └── DelayScheduler.swift      # Injectable timer protocol (Async & Immediate)
├── Persistence/
│   ├── MemoryMatch.xcdatamodeld  # Core Data model definition
│   ├── PersistenceController.swift # Container, in-memory mode, resilient tvOS path
│   ├── PlayerProfileRepository.swift # Profile CRUD operations
│   └── GameRoundRepository.swift # Round save/dedup/delete & leaderboard calculation
├── Components/
│   ├── TVButtonStyles.swift      # Focus-scaling primary/secondary/destructive styles
│   ├── MemoryCardView.swift      # 3D animated card with matched badge & shielding
│   ├── PlayerScoreCardView.swift # Avatar, score, and active turn glow panel
│   ├── TVSegmentedPicker.swift   # Mode & difficulty selection components
│   ├── TVCardIllustrationView.swift # Floating 3D hero cards
│   ├── ConfettiView.swift        # Celebratory post-match confetti
│   └── TVModalOverlay.swift      # Glassmorphic modal container
├── ViewModels/
│   ├── HomeViewModel.swift       # Home configuration & help routing
│   ├── PlayerSetupViewModel.swift# Profile selection & management logic
│   ├── GameBoardViewModel.swift  # Engine coordinator & pause handling
│   ├── ResultsViewModel.swift    # Winner presentation & save status
│   └── LeaderboardViewModel.swift# Standings aggregation & filter logic
└── Views/                        # Five core screens & overlay sheets
```

---

## 3. Core Technical Patterns

### 3.1 Non-Revealing Accessibility Shielding
In traditional mobile apps, developers frequently bind the `accessibilityLabel` or `accessibilityIdentifier` directly to the card item's name (e.g. `"Apple"`). In a memory matching game, this introduces a critical cheat vulnerability: VoiceOver or test automations can inspect the accessibility hierarchy of face-down cards to locate matching pairs without flipping them.

In MemoryMatch:
```swift
public var accessibilityIdentifier: String {
    "card_r\(row)_c\(column)" // Non-revealing positional identifier
}

public var accessibilityLabel: String {
    if isMatched {
        return "Matched card, row \(row + 1), column \(column + 1), \(item.word)"
    } else if isRevealed {
        switch displayType {
        case .picture: return "Revealed picture card, row \(row + 1), column \(column + 1), \(item.word)"
        case .word: return "Revealed word card, row \(row + 1), column \(column + 1), word: \(item.word)"
        }
    } else {
        return "Hidden card, row \(row + 1), column \(column + 1)" // Identity shielded
    }
}
```

### 3.2 Thread-Confinement & Async Scheduler Pattern
All mismatch timers avoid `Thread.sleep` or blocking delays on `@MainActor`:
```swift
public protocol DelaySchedulerProtocol: AnyObject {
    func schedule(after seconds: TimeInterval, action: @escaping () -> Void)
    func cancelAll()
}

public final class AsyncDelayScheduler: DelaySchedulerProtocol {
    private var pendingTasks: [UUID: DispatchWorkItem] = [:]
    // Uses DispatchWorkItem on main queue with instant cancellation support
}
```

### 3.3 Snapshot-Based Core Data Entity Design
When saving completed matches:
```swift
entity.playerOneNameSnapshot = round.playerOneSnapshot.name
entity.playerTwoNameSnapshot = round.playerTwoSnapshot.name
```
Because the relationship delete rule on `PlayerProfileEntity` is `Nullify`, profile deletions will never cascade-delete completed matches or cause foreign key violations.

### 3.4 Deterministic Leaderboard Ranking
The repository calculates standings dynamically:
```swift
let sorted = playerMap.values.sorted { a, b in
    if a.wins != b.wins { return a.wins > b.wins }
    if a.pairsMatched != b.pairsMatched { return a.pairsMatched > b.pairsMatched }
    if a.gamesPlayed != b.gamesPlayed { return a.gamesPlayed < b.gamesPlayed }
    return a.name.localizedStandardCompare(b.name) == .orderedAscending
}
```
Draws give neither participant a win (`wins += 0`), ensuring fair competitive ranking.
