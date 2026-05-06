# AGENTS.md — XCUIPlayground

## What this repo is

A SwiftUI playground app built specifically for practicing XCUI UI testing. It provides deterministic screens and flows (login, biometric auth, permissions, common components) so UI tests can be written against stable, reproducible targets.

## How to build & run

- Open `XCUIPlayground.xcodeproj` in Xcode (minimum Xcode 26 / Swift 6).
- Select an iOS Simulator or device target.
- Build & run (`⌘R`). No CLI build commands — everything is managed by Xcode.
- No SPM packages, no CocoaPods, no package managers. Single Xcode target, no external dependencies.

## Project structure

```
XCUIPlayground/
  XCUIPlaygroundApp.swift        ← @main entry point → ContentView
  Features/
    Components/                  ← UI component playground (buttons, inputs, toggles, sliders, steppers, pickers, alerts, modals, web view, safari view)
    Scenarios/                   ← E2E flow playground (login, biometric auth, async loading, error states)
    Permissions/                 ← System permission flows (location, photos, contacts, notifications)
  Resources/
    Assets.xcassets/             ← App icon, accent color
    Localization/                ← en/ru string catalogs (Localizable.xcstrings)
```

## Architecture conventions

- **SwiftUI + MVVM** — every feature has `Views/`, `ViewModels/`, and `Models/` subdirectories.
- **`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`** — all Swift files run on the main actor by default. Do not add `@MainActor` redundantly.
- **`SWIFT_UPCOMING_FEATURE_MEMBER_IMPORT_VISIBILITY = YES`** — module-level access control is enforced.
- **Localization** uses `String(localized: "...")` with `.xcstrings` catalogs, not `.strings` files. Symbols are auto-generated (`STRING_CATALOG_GENERATE_SYMBOLS = YES`).

## Supported platforms

iOS 26+, visionOS 26+, macOS 26+. Device families: iPhone, iPad, Mac Catalyst (TARGETED_DEVICE_FAMILY = "1,2,7").

## Testing

- **No test target or test files exist yet.** This repo is the *app under test* for external XCUI test projects.
- When writing XCUI tests against this app, use the simulator or a physical device. Tests live in a separate test target/project.
- Key testability features: deterministic UI states, predictable component accessibility labels, isolated flows.

## CI / Linting / Formatting

None configured. No `.github/`, no pre-commit hooks, no SwiftLint, no formatter config. All development is local via Xcode.
