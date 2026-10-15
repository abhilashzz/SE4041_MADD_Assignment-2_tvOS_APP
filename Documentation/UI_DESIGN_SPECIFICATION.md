# UI Design Specification: MemoryMatch (tvOS)

**Student:** Abhilash K A T W (IT22081698)  
**Module:** SE4041 – Mobile Application Design and Development  
**Assignment:** Assignment 02, Part B (tvOS)  
**Visual Reference:** Five-Screen Reference Board (Attached in Assignment Brief)  

---

## 1. Design Philosophy & tvOS Human Interface Guidelines

MemoryMatch is designed from the ground up for the **10-foot television experience**:
- **Generous Contrast & Legibility:** Bold off-white text against a dark navy canvas ensures effortless readability across a living room.
- **TV-Safe Margins:** Standard 80pt horizontal and 50pt vertical margins prevent overscan clipping on diverse TV displays.
- **Physical Depth & Lighting:** Raised slate cards (`#1B2D43`) with subtle borders and shadows create distinct visual layering without visual clutter.
- **Focus Engine Harmony:** Components expand smoothly (1.05x–1.08x) with a luminous mint-teal or amber glow when focused by the Apple TV Remote.

---

## 2. Color Palette & Semantic Tokens

| Token Name | Hex Code | RGB Values | Semantic Usage |
| :--- | :--- | :--- | :--- |
| **Deep Navy Background** | `#101B2D` | (16, 27, 45) | Primary screen canvas and backdrops |
| **Slate Panel Surface** | `#1B2D43` | (27, 45, 67) | Raised cards, modal panels, table surfaces |
| **Raised Slate / Border** | `#2A4263` | (42, 66, 99) | Panel strokes, subtle dividing lines, card backs |
| **Mint-Teal Accent** | `#60D5C6` | (96, 213, 198) | Primary action buttons, Player 1 identity, focus halos |
| **Amber Accent** | `#F1BC67` | (241, 188, 103) | Player 2 identity, secondary highlights |
| **Gold Trophy** | `#F6C445` | (246, 196, 69) | Results screen trophy, 1st place leaderboard rank |
| **Off-White Text** | `#F4F6F8` | (244, 246, 248) | Primary headings, titles, card words |
| **Secondary Slate Text**| `#8EACC7` | (142, 172, 199) | Subtitles, captions, table headers |
| **Success Green** | `#4ADE80` | (74, 222, 128) | Matched card checkmark badge, save confirmations |
| **Destructive Red** | `#EF4444` | (239, 68, 68) | Delete buttons, error states, clear actions |

---

## 3. Typography Hierarchy

| Style Role | Font Size / Weight | Design | Usage |
| :--- | :--- | :--- | :--- |
| **Display Title** | 56pt, Heavy | Rounded | Winner announcement headline |
| **Large Title** | 52pt, Heavy | Rounded | Home screen headline |
| **Screen Title** | 38pt, Bold | Rounded | Navigation headers ("Who's playing?", "Leaderboard") |
| **Modal Title** | 34pt, Bold | Rounded | Dialog headers ("How to Play", "Game Paused") |
| **Score Number** | 42pt, Heavy | Rounded | Scoreboard current pair count |
| **Card Word** | 28pt, Bold | Rounded | Learn mode face-up card vocabulary |
| **Button Label** | 24–26pt, Bold | Rounded | Action buttons ("Start Game", "Start Round") |
| **Body Text** | 20–22pt, Regular | Rounded | Explanations, rule descriptions, table rows |
| **Caption / Badge** | 16–18pt, Semibold | Rounded | "PLAYER 1", "Your turn", "ROUND COMPLETE" |

---

## 4. Control & Action Checklist for All Five Screens

### Screen 01 — Home
- [x] MemoryMatch gradient logo mark and title.
- [x] "How to play" pill button opening modal overlay.
- [x] "Classic" mode card (Picture + Picture) with checked indicator.
- [x] "Learn" mode card (Picture + Word) with book icon.
- [x] "6 pairs" pill button with checked indicator.
- [x] "8 pairs" pill button with checked indicator.
- [x] "Start Game" primary button opening Player Setup.
- [x] "Leaderboard" secondary button opening Local Leaderboard.
- [x] 3D floating Apple & Book cards illustration.

### Screen 02 — Player Setup
- [x] "< Back" button returning to Home.
- [x] "Who's playing?" title.
- [x] Player 1 panel with Mint-Teal avatar circle, initial, and name.
- [x] Player 2 panel with Amber avatar circle, initial, and name.
- [x] "Choose player >" buttons backed by local profile repository.
- [x] "+ Add player" button with native text entry and validation.
- [x] "Manage players" button with rename and confirmed delete.
- [x] "Match a pair to keep your turn." guidance text.
- [x] "Start Round" primary action button.

### Screen 03 — Game Board
- [x] Top header with Mode and Difficulty title ("Classic • 6 pairs").
- [x] "Pause" button opening Pause overlay.
- [x] Player 1 score panel with avatar, name, and glowing "• Your turn" indicator.
- [x] Player 2 score panel with avatar, name, and glowing "• Your turn" indicator.
- [x] 4-column card grid (12 cards for 6 pairs, 16 cards for 8 pairs).
- [x] 3D flip animation between card back and card front.
- [x] Green checkmark corner badge on matched cards.
- [x] Non-revealing accessibility labels for face-down cards.
- [x] "X of Y pairs found" progress text.
- [x] Pause overlay with Resume, Restart, and Exit with confirmations.

### Screen 04 — Results
- [x] "ROUND COMPLETE" header tag.
- [x] Golden trophy with colorful celebratory confetti particles.
- [x] "[Winner] wins!" or "It's a draw!" announcement.
- [x] Player 1 final pair score card.
- [x] Player 2 final pair score card.
- [x] Completed mode & difficulty tags.
- [x] "✓ Round saved" real persistence status indicator (with error & retry handling).
- [x] "Play Again" button starting rematch.
- [x] "Leaderboard" button.
- [x] "Home" button.

### Screen 05 — Local Leaderboard
- [x] "< Back" button returning to originating screen.
- [x] "Local Leaderboard" title.
- [x] Mode filter pills: All modes, Classic, Learn.
- [x] Difficulty filter pills: All difficulties, 6 pairs, 8 pairs.
- [x] Leaderboard ranking table: `#`, `Player`, `Wins`, `Pairs`, `Played`.
- [x] Deterministic sorting by Wins desc, Pairs desc, Name asc.
- [x] "Recent rounds" section with match cards.
- [x] Focusable match rows opening Round Summary overlay with single delete.
- [x] "Clear Results" button with destructive confirmation dialog.
- [x] Empty state view when no records match filter.
