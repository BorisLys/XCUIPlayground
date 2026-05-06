# XCUIPlayground Project Context

## Project Purpose

XCUIPlayground is a SwiftUI playground app for practicing iOS UI automation with
XCUITest/XCUIAutomation. The app should stay deterministic, easy to inspect, and
stable for external UI test projects.

Primary users:

- QA engineers writing reliable iOS UI automation.
- iOS engineers checking SwiftUI testability patterns.
- Teams using the app as onboarding or training material.

## Platform And Tooling

- Xcode 26 minimum, Swift 6.
- Supported platforms: iOS 26+, visionOS 26+, macOS 26+.
- Device families: iPhone, iPad, Mac Catalyst.
- Single Xcode target.
- No SPM packages, CocoaPods, or external package managers.
- No CI, SwiftLint, formatter config, or pre-commit hooks.
- Build and run are managed in Xcode. Do not introduce CLI-only workflows as the
  normal path.

## Source Layout

```text
XCUIPlayground/
  XCUIPlaygroundApp.swift
  Features/
    Components/
      Views/
      ViewModels/
      Models/
    Scenarios/
      Views/
      ViewModels/
      Models/
    Permissions/
      Views/
      ViewModels/
      Models/
  Resources/
    Assets.xcassets/
    Localization/
      Localizable.xcstrings
```

## Architecture Rules

- Use SwiftUI + MVVM.
- Keep each feature under `Views/`, `ViewModels/`, and `Models/`.
- Current ViewModels use `ObservableObject` and `@Published`; follow the local
  pattern unless a task explicitly asks to migrate.
- `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`; do not add redundant
  `@MainActor`.
- `SWIFT_UPCOMING_FEATURE_MEMBER_IMPORT_VISIBILITY = YES`; keep imports and
  access control explicit enough for Swift 6.
- Use `String(localized: "...")` and update `Localizable.xcstrings` for user
  visible text.
- Prefer simple deterministic state over timers, randomness, network calls, or
  device-specific behavior.

## Testability Rules

- The repository currently has no test target or test files.
- The app is the app under test for external XCUI test projects.
- When adding UI, give interactive and asserted elements stable accessibility
  identifiers where text alone would be fragile.
- UI tests should prefer accessibility identifiers over localized strings.
- Unit tests require a test target. Do not silently create a test target unless
  the task explicitly includes it.
- Keep flows reproducible: expose clear states, avoid hidden async timing, and
  make loading/error states observable in the UI.

## Change Discipline

- Keep edits scoped to the requested feature or agent documentation.
- Do not add dependencies or broad infrastructure unless explicitly requested.
- Do not rewrite unrelated screens for style consistency.
- If verification cannot be run through Xcode in the current environment, state
  what was checked and what remains unverified.
