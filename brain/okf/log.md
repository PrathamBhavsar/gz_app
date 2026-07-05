# Brain Update Log

## 2026-07-05 — Login credential shortcut chips
* Added hardcoded credential chips from `creds.txt` to the player email login and admin login screens.
* Admin login now presents separate Staff and Admin credential rows; tapping any chip fills the email and password fields only.

## 2026-07-04 — Consolidated to unified OKF taxonomy (canonical brain)
* Made `brain/okf/` the **single** source of truth for the frontend and adopted the taxonomy shared with
  the backend brain (`concepts/ systems/ modules/ data/ flows/ rules/ workflows/ references/`).
* **concepts**: project-brain, agent-operating-model, glossary (shared vocabulary), open-knowledge-format.
* **systems**: app-shell-and-entry, navigation-routing (guards/shells/deep-links), state-management,
  api-transport, auth-and-token, websockets, responsive-and-theme, error-handling, backend-contract.
* **modules**: 11 feature areas documenting all **72 screens** (route → screen → API → nav): auth, home,
  booking, sessions, wallet, notifications, profile, disputes, main-shell (Player) + admin (32 screens).
* **data**: models catalogue, enums (with backend mapping + drift notes), local storage.
* **flows**: onboarding-and-auth, social-login, discover-book-pay, check-in-active-session, wallet-credits,
  disputes, notification-handling, admin-operations, admin-live-monitoring.
* **rules**: architecture, state-management, data-layer, ui-system, navigation, error-handling, doc-sync.
* **Consolidation**: folded the old `brain/` into this bundle — `ux_flow.md` → [references/ux-flow](references/ux-flow.md),
  `code_map.md` → [references/code-map](references/code-map.md), `feature_spec.md` → references/feature-spec,
  parity audit → [references/backend-parity](references/backend-parity.md); archived planning/phase/registry
  docs under `references/_legacy/`. Added the cross-link to the backend brain.
* Sourced from `lib/core/navigation/app_router.dart`, `routes.dart`, `lib/models/enums.dart`, `code_map.md`,
  `ux_flow.md`, and the live `lib/features/**` structure. Root `CLAUDE.md` updated to point here.

## 2026-07-04 — Initial codex bundle (superseded)
* Original OKF bundle at `brain/okf/` with shallow concepts/features/systems/rules — replaced by this rebuild.
</content>
