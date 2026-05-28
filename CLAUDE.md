# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@AGENTS.md

## Claude-specific notes

- Navigation pattern: top-level `TabView` (Components / Scenarios / Permissions) → `NavigationStack` per tab → full-screen covers for modal flows.
- `ObservableObject` + `@Published` for all ViewModels — follow this pattern unless explicitly asked to migrate.
- Do **not** add redundant `@MainActor` — `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` is set project-wide.
- Do not silently create a test target unless the task explicitly includes it.
- If Xcode verification can't run in the current environment, state what was checked and what remains unverified.
