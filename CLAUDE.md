# CLAUDE.md - AI Assistant Context for QuikPik

## Project Overview

**QuikPik** is a cross-platform mobile and web application built with Flutter/Dart that provides four distinct randomness-generation utilities in a single, easy-to-use interface.

**Version:** 1.0.1+2
**License:** MIT License (Copyright 2025 taylor learns machines)
**Status:** Production-ready, version 1.0 released

## Purpose

QuikPik serves as a multi-purpose random generator tool designed to help users make quick decisions and generate random outcomes for various scenarios. Whether you need to flip a coin, generate a random number, pick a color, or select an item from a list, QuikPik provides an intuitive interface following Material Design 3 guidelines.

## Technology Stack

### Core Framework
- **Flutter SDK:** Latest stable (Dart 3.7.2+)
- **Platform Support:** Android, iOS, Web
- **UI Framework:** Material Design 3
- **State Management:** Widget-level setState() + SharedPreferences for persistence

### Key Dependencies
```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8
  provider: ^6.1.1              # Available but not actively used
  shared_preferences: ^2.2.2    # Local data persistence
  flutter_animate: ^4.5.0       # Smooth animations
  google_fonts: ^6.1.0          # Poppins typography
```

### Development Tools
- **flutter_lints:** ^5.0.0 (code quality enforcement)
- **flutter_test:** Widget testing framework

## Architecture

### Project Structure
```
lib/
├── main.dart                     # App entry point, theme, navigation
└── screens/                      # Feature screens
    ├── coin_flip_screen.dart
    ├── random_number_screen.dart
    ├── random_color_screen.dart
    └── list_selector_screen.dart
```

### Navigation Pattern
- **Root Widget:** MaterialApp with Deep Purple theme
- **Main Screen:** IndexedStack with BottomNavigationBar
- **4 Screens:** Each accessible via bottom navigation tabs

### State Management Approach
- **UI State:** Local StatefulWidget with setState()
- **Persistent Data:** SharedPreferences for cross-session storage
- **No Global State:** Each screen manages its own state independently

## Features

### 1. Coin Flip Screen (`lib/screens/coin_flip_screen.dart`)
- **Icon:** monetization_on
- **Functionality:** Simulates a coin flip with 50/50 outcome
- **UI Elements:**
  - Large circular coin display (200x200px)
  - 3D rotation animation using Matrix4 transforms
  - 10-flip animation sequence over 1000ms
  - Visual icons for heads/tails states
  - Floating Action Button labeled "Flip the coin"
- **Animation:** Custom AnimationController with rotation effects

### 2. Random Number Generator (`lib/screens/random_number_screen.dart`)
- **Icon:** numbers
- **Functionality:** Generates random integers within specified bounds
- **UI Elements:**
  - Two TextFields for lower/upper bounds
  - Large result display (48px font)
  - FAB labeled "Roll the dice"
- **Persistence:** Saves bounds to SharedPreferences (default: 1-6)
- **Validation:**
  - Ensures valid integer inputs
  - Ensures lower bound < upper bound
  - Error messaging via SnackBar

### 3. Random Color Generator (`lib/screens/random_color_screen.dart`)
- **Icon:** color_lens
- **Functionality:** Generates random colors from user-selected palette
- **UI Elements:**
  - Full-screen color display with AnimatedContainer (500ms transitions)
  - Top bar with color selection toggles
  - Color selection modal with checkboxes
  - White FAB with colored icon labeled "Pick a New Color"
- **Available Colors:** Red, Orange, Yellow, Green, Blue, Purple
- **Persistence:** Saves selected colors configuration
- **Validation:** Requires at least one color selected

### 4. List Item Selector (`lib/screens/list_selector_screen.dart`)
- **Icon:** list
- **Functionality:** Random selection from user-created lists
- **UI Elements:**
  - TextField for adding items
  - Scrollable ListView of items with delete buttons
  - Item counter "Items (X/10)"
  - Dialog modal showing selected item
  - FAB labeled "Pick an item"
- **Limits:** Maximum 10 items
- **Persistence:** Saves entire list to SharedPreferences
- **Selection Algorithm:** Timestamp-based randomization

## Design System

### Color Scheme
- **Seed Color:** Deep Purple (Colors.deepPurple)
- **Theme:** Material Design 3 with light brightness
- **Dynamic Color Scheme:** Generated from seed color

### Typography
- **Font Family:** Poppins (via google_fonts package)
- **Font Sizes:** 12px, 16px, 18px, 20px, 24px, 48px
- **Text Styles:** Apply Material 3 text theme hierarchy

### UI Components
- **Bottom Navigation Bar:** 4 items with icons and labels
- **Floating Action Buttons:** Primary actions for each screen
- **Cards & ListTiles:** Content display
- **TextFields:** User input with validation
- **Dialogs:** Modal interactions
- **SnackBars:** Error/success notifications
- **AnimatedContainer:** Smooth UI transitions

## Data Persistence

### SharedPreferences Keys
```dart
// Random Number Screen
"lowerBound" -> int (default: 1)
"upperBound" -> int (default: 6)

// Random Color Screen
"selectedColors" -> List<String> (color names)

// List Selector Screen
"list_items" -> List<String> (user items)
```

### Loading Pattern
All screens implement async initialization:
```dart
@override
void initState() {
  super.initState();
  _loadPreferences();
}
```

## Build Configuration

### Android (`android/gradle.properties`)
```properties
org.gradle.jvmargs=-Xmx8G -XX:MaxMetaspaceSize=4G -XX:ReservedCodeCacheSize=512m
android.useAndroidX=true
android.enableJetifier=true
```

### iOS (`ios/Podfile`)
- Standard Flutter iOS configuration
- Xcode workspace setup
- CocoaPods dependency management

### Web (`web/manifest.json`)
- Progressive Web App support
- Favicon and app icons configured

## Development Guidelines

### Code Style
- Follow `flutter_lints` ^5.0.0 rules
- Material Design 3 guidelines
- Dart SDK 3.7.2+ features available

### File Organization
- One screen = one file
- Screen files in `lib/screens/`
- Main app logic in `lib/main.dart`

### State Management
- Use `setState()` for local UI state
- Use `SharedPreferences` for persistence
- Avoid global state management

### Testing
- Widget tests in `test/` directory
- Base widget test available in `test/widget_test.dart`

## Assets

### Screenshots
Located in `assets/images/`:
- Individual feature screenshots (coin-flip, number-generator, color-generator, list-selector)
- Composite screenshot showing all features
- Feature graphic for app stores
- Design mockups (01.png - 04.png)

### Icons
- iOS icons in `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Generated using Icon Kitchen

## Common Development Tasks

### Running the App
```bash
# Get dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Run on specific platform
flutter run -d chrome        # Web
flutter run -d android       # Android
flutter run -d ios          # iOS (macOS only)
```

### Building
```bash
# Android APK
flutter build apk

# Android App Bundle (for Play Store)
flutter build appbundle

# iOS (macOS only)
flutter build ios

# Web
flutter build web
```

### Testing
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Known Considerations

### Provider Package
- `provider: ^6.1.1` is included in dependencies but not actively used
- Current implementation uses local state management
- Can be utilized for future features requiring global state

### Sound Effects
- Mentioned in build-plan.md as optional enhancement
- Not currently implemented
- Would require audio package (e.g., audioplayers)

### Platform Support
- Fully configured for Android, iOS, and Web
- Cross-platform testing recommended before releases

## Version History

**1.0.1+2** (Current)
- Final release version
- Screenshots added to assets
- List selector focus behavior updated
- Gradle config optimized for release

## Contact & Attribution

**Copyright:** 2025 taylor learns machines
**License:** MIT License (see LICENSE file)
**Repository:** bluestemso/quikpik_app

## AI Assistant Notes

When working on this project:
1. **Respect the existing architecture** - Each screen is self-contained
2. **Maintain Material Design 3 compliance** - Use theme colors and components
3. **Preserve data persistence** - SharedPreferences pattern is established
4. **Follow Flutter best practices** - Widget lifecycle, async/await patterns
5. **Keep dependencies minimal** - Only add packages when necessary
6. **Test cross-platform** - Changes should work on Android, iOS, and Web
7. **Update version numbers** - Follow semver in pubspec.yaml when making changes

### Helpful Context
- The app is production-ready and released
- Focus on bug fixes and minor enhancements
- Major architectural changes should be discussed first
- Screenshots should be updated if UI changes significantly
- All user-facing text should be clear and concise
