# TournamentTable
A demo project that replicates a **football tournmaent standings table**, similat to Google sheets behaviour:
- Sticky header row
- Sticky left columns (`Position`, `Club`)
- Horizontally + Verically stats area

---

## Problem Overview

Need to build a tournament standings screen displaying team stats in a table format.

Requirements:

- A fixed left column showing team name and position.
- A scrollable right section showing stats (e.g., Matches, Wins, Losses, Points).
- Synced vertical scrolling between left and right tables.
- Synced horizontal scrolling between the right header and table.

## Solution Design
### Approach Overview

Split the UI into four main areas:

| Section      | Component                                           | Description                                             |
| ------------ | --------------------------------------------------- | ------------------------------------------------------- |
| Left Header  | `HeaderView` (from nib)                             | Displays static column headers (e.g. “Position”, “Club”)            |
| Right Header | `HeaderRightView` (from nib, inside `UIScrollView`) | Displays scrollable headers (e.g. "P", "W", "L", "Pts") |
| Left Table   | `UITableView`                                       | Fixed vertical list for team names and position                     |
| Right Table  | `UITableView` (inside `UIScrollView`)               | Horizontally scrollable table for match stats           |

The key is **scroll synchronization** between both UITableViews and scroll views to ensure a consistent experience.

## UI Components

| Component               | Type                               | Purpose                                       |
| ----------------------- | ---------------------------------- | --------------------------------------------- |
| `UIViewController`      | `TournamentViewController`         | Root view managing all subviews and layout    |
| `UITableView`           | Left Table                         | Displays fixed columns (team info)            |
| `UITableView`           | Right Table                        | Displays dynamic columns (stats)              |
| `UIScrollView`          | Right Container                    | Enables horizontal scrolling                  |
| `UIScrollView`          | Header Container                   | Syncs horizontally with the right scroll view |
| `UIView` (xib)          | `HeaderView` / `HeaderRightView`   | Column headers                                |
| `UITableViewCell` (xib) | `LeftTableCell` / `RightTableCell` | Displays each team’s data                     |

## Architecture Pattern

- **MVVM (Model-View-ViewModel)**
- **Model** → Represents team standings data.
- **ViewModel** → Conforms to `TournamentTableViewModelProtocol`, providing data to both tables.
- **View (UIKit)** → Displays the data in synchronized tables and handles scroll logic.

This architecture makes it easy to:
- Replace data sources later (e.g., API instead of static mock).
- Keep `UIViewController` lightweight and focused on presentation logic.

## Potential Pitfalls & Edge Cases

| Category                 | Description                                                                    | Mitigation                                                                |
| ------------------------ | ------------------------------------------------------------------------------ | ------------------------------------------------------------------------- |
| **Scroll Sync Lag**      | Updating multiple scroll views simultaneously can cause “scroll bounce” loops. | Use an `isSyncing` flag to prevent recursive updates.                     |
| **Dynamic Column Width** | Right side table may overflow or underflow based on cell width.                | Calculate `rightContentWidth` dynamically or with `intrinsicContentSize`. |
| **Height Mismatch**      | Left and right tables may get out of sync if row heights differ.               | Use `UITableView.automaticDimension` for consistent heights.              |
| **Data Reload**          | When updating data dynamically, scroll offsets can reset.                      | Cache scroll positions before reload, restore afterward.                  |
| **Performance**          | Large datasets can cause layout lag.                                           | Use cell reuse and lightweight UI components (avoid nested stack views).  |



