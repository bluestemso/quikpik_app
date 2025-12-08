# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

QuikPik is a Flutter-based multi-purpose randomness generator app with four main features: coin flips, random number generation, random color generation, and random list item selection. Built with Material Design 3 principles and uses Google Fonts (Poppins) for typography.

## Development Commands

### Running the App
```bash
flutter run
```

### Testing
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Building
```bash
# Android
flutter build apk

# iOS
flutter build ios
```

## Architecture

### Navigation Structure
- Main navigation uses a `BottomNavigationBar` with 4 tabs
- Defined in `lib/main.dart` (`MainScreen` widget)
- Navigation index controls which screen is displayed from a static list
- Each screen is a separate stateful widget in `lib/screens/`

### Screen Organization
Each feature screen follows a consistent pattern:
- **Self-contained StatefulWidget** - Each screen manages its own state independently
- **Persistent state via SharedPreferences** - User preferences (like color selections and list items) are saved locally
- **Consistent UI patterns** - FloatingActionButton for primary actions, SafeArea for proper padding

#### Screen-Specific Details

**Coin Flip Screen** (`lib/screens/coin_flip_screen.dart`)
- Uses `AnimationController` with `SingleTickerProviderStateMixin`
- 3D rotation animation via `Matrix4.rotateY()`
- Random boolean determines heads/tails outcome

**Random Number Screen** (`lib/screens/random_number_screen.dart`)
- Text inputs for lower and upper bounds
- Generates random integers within specified range

**Random Color Screen** (`lib/screens/random_color_screen.dart`)
- Six predefined colors (red, orange, yellow, green, blue, purple)
- Horizontal scrollable color selector at top (120px height)
- User can toggle which colors are enabled for random selection
- Selected colors saved to SharedPreferences as string list
- `AnimatedContainer` transitions background color smoothly (500ms)
- Shows loading state during SharedPreferences initialization

**List Selector Screen** (`lib/screens/list_selector_screen.dart`)
- Maximum 10 items allowed in the list
- Items persisted via SharedPreferences under key `'list_items'`
- TextField with add button for item entry
- ListView displays items with delete buttons
- Random selection uses modulo operation: `DateTime.now().millisecondsSinceEpoch % _items.length`
- Dialog shows selected item result
- Focus management: Dismisses keyboard when tapping outside or closing dialog

### State Management
- No global state management library (no Provider usage despite dependency)
- Each screen manages local state with `setState()`
- Persistent data handled via `shared_preferences` package
- `shared_preferences` used for:
  - Color picker configuration (which colors are enabled)
  - List items in the list selector

### Key Dependencies
- `provider: ^6.1.1` - Listed but not actively used in current codebase
- `shared_preferences: ^2.2.2` - Local data persistence
- `flutter_animate: ^4.5.0` - Listed but not actively used in current screens
- `google_fonts: ^6.1.0` - Poppins font family applied globally in theme

### Theming
- Material Design 3 (`useMaterial3: true`)
- Theme uses `ColorScheme.fromSeed(seedColor: Colors.deepPurple)`
- Light mode only
- Google Fonts Poppins applied to entire app via `textTheme`

## Important Patterns

### Error Handling
Screens show SnackBar notifications for:
- Empty state errors (e.g., "Please add some items first")
- Validation errors (e.g., "Maximum of 10 items allowed")
- SharedPreferences failures during load/save operations

### Focus Management in List Selector
When dialogs are dismissed, explicitly call `FocusScope.of(context).unfocus()` to prevent automatic focus on text fields. The entire screen is wrapped in `GestureDetector` to dismiss keyboard on outside tap.

### Animation Patterns
- Coin flip uses `AnimationController.forward(from: 0)` for repeatable animations
- Number of flips and duration are constants that can be adjusted
- Color screen uses `AnimatedContainer` for smooth color transitions

## Project Structure
```
lib/
├── main.dart                          # App entry point, theme, and bottom nav
└── screens/
    ├── coin_flip_screen.dart          # Coin flip with 3D animation
    ├── random_number_screen.dart      # Number generator with bounds
    ├── random_color_screen.dart       # Color picker with toggle selection
    └── list_selector_screen.dart      # List item randomizer
```

## Version & Release
Current version: `1.0.1+2`
- Follows semantic versioning: `MAJOR.MINOR.PATCH+BUILD_NUMBER`
- Published to: Not published (`publish_to: 'none'`)
