# AI BRAIN LINK
The source of truth for this project is the OKF bundle at `brain/okf/`.

**DO NOT WRITE, EDIT, OR DELETE CODE WITHOUT READING `brain/okf/index.md` FIRST.**

## Strict Rules:
1. **START HERE:** Read `brain/okf/index.md`, then `brain/okf/concepts/agent-operating-model.md`. Find files via `brain/okf/references/code-map.md` — avoid blind grepping.
2. **STATE SYNC:** If you create/delete/move a `.dart` file, update `brain/okf/references/code-map.md` and the relevant `brain/okf/modules/*` page in the same change.
3. **NO CODEGEN:** This app uses plain Riverpod (no `riverpod_generator`) and hand-written models (no `freezed`/`json_serializable`). Do **not** run `build_runner`.
4. **LAYERS:** Respect `Widget → Notifier → Repository → ApiClient → API` (see `brain/okf/rules/architecture.md`).
5. **BACKEND CONTRACT:** The API truth is the backend repo `gz_ideation` and its brain at `gz_ideation/brain/okf/` — see `brain/okf/references/backend-brain-link.md`.

The previous `brain/` planning docs are archived under `brain/okf/references/_legacy/`.
</content>
