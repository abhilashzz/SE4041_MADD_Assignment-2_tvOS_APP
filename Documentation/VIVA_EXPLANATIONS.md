# Academic Viva Defense & Examination Guide: MemoryMatch (tvOS)

**Student:** Abhilash K A T W (IT22081698)  
**Module:** SE4041 – Mobile Application Design and Development  
**Assignment:** Assignment 02, Part B (tvOS Prototype & Presentation)  

---

## 1. Core Viva Questions & Technical Answers

### Q1: Why did you choose tvOS instead of visionOS for this prototype?
**Answer:**  
tvOS represents an ubiquitous, accessible living room canvas present in over 50 million households. While visionOS is an exceptional personal spatial computing platform, it is intrinsically an individual, solitary headset experience with high hardware costs ($3,499). Apple TV offered the ideal platform to solve a real social problem: turning passive living room media consumption into an active, multi-user co-op game using the hardware families already own.

---

### Q2: How did you implement the "Two Players, One Remote" mechanic without causing confusion?
**Answer:**  
In tvOS, remote focus belongs to the system. To create a seamless shared-remote experience:
1. **Clear Player Color Cues:** Player 1 has a vibrant Mint-Teal identity (`#60D5C6`) and Player 2 has a warm Amber identity (`#F1BC67`).
2. **Dynamic Turn Indicators:** The scoreboard prominently glows with the active player's color and displays `"• Your turn"` with a pulsing indicator.
3. **Card Focus Halos:** When Player 1 is selecting, the card focus halo glows mint-teal; when Player 2 is selecting, the focus halo glows amber.
4. **Turn Retention Rule:** Matching a pair awards a point and allows the current player to keep their turn, reinforcing engagement. Mismatching briefly reveals the cards for 1.0s, flips them back down, and automatically switches the active player.

---

### Q3: How do you prevent race conditions and illegal card taps during mismatch delays?
**Answer:**  
When two non-matching cards are flipped, players need approximately 1.0 second to memorize the card symbols. During this interval, enthusiastic users might frantically tap other cards.
In `MemoryGameEngine.swift`, we enforce three strict guards at the top of `selectCard(at:)`:
```swift
guard !isPaused else { return false }
guard !isCompleted else { return false }
guard !isResolvingMismatch else { return false }
```
When a mismatch occurs, `isResolvingMismatch` is immediately flagged `true`. All subsequent card selections or re-taps on the same card are rejected until the scheduled callback flips the cards down and clears the flag.

---

### Q4: How did you solve the "stale callback" bug when a round is restarted or abandoned?
**Answer:**  
In naive implementations using `DispatchQueue.main.asyncAfter`, if a user restarts or exits a game during the 1-second mismatch delay, the old pending closure will fire a second later and mutate the *new* game board (flipping new cards or prematurely switching players).
In MemoryMatch, we solved this through two distinct safety mechanisms:
1. **Round UUID Tagging:** Every round possesses a unique `roundId: UUID`. The scheduled closure captures `capturedRoundId`. When executed, it checks `guard self.roundId == capturedRoundId else { return }`. If the user restarted the round, the UUID has changed and the stale callback immediately aborts.
2. **Explicit Cancellation:** `MemoryGameEngine.cancelPendingResolutions()` calls `scheduler.cancelAll()`, which cancels all active `DispatchWorkItem` references and cleans up board flags when the user pauses, restarts, or exits.

---

### Q5: How does your Core Data model allow player profile deletion without corrupting historical match results?
**Answer:**  
In relational databases, deleting a player often cascades and deletes all historical matches, or causes foreign key constraint failures.
In MemoryMatch:
1. `GameRoundEntity` stores string snapshot attributes: `playerOneNameSnapshot` and `playerTwoNameSnapshot`.
2. The Core Data relationship between `PlayerProfileEntity` and `GameRoundEntity` has its deletion rule configured to `Nullify`.
3. When a player profile is deleted, Core Data unlinks the relationship pointers without deleting the `GameRoundEntity`.
4. When the Leaderboard or Results screen queries past matches, it reads the name snapshot. The history, scores, and standings remain 100% accurate and intact.

---

### Q6: Why did you implement "accessibility shielding" for face-down cards?
**Answer:**  
In SwiftUI, it is common to set `.accessibilityLabel(card.item.word)`. However, on Apple TV with VoiceOver enabled, or in UI test automation, a user could move focus over face-down cards and the system would speak: *"Apple"* or *"Book"*, completely destroying the memory puzzle challenge.
In `MemoryCard.swift`:
- When face-down: `accessibilityLabel = "Hidden card, row X, column Y"`.
- When face-up or matched: `accessibilityLabel = "Revealed [picture/word] card, row X, column Y, [item name]"`.
- Positional identifiers (`card_r0_c0`) are used for automated testing without exposing item identities.

---

### Q7: How did you differentiate "Selected State" from "Remote Focus State"?
**Answer:**  
On Apple TV, remote focus is dynamic and moves with the user's thumb, whereas a selected setting (e.g. Classic mode vs Learn mode, or 6 pairs vs 8 pairs) must persist even when the user moves focus away to click "Start Game".
We separated these states explicitly in `TVModeCardButton` and `TVDifficultyPillButton`:
- **Selected State:** Rendered with a solid mint-teal border, subtle background fill, and a crisp teal checkmark circle (`checkmark.circle.fill`).
- **Focused State:** Rendered with the native tvOS focus expansion (1.05x scale), elevated drop shadow, and a luminous white/teal stroke.

---

### Q8: How does MemoryMatch comply with tvOS storage and memory constraints?
**Answer:**  
Apple tvOS has strict storage constraints: there is no permanent document directory, and the system can purge cached data under storage pressure.
`PersistenceController.swift` places the SQLite database in the app sandbox's `Application Support` directory, creating the intermediate directory if it does not exist. If the underlying store fails to load or is evicted by the OS, `PersistenceController` catches the error, logs a diagnostic warning, automatically falls back to an in-memory store, and re-seeds default profiles so the app remains fully functional and never crashes on the user's TV.
