# AI-Assisted Development Log: MemoryMatch (tvOS)

**Student:** Abhilash K A T W (IT22081698)  
**Module:** SE4041 – Mobile Application Design and Development  
**Assignment:** Assignment 02, Part B (tvOS)  

---

## 1. Compliance Statement

In compliance with the SLIIT SE4041 Assignment 02 submission guidelines, this log documents the transparent utilization of AI-assisted engineering tools during the research, architecture, implementation, and verification phases of the MemoryMatch tvOS project.

---

## 2. Interaction Records

### Interaction 1: Architectural Design & Single-Remote Turn Mechanics
- **Prompt:**
  *"How can we model a local two-player memory game on Apple tvOS using a single remote control such that turn switching, mismatch delays, and score retention follow strict MVVM and clean architecture principles without race conditions?"*
- **Assistance Provided:**
  - Designed the pure domain `MemoryGameEngine` decoupled from SwiftUI view state.
  - Recommended the `DelaySchedulerProtocol` abstraction to separate production asynchronous `DispatchWorkItem` execution from instantaneous unit test scheduling.
  - Devised the `roundId: UUID` pattern to neutralize stale callback race conditions when a player restarts during a mismatch interval.

### Interaction 2: Core Data Historical Integrity vs. Profile Deletion
- **Prompt:**
  *"In a tvOS Core Data schema, when a player deletes a profile in the setup screen, how can we prevent that action from wiping out past completed game scores and leaderboard rankings?"*
- **Assistance Provided:**
  - Recommended storing string snapshots (`playerOneNameSnapshot`, `playerTwoNameSnapshot`) directly on `GameRoundEntity`.
  - Configured Core Data relationships to `PlayerProfileEntity` with a `Nullify` delete rule so deleting a player sets foreign keys to nil while preserving completed match records and leaderboard aggregates.

### Interaction 3: tvOS Focus Engine & Accessibility Anti-Cheating
- **Prompt:**
  *"How can we style custom SwiftUI cards for Apple TV so that selected mode state is distinct from remote focus scale, and how do we ensure VoiceOver does not reveal face-down cards?"*
- **Assistance Provided:**
  - Established the `TVModeCardButton` and `TVDifficultyPillButton` patterns with distinct persistent checkmark badges versus dynamic focus halos.
  - Implemented the non-revealing accessibility shielding pattern (`"Hidden card, row X, column Y"`) preventing item leaks through accessibility trees.

---

## 3. Reflection on AI Assistance

AI tooling significantly accelerated:
1. **Defensive Concurrency:** Preventing subtle timer bugs on tvOS.
2. **Apple HIG Alignment:** Ensuring proper TV-safe margins, 10-foot legibility, and high-contrast color systems.
3. **Comprehensive Test Suite Design:** Authoring 25+ automated unit and UI tests covering edge cases like draws, stale callbacks, empty inputs, and snapshot preservation.
