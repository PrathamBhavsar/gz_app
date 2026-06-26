---
name: flutter-feature-slice
description: Use when implementing or changing a Flutter feature, screen, user flow, route, provider, repository, or vertical product slice.
---

# Flutter Feature Slice

## Purpose

Build one thin, coherent feature slice that follows the repo architecture from UI to state to data, instead of scattering partial code.

## Preconditions

- Use `brain-router` first.
- Identify the feature name, owning folder, route, state owner, data source, and registry entry.
- Confirm the repo's actual stack: Riverpod version/style, Dio vs http, Freezed vs manual models, codegen requirements.

## Slice Order

1. Registry/spec: create or update the feature registry if required by the brain.
2. Model: add immutable/serializable model only in the repo-approved style.
3. Data: add repository/API client code below the notifier layer.
4. State: add provider/notifier with loading, error, empty, and data behavior.
5. UI: add screen/widget using design tokens and responsive primitives.
6. Routing: add route constants and router entries.
7. Verification: run formatter, analyzer, codegen, and focused tests relevant to changed files.
8. Context sync: update code map/registry/graph only when the repo rules require it.

## Guardrails

- Data flow must stay `Widget -> Notifier/Provider -> Repository -> API`.
- Widgets must not call repositories or clients directly.
- Do not duplicate existing providers, repositories, routes, widgets, or models.
- Do not create a whole architecture for a small feature; extend the existing pattern.
- Keep generated files generated; never hand-edit `.g.dart` or `.freezed.dart`.

## Completion Checklist

- Feature works through the intended route or entry point.
- Loading, error, empty, and success states exist for data-bound UI.
- Any codegen-triggering changes were followed by the repo's build command.
- Registry/code map/docs are in sync if files were added, moved, or deleted.
