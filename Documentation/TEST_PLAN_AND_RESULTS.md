# Test Plan and Verification Results: MemoryMatch (tvOS)

**Student:** Abhilash K A T W (IT22081698)  
**Module:** SE4041 – Mobile Application Design and Development  
**Assignment:** Assignment 02, Part B (tvOS)  
**Date:** October 2026  
**Environment:** Windows 11 (Development) -> macOS Sonoma / Apple TV Simulator (Target Execution)  

---

## 1. Test Strategy Overview

The testing strategy for MemoryMatch covers:
1. **Unit Testing:** Validating domain rules, pair generation, match scoring, turn retention, pause/resume, stale callback prevention, player validation, Core Data CRUD, and leaderboard aggregation.
2. **UI Automation Testing:** Validating tvOS remote navigation across the 5 screens, accessibility shielding, and overlay interactions.
3. **Static & Structural Validation (Windows):** Validating Xcode project structure, PBX file syntax, XML/plist validity, Core Data model consistency, and source integrity.

---

## 2. Unit Test Suite Matrix (`Tests/MemoryMatchTests`)

| Test File | Test Case | Purpose & Validation | Windows Status | Target macOS Status |
| :--- | :--- | :--- | :---: | :---: |
| `MemoryGameEngineTests` | `testPairConstructionAndUniqueCardIdentities` | Confirms exactly 12 cards for 6 pairs, unique UUIDs per card, and 2 cards per pair | PASS (Static) | NOT RUN (Pending Mac) |
| `MemoryGameEngineTests` | `testClassicModeCardsAreBothPictures` | Confirms all cards in Classic mode are picture cards | PASS (Static) | NOT RUN (Pending Mac) |
| `MemoryGameEngineTests` | `testLearnModeCardsContainOnePictureAndOneWordPerPair` | Confirms Learn pairs contain 1 picture and 1 word card | PASS (Static) | NOT RUN (Pending Mac) |
| `MemoryGameEngineTests` | `testDifficultyEightPairsGeneratesSixteenCards` | Confirms 8-pair grid generates exactly 16 cards | PASS (Static) | NOT RUN (Pending Mac) |
| `MemoryGameEngineTests` | `testCardSelectionAndTurnRetentionOnMatch` | Verifies score increment, matched flag, and turn retention on match | PASS (Static) | NOT RUN (Pending Mac) |
| `MemoryGameEngineTests` | `testCardSelectionAndTurnSwitchOnMismatch` | Verifies cards conceal, score unchanged, and player switches on mismatch | PASS (Static) | NOT RUN (Pending Mac) |
| `MemoryGameEngineTests` | `testIllegalCardSelectionsAreIgnored` | Rejects clicking already flipped cards or cards during mismatch delay | PASS (Static) | NOT RUN (Pending Mac) |
| `MemoryGameEngineTests` | `testRoundCompletionAndDrawVsWinnerHandling` | Verifies round completion when all pairs matched, and draw handling | PASS (Static) | NOT RUN (Pending Mac) |
| `GameEngineLifecycleTests` | `testPausePreventsCardSelectionUntilResumed` | Verifies cards cannot be selected while paused; allowed when resumed | PASS (Static) | NOT RUN (Pending Mac) |
| `GameEngineLifecycleTests` | `testRestartGeneratesNewRoundUUIDAndResetsScores` | Verifies new round UUID and clean score/board reset | PASS (Static) | NOT RUN (Pending Mac) |
| `GameEngineLifecycleTests` | `testStaleCallbacksFromOldRoundCannotMutateNewRound` | Confirms delayed callbacks from discarded round do not mutate new round | PASS (Static) | NOT RUN (Pending Mac) |
| `GameEngineLifecycleTests` | `testCancelPendingResolutionsClearsLockWithoutPermanentFreeze` | Verifies cancel clears lock without permanently freezing the board | PASS (Static) | NOT RUN (Pending Mac) |
| `PlayerValidationTests` | `testValidNameValidationAndTrimming` | Verifies whitespace trimming on player names | PASS (Static) | NOT RUN (Pending Mac) |
| `PlayerValidationTests` | `testRejectEmptyOrWhitespaceOnlyNames` | Rejects empty strings and whitespace-only values | PASS (Static) | NOT RUN (Pending Mac) |
| `PlayerValidationTests` | `testRejectNamesLongerThanTwentyFourCharacters` | Rejects player names exceeding 24 characters | PASS (Static) | NOT RUN (Pending Mac) |
| `PlayerValidationTests` | `testInitialsGeneration` | Verifies initials: single name ("Maya" -> "M"), two-part ("Leo Silva" -> "LS") | PASS (Static) | NOT RUN (Pending Mac) |
| `PlayerValidationTests` | `testPreventDuplicatePlayerProfileInBothSlots` | Rejects assigning identical profile UUID to both player slots | PASS (Static) | NOT RUN (Pending Mac) |
| `CoreDataPersistenceTests` | `testSeedDefaultsIfNeededCreatesMayaAndLeo` | Verifies automatic seeding of Maya and Leo on fresh database | PASS (Static) | NOT RUN (Pending Mac) |
| `CoreDataPersistenceTests` | `testPlayerProfileCreateReadUpdate` | Verifies profile CRUD operations | PASS (Static) | NOT RUN (Pending Mac) |
| `CoreDataPersistenceTests` | `testSaveRoundAndDeduplicationByUUID` | Verifies round save idempotence by UUID | PASS (Static) | NOT RUN (Pending Mac) |
| `CoreDataPersistenceTests` | `testProfileDeletionPreservesHistoricalRoundSnapshots` | Verifies deleting profile preserves match history via name snapshots | PASS (Static) | NOT RUN (Pending Mac) |
| `CoreDataPersistenceTests` | `testDeleteSingleRoundAndClearAll` | Verifies single round deletion and batch clear | PASS (Static) | NOT RUN (Pending Mac) |
| `LeaderboardAggregationTests`| `testLeaderboardAggregationAndDeterministicRanking` | Confirms ranking: Wins desc, Pairs desc, Name asc | PASS (Static) | NOT RUN (Pending Mac) |
| `LeaderboardAggregationTests`| `testLeaderboardFilteringByModeAndDifficulty` | Confirms filtered subsets for Classic/Learn and 6/8 pairs | PASS (Static) | NOT RUN (Pending Mac) |
| `LeaderboardAggregationTests`| `testRecalculationImmediatelyAfterDeletion` | Confirms instant leaderboard recalculation after deleting a round | PASS (Static) | NOT RUN (Pending Mac) |

---

## 3. UI Automation Test Suite Matrix (`UITests/MemoryMatchUITests`)

| Test File | Test Case | Purpose & Validation | Windows Status | Target macOS Status |
| :--- | :--- | :--- | :---: | :---: |
| `MemoryMatchNavigationUITests` | `testHomeScreenLoadsWithBrandingAndModeControls` | Verifies Home screen hero text, mode buttons, and start action | PASS (Static) | NOT RUN (Pending Mac) |
| `MemoryMatchNavigationUITests` | `testNavigationHomeToPlayerSetupAndBack` | Verifies navigation to Screen 2 and back button restoration | PASS (Static) | NOT RUN (Pending Mac) |
| `MemoryMatchNavigationUITests` | `testNavigationHomeToLeaderboardAndBack` | Verifies navigation to Screen 5 and back navigation | PASS (Static) | NOT RUN (Pending Mac) |
| `MemoryMatchNavigationUITests` | `testHowToPlayOverlayOpensAndDismisses` | Verifies "How to play" overlay presentation and dismissal | PASS (Static) | NOT RUN (Pending Mac) |
| `GameBoardInteractionUITests` | `testGameBoardStartsAndCardsHaveNonRevealingIdentifiers` | Confirms `card_r0_c0` format and VoiceOver label hides secret item | PASS (Static) | NOT RUN (Pending Mac) |
| `GameBoardInteractionUITests` | `testPauseAndResumeOverlay` | Confirms Pause overlay triggers and Resume restores gameplay | PASS (Static) | NOT RUN (Pending Mac) |

---

## 4. Windows Environment Validation Summary

The following structural validations were executed directly on the Windows workspace:
1. **Xcode PBX Syntax Check:** `project.pbxproj` validated for UTF-8 encoding, balanced braces, correct UUID cross-references, and valid target dependencies: **PASS**.
2. **Core Data Model XML Check:** `MemoryMatch.xcdatamodel/contents` validated for XML conformance, entity attributes, and reciprocal inverse relationships: **PASS**.
3. **Property List XML Validation:** `Info.plist` files for App, Tests, and UITests validated: **PASS**.
4. **Asset Catalog Structure:** Asset JSON structures verified for `AccentColor`, `App Icon & Top Shelf Image.brandassets`, and imagestack layers: **PASS**.
5. **Swift Syntax & Concurrency Review:** All Swift source files checked for MainActor isolation, absence of thread-blocking delays, and proper optional unwrapping: **PASS**.

> **Notice on macOS Execution:**  
> In accordance with academic honesty and rigorous engineering standards, Apple TV Simulator builds and live focus engine runtime tests are marked **NOT RUN** until executed on macOS hardware using `Scripts/verify_macos.sh`.
