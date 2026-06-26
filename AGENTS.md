# Agent Instructions

This repo is governed by the project brain. Before generating, modifying, or reviewing code:

1. Read `CLAUDE.md` if present.
2. Read `brain/.ai_index.md` in full.
3. Load the rule files mapped to the current task intent.
4. Use project skills from `.agents/skills/` when relevant.

Recommended common skills:

- `brain-router` for context loading and task routing.
- `flutter-feature-slice` for vertical Flutter feature work.
- `ui-system-enforcer` for UI, layout, responsive, animation, and design-token work.
- `api-contract-integrator` for endpoint, repository, model, cache, and error handling work.
- `riverpod-codegen-guard` for Riverpod, Freezed, JsonSerializable, and build_runner changes.

Do not write Flutter code before reading `brain/.ai_index.md`.
