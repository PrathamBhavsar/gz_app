---
name: riverpod-codegen-guard
description: Use when creating, editing, or reviewing Riverpod providers, notifiers, AsyncValue handling, generated provider files, Freezed models, JsonSerializable models, or build_runner output.
---

# Riverpod Codegen Guard

## Purpose

Prevent agents from mixing Riverpod styles or forgetting required generation steps.

## Required Context

Use `brain-router`, then load the repo's state management and data layer rules. Confirm whether this repo uses Riverpod generator syntax, plain Riverpod providers, or a known migration state.

## Provider Rules

- Follow the repo's approved Riverpod style exactly.
- Keep business logic in notifiers/providers, not widgets.
- Use `AsyncValue` or the project's approved state wrapper for async work.
- Use `.select` or scoped providers where the performance rules require it.
- Do not introduce `ChangeNotifier`, `ValueNotifier`, legacy provider package, or `setState` in feature state.

## Codegen Rules

Run the repo's build command after any change to:

- `@riverpod`
- `@freezed`
- `@JsonSerializable`
- `part` / `part of` declarations
- generated model/provider dependencies

Default command if the brain does not override it:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Generated Files

- Do not hand-edit `.g.dart`, `.freezed.dart`, or generated provider files.
- If generated output changes unexpectedly, inspect the source annotation first.
- If generation fails, fix source files and rerun generation.

## Review Checklist

- Provider style matches current repo rules.
- Widgets read state but do not own business/data logic.
- Async loading/error/data states are represented.
- Generated files are current after source changes.
