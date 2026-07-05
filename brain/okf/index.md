---
okf_version: "0.1"
type: Index
title: Gaming Zone App — Knowledge Bundle
description: OKF bundle for the gz_app Flutter dual-client (Player + Admin) frontend of the Gaming Zone platform.
tags: [frontend, flutter, index]
timestamp: 2026-07-04
---

# Gaming Zone App Brain (`gz_app`)

A **Flutter** app that is two products in one codebase: the **Player** app (discovery, booking, sessions,
wallet, notifications, profile, disputes) and the **Admin** dashboard (operations, systems, pricing,
billing, campaigns, disputes, analytics). State = **Riverpod** (no codegen), routing = **go_router**,
HTTP = `http` via a shared `ApiClient`, models = **hand-written** `fromJson` (no freezed/json_serializable).
The paired backend brain is at `gz_ideation/brain/okf/`; domain names match 1:1.

## Start here
* [Project Brain](concepts/project-brain.md) — what the app is, the layered architecture, the two clients.
* [Agent Operating Model](concepts/agent-operating-model.md) — load order + guardrails before you change code.
* [Glossary](concepts/glossary.md) — the shared vocabulary (UI/app word → backend word → code).
* [Context Loading Workflow](workflows/context-loading.md).

## Systems (cross-cutting technical layers)
* [App Shell & Entry](systems/app-shell-and-entry.md) · [Navigation & Routing](systems/navigation-routing.md) · [State Management](systems/state-management.md)
* [API Transport](systems/api-transport.md) · [Auth & Token Storage](systems/auth-and-token.md) · [WebSockets](systems/websockets.md)
* [Responsive & Theme](systems/responsive-and-theme.md) · [Error Handling](systems/error-handling.md)

## Modules (feature areas — one per `lib/features/*`, every screen documented)
[modules/index.md](modules/index.md) — auth, home, booking, sessions, wallet, notifications, profile,
disputes, main-shell (Player) · admin (Admin dashboard). **72 screens** mapped to routes + API calls.

## Data (models & dictionary)
[data/index.md](data/index.md) — model catalogue (`lib/models/`), enums (`enums.dart`), local storage.

## Flows (major UX journeys)
[flows/index.md](flows/index.md) — onboarding/auth, discover→book→pay, check-in→active session, wallet,
disputes, social login, admin operations, admin live monitoring.

## Rules
[rules/index.md](rules/index.md) — architecture, state, data-layer, UI system, navigation, error handling, doc-sync.

## References
[references/index.md](references/index.md) — the 72-screen UX map, code map, feature spec, backend parity, legacy docs.

See [graph.mmd](graph.mmd) and [viz.html](viz.html).
</content>
