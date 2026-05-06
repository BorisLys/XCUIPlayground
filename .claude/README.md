# Claude Workspace Notes

This directory contains project-level Claude Code configuration for
XCUIPlayground.

Claude Code discovers project subagents from `.claude/agents/*.md`. If these
files are added during an active Claude session, restart the session or use
`/agents` so Claude reloads them.

Read order for Claude work:

1. `AGENTS.md`
2. `.claude/project-context.md`
3. The relevant subagent in `.claude/agents/`

Available subagents:

- `xcui-developer` - SwiftUI feature implementation and refactoring.
- `xcui-test-engineer` - XCTest, XCUITest, UI testability, and unit test design.
- `xcui-designer` - Native iOS UX, accessibility, and SwiftUI screen design.

Reference: https://docs.claude.com/en/docs/claude-code/subagents
