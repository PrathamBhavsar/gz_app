# Phase 13 — Admin Analytics — Inconsistencies & Notes
Pass 1 review: [x]    Pass 2 review: [x]
Dummy data fully removed: [x]    flutter analyze clean: [x]

## Endpoint / contract mismatches (backend vs Flutter)
- `analyticsDashboard` has no explicit `walkInCount` field; the dashboard screen now shows
  `occupancyRate` in the fourth KPI card instead of Walk-ins (Walk-ins belongs to `SessionStatsModel`).
- `analyticsRevenue` has no payment breakdown (Cash/UPI/Credits split); the revenue screen
  previously showed hardcoded payment breakdown. The "Payment breakdown" card has been removed
  and replaced with a single "Breakdown" table showing date/sessions/revenue from API.
- `analyticsPlayers` returns aggregate stats only (`uniquePlayers`, `newPlayers`, `returningPlayers`,
  `topPlayerMinutes`) — no individual player list. The "Top players" list with names/avatars has
  been removed from the player analytics screen.
- `analyticsSessionStats` returns aggregate stats only — no session list. The "Recent sessions"
  section with per-session rows has been removed from the session stats screen.
- Dashboard period filter only supports 'Today' and '7 Days'; the old 'Custom' chip is removed
  (would require date range picker + different API params).

## Missing / renamed endpoints or constants
- All 6 analytics constants already existed in `api_constants.dart`:
  `analyticsDashboard`, `analyticsRevenue`, `analyticsUtilization`,
  `analyticsSessionStats`, `analyticsPlayers`, `analyticsSystemPerformance`.

## Model ↔ JSON field mismatches (nullable, casing, types)
- Revenue values throughout analytics are `String?` (not numeric). Parsed via `double.tryParse()`
  for summing and height normalization; displayed with `toStringAsFixed(0)`.
- `UtilizationHourModel` uses snake_case JSON keys (`hour_of_day`, `systems_in_use`, etc.).
  The heatmap now renders one cell per hour (single row) from actual data instead of the fake
  12×14 pseudo-random grid.
- `SystemPerformanceEntry.utilizationRate` is `String?`; parsed to double for the progress bar
  and the `< 40%` low-usage threshold check.

## Registry ↔ code drift fixed
- No existing registry entry for Phase 13 analytics.

## Dummy data removed (file:line)
- `admin_analytics_screen.dart` — `_kpis`, `_quickLinks`, `_barHeights`, `_days`, `_KpiData`, `_QuickLinkData`
- `revenue_analytics_screen.dart` — `_rows` (6 hardcoded revenue rows), `_RevenueRow` class, payment breakdown card
- `utilization_heatmap_screen.dart` — `_rows`, `_cols`, `_intensity()`, `_hours` (hardcoded), `_colorFor()` (kept but using real intensities now)
- `session_statistics_screen.dart` — `_kpis`, `_sessions`, `_KpiData`, `_SessionRow` classes
- `player_analytics_screen.dart` — `_players` (5 hardcoded rows), `_PlayerRow` class
- `system_performance_screen.dart` — `_systems` (6 hardcoded entries), `_SystemCardData` class

## Architecture notes
- `AdminAnalyticsDashboardNotifier` loads both `analyticsDashboard` and `analyticsRevenue`
  in parallel (two futures started before awaiting) to populate KPIs + bar chart in one notifier.
- Data classes `AdminAnalyticsDashboardData`, `AdminRevenueData`, `AdminUtilizationData` added
  to `admin_management_models.dart`. Simpler endpoints (session stats, players, system perf)
  use the domain model directly as the `AsyncNotifier` state type.

## Open TODOs / deferred
- 'Custom' date range filter on the dashboard (requires date picker + `date_from/date_to` params).
- Payment breakdown by method (Cash/UPI/Credits) requires either a dedicated endpoint or
  inclusion in the revenue analytics response shape.
- Individual player list with names/avatars would require a paginated players endpoint.
- Individual session list would require a paginated sessions endpoint.
