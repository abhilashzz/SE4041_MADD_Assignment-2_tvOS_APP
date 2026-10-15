# User Guide: MemoryMatch on Apple TV

**Student:** Abhilash K A T W (IT22081698)  
**Module:** SE4041 – Mobile Application Design and Development  
**Assignment:** Assignment 02, Part B (tvOS)  

---

## 1. Introduction

Welcome to **MemoryMatch**, the two-player living room puzzle game tailored for Apple TV! Using a single Apple TV Remote, two players sit together on the couch, flipping cards, exercising their memory, learning new words, and competing for the top spot on the local leaderboard.

---

## 2. Remote Control Interaction Guide

MemoryMatch uses the standard Apple TV / Siri Remote input model:

| Remote Action | tvOS Function in MemoryMatch |
| :--- | :--- |
| **Touch Surface / D-pad Swipes** | Move focus smoothly across cards, buttons, and tabs |
| **Click / Select Button** | Flip highlighted card, trigger buttons, confirm selections |
| **Back / Menu Button** | Dismiss dialogs, close overlays, navigate to previous screen |
| **Play / Pause Button** | Instantly trigger the Pause overlay during active gameplay |

---

## 3. Walking Through the Five Screens

### Screen 01 — Home
- **Choose Game Mode:**
  - **Classic:** Match two identical everyday pictures (e.g., Apple to Apple).
  - **Learn:** Match a picture card with its English vocabulary word card (e.g., Apple image to word "Apple").
- **Choose Difficulty:**
  - **6 pairs:** 12 cards arranged in a 4-column by 3-row grid.
  - **8 pairs:** 16 cards arranged in a 4-column by 4-row grid.
- **How to Play:** Click the top-right pill to open a clear visual summary of the rules.
- **Start Game:** Advances to Player Setup with your chosen mode and difficulty.
- **Leaderboard:** Jumps straight to the Local Leaderboard.

---

### Screen 02 — Player Setup
- **Two Player Slots:**
  - **Player 1 (Mint Teal):** Displays initial avatar circle and current name (default: Maya).
  - **Player 2 (Amber):** Displays initial avatar circle and current name (default: Leo).
- **Choose Player:** Click "Choose player >" on either card to pick from saved local profiles. (Note: One player profile cannot occupy both slots simultaneously).
- **Add Player:** Click "+ Add player" to create a new profile with the on-screen keyboard.
- **Manage Players:** Click "Manage players" to rename profiles or delete unused profiles.
- **Start Round:** Launches the Game Board with the chosen profiles and game mode!

---

### Screen 03 — Game Board
- **Live Scoreboard:** Shows both players' scores at the top. The player whose turn it is is highlighted with a luminous border and a glowing `"• Your turn"` badge.
- **Gameplay Steps:**
  1. Highlight any face-down card and press **Select** to flip it.
  2. Highlight a second card and press **Select**.
  3. **If they match:** The cards stay face-up with a green checkmark, you earn +1 pair, and **you keep your turn**!
  4. **If they mismatch:** Both cards stay face-up for 1 second so both players can memorize their positions, then flip face-down and switch turns to the second player.
- **Pause Menu:** Click "Pause" (or press the remote Play/Pause button) to Pause the round, Restart the round, or Exit to Home.

---

### Screen 04 — Results
- **Celebration:** Golden trophy with animated confetti particles.
- **Match Outcome:** Displays "[Winner Name] wins!" or "It's a draw!" when pair counts are tied.
- **Score Breakdown:** Shows both players' final pair counts.
- **Save Status:** Displays `"✓ Round saved"` when successfully committed to the database. If storage is unavailable, an error message and a "Retry Save" button are shown.
- **Actions:**
  - **Play Again:** Starts a fresh round immediately with the same players and configuration.
  - **Leaderboard:** Opens the Local Leaderboard to review standings.
  - **Home:** Returns to the Home screen.

---

### Screen 05 — Local Leaderboard
- **Filter Tabs:** Filter by Mode (**All**, **Classic**, **Learn**) and Difficulty (**All**, **6 pairs**, **8 pairs**).
- **Rankings Table:** Ranked by Wins descending, then Pairs descending, and Alphabetical tie-breaking:
  - `#` (Rank), `Player`, `Wins`, `Pairs`, `Played`.
- **Recent Rounds:** Click any recent completed match row to open the **Round Summary** overlay, revealing match timestamps and an option to delete that individual record.
- **Clear Results:** Erases all match records after explicit confirmation.
- **Back Button:** Safely returns to whichever screen opened the Leaderboard (Home or Results).
