# 021 Trade — Watchlist BLoC Assignment

A Flutter application implementing a stock watchlist with drag-to-reorder functionality, using **BLoC architecture** as the state management pattern.

---

## Project Structure

```
lib/
├── core/
│   └── theme/
│       └── app_theme.dart          # Centralized theme, colors, typography
│
├── data/
│   ├── datasources/
│   │   └── watchlist_data_source.dart   # Static sample data
│   ├── models/
│   │   ├── stock.dart              # Stock entity (Equatable)
│   │   ├── watchlist.dart          # Watchlist entity (Equatable)
│   │   └── market_index.dart       # Market index entity (Equatable)
│   └── repositories/
│       └── watchlist_repository.dart    # Abstract interface + impl
│
└── features/
    └── watchlist/
        ├── bloc/
        │   ├── watchlist_bloc.dart  # BLoC + event handlers
        │   ├── watchlist_event.dart # Sealed event classes (part of)
        │   └── watchlist_state.dart # State class (part of)
        ├── screens/
        │   ├── watchlist_screen.dart      # Main watchlist view
        │   └── edit_watchlist_screen.dart # Edit / reorder view
        └── widgets/
            ├── market_header_banner.dart  # Index ticker banner
            ├── search_bar_021.dart        # Search bar
            ├── stock_list_tile.dart       # Read-only stock row
            ├── edit_stock_tile.dart       # Drag-handle + delete row
            └── rename_watchlist_dialog.dart

test/
└── watchlist_bloc_test.dart   # Full BLoC unit test suite
```

---

## BLoC Architecture

### Events (sealed classes)
| Event | Description |
|---|---|
| `WatchlistInitialized` | Loads watchlists + market indices from repository |
| `WatchlistTabChanged(int)` | Switches active watchlist tab |
| `WatchlistEditModeToggled` | Enters/exits edit mode |
| `WatchlistStockReordered(watchlistId, oldIndex, newIndex)` | Moves a stock position |
| `WatchlistStockRemoved(watchlistId, stockId)` | Deletes a stock |
| `WatchlistRenamed(watchlistId, newName)` | Renames a watchlist |
| `WatchlistSaved` | Commits edit-mode changes |

### State
`WatchlistState` is a single immutable value object holding:
- `status` — `WatchlistStatus` enum (initial / loading / success / failure)
- `watchlists` — ordered list of `Watchlist` entities
- `marketIndices` — list of `MarketIndex` entities for the banner
- `activeTabIndex` — currently selected watchlist tab
- `isEditMode` — whether drag-to-reorder UI is visible
- `errorMessage` — optional failure reason

### Reorder Strategy
The BLoC applies an **optimistic update** for stock reordering:
1. The new order is applied immediately in-memory → UI updates instantly with no jank.
2. The repository call runs in the background to persist.
3. On failure, the list is rolled back by re-fetching from the repository.

---

## Key Design Decisions

| Concern | Decision |
|---|---|
| **Type safety** | `sealed` event classes, `Equatable` models, `abstract interface` repository |
| **Immutability** | All state/model mutations go through `copyWith` — no direct mutation |
| **Reusability** | Widgets are stateless and receive only the data they need |
| **Testability** | Repository behind an interface → easily swapped with `FakeWatchlistRepository` in tests |
| **UX** | `ReorderableListView` with custom `proxyDecorator` for an elevated drag shadow |

---

## Running the App

```bash
flutter pub get
flutter run
```

## Running Tests

```bash
flutter test
```

# trading_app

