# CLAUDE.md
> Points Claude Code and all AI agents to the brain folder.

## Brain Location

The AI context brain for this project is at `../brain/` (sibling to this Flutter app folder).

**Always read `../brain/.ai_index.md` first** before any code changes.

## Brain Load Sequence

1. `../brain/.ai_index.md`
2. `../brain/rules/state_management.md`
3. `../brain/rules/layout_engine.md`
4. `../brain/rules/ui_standards.md`
5. `../brain/rules/data_layer.md`
6. `../brain/rules/error_handling.md`
7. `../brain/rules/navigation.md`
8. `../brain/rules/performance.md`
9. `../brain/features/feature_spec.md`
10. `../brain/features/ux_flow.md`

## Commands

Run from the Flutter app folder:

```bash
# Install deps
flutter pub get

# Run app
flutter run

# Lint
flutter analyze

# Tests
flutter test
flutter test test/path/to/test_file.dart   # single test file
```

**No code generation** — this project does NOT use `@riverpod`, `freezed`, `json_serializable`, or `build_runner`.

## Architecture Summary

- **Two sub-apps** in one codebase: Player (consumer) + Admin (store operator)
- **40 player screens**, 43 API endpoints (see `../brain/features/feature_spec.md`)
- State: hand-written `NotifierProvider<XNotifier, XState>` only — no `@riverpod` generator
- Routing: `go_router` with two `ShellRoute`s (player + admin), route constants in `AppRoutes`
- Data: Service → Repository → Notifier chain; `http` package (not Dio); hand-written models in `lib/models/`
- Real-time: Admin uses `AdminLiveService` (WebSocket); Player WebSocket for Active Session + Notifications (pending implementation)
- Store-scoped: credits, bookings, campaigns, disputes all require `activeStoreIdProvider`
- API base URL controlled by `ApiConstants.baseUrl` — currently `devBaseUrl`; switch to `prodBaseUrl` for production

## Existing Setup

This app already has:
- `flutter_riverpod` configured with `ProviderScope` in `main.dart`
- `go_router` configured in `lib/core/navigation/app_router.dart` (auth guard is **TODO**)
- `ApiClient` configured in `lib/core/api/api_client.dart` (silent refresh + logout wired)
- `TokenStorage` + `accessTokenProvider` + `activeStoreIdProvider` in `lib/core/auth/token_storage.dart`
- `AdminLiveService` (WebSocket) + `adminLiveServiceProvider` in `lib/core/network/`
- Auth feature (player + admin) fully implemented
- Home feature partially implemented

Before adding any new code: check what already exists. Do NOT duplicate existing providers, repositories, or widgets.
