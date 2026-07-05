---
type: Module
title: Admin Dashboard
description: The full admin client — auth + Operations / Analytics / Management / Store tabs + CRUD, all store-scoped.
resource: file://lib/features/admin
tags: [admin, dashboard, operations, analytics, management, store]
timestamp: 2026-07-04
---

# Responsibilities
The entire admin experience for one store (scope from the admin JWT). Hosted by `AdminShell` (4 tabs).
~16 repositories in `data/repositories/` (admin_dashboard, admin_sessions, admin_bookings, analytics,
pricing, admin_billing, payments, admin_campaigns, admin_credits, admin_disputes, admin_notify_send,
systems_admin, system_types, store_admins, store_config, admin_store_repository_support) and ~40 notifiers
(read notifiers + `*_command_notifier`s for mutations, `admin_command_state.dart`). Backend: every
[admin route group](../references/backend-brain-link.md).

# Auth
| # | Screen | Route | Backend call |
| --- | --- | --- | --- |
| 41 | AdminLoginScreen | `/auth/admin-login` | `POST /auth/admin/login` |
| 42 | AdminPasswordResetScreen | `/auth/admin-password-reset?token=` | admin reset request/confirm |

# Tab 1 — Operations
| # | Screen | Route | Backend call |
| --- | --- | --- | --- |
| 43 | AdminDashboardScreen | `/admin/dashboard` | `GET .../analytics/dashboard`, `.../systems/live` (+ [admin-live WS](../systems/websockets.md)) |
| 44 | SessionManagementScreen | `/admin/sessions?systemId=` | `GET .../sessions`, `.../sessions/active`; end/extend/pause/resume |
| 45 | WalkInBookingScreen | `/admin/walk-in` | `POST .../bookings/walk-in` |
| 46 | BookingManagementScreen | `/admin/bookings` | `GET .../bookings`, `PATCH .../bookings/:id` |
| 47 | AdminBookingDetailScreen | `/admin/bookings/:id` | `GET .../bookings/admin/:id` |

# Tab 2 — Analytics
| # | Screen | Route | Backend call |
| --- | --- | --- | --- |
| 48 | AdminAnalyticsScreen | `/admin/analytics` | `GET .../analytics/dashboard` |
| 49 | RevenueAnalyticsScreen | `/admin/analytics/revenue` | `GET .../analytics/revenue` |
| 50 | UtilizationHeatmapScreen | `/admin/analytics/utilization` | `GET .../analytics/utilization` |
| 51 | SessionStatisticsScreen | `/admin/analytics/sessions` | `GET .../analytics/sessions/stats` |
| 52 | PlayerAnalyticsScreen | `/admin/analytics/players` | `GET .../analytics/players` |
| 53 | SystemPerformanceScreen | `/admin/analytics/systems` | `GET .../analytics/systems/performance` |

# Tab 3 — Management
| # | Screen | Route | Backend call |
| --- | --- | --- | --- |
| 54 | AdminManagementScreen | `/admin/management` | hub (no single endpoint) |
| 55 | PricingRulesScreen | `/admin/pricing` | `GET .../pricing/rules` |
| 56 | CreatePricingRuleScreen | `/admin/pricing/create` | `POST .../pricing/rules` |
| 57 | EditPricingRuleScreen | `/admin/pricing/:id/edit` | `PATCH .../pricing/rules/:id` |
| 58 | BillingPaymentsScreen | `/admin/billing` | `GET .../billing/ledger` + `/ledger/:id`, `.../revenue/summary`, `.../payments` (+recon), `POST .../billing/:sessionId/bill`, `.../ledger/:id/override` (sheets: billing detail/override, payment detail, adjust credits) |
| 59 | CampaignManagementScreen | `/admin/campaigns` | `GET .../campaigns` (pause/resume) |
| 60 | CreateCampaignScreen | `/admin/campaigns/create` | `POST .../campaigns` |
| 61 | EditCampaignScreen | `/admin/campaigns/:id/edit` | `PATCH .../campaigns/:id` |
| 62 | CreditsManagementScreen | `/admin/credits` | `GET .../credits/balance/:userId`, `.../transactions/:userId`, `POST .../credits/adjust` |
| 63 | DisputeResolutionScreen | `/admin/disputes` | `GET .../disputes` |
| 64 | AdminDisputeDetailScreen | `/admin/disputes/:id` | `GET .../disputes/admin/:id`, `POST .../:id/review`, `.../:id/resolve` |

# Tab 4 — Store
| # | Screen | Route | Backend call |
| --- | --- | --- | --- |
| 65 | AdminStoreScreen | `/admin/systems` | store-area hub (distinct from `/admin/management`) |
| 66 | SystemManagementScreen | `/admin/systems/list` | `GET .../systems`, `.../systems/live` |
| 67 | AddEditSystemScreen | `/admin/systems/add`, `/admin/systems/edit/:id` | `POST` / `PATCH .../systems` |
| 68 | SystemDetailScreen | `/admin/systems/:id` | `GET .../systems/:id`, `POST .../:id/regenerate-key` (sheet) |
| 69 | StaffManagementScreen | `/admin/staff` | `GET .../admins` (edit-staff sheet) |
| 70 | InviteStaffScreen | `/admin/staff/invite` | `POST .../admins` |
| 71 | StoreConfigScreen | `/admin/config` | `GET` / `PATCH .../stores/:id/config` |
| 72 | AdminNotificationsScreen | `/admin/notifications` | `POST .../notifications/admin/send`, `.../admin/send/topic` |

# Notes
Mutations go through `*_command_notifier`s that expose `admin_command_state` (idle/loading/success/error)
so sheets/buttons reflect progress. Detail drill-downs use read-only sheets (billing/payment/dispute).
Parity fixes WP1–WP3 wired notify-send, billing override/detail, booking/dispute detail, system-key
regen, payment detail, and end-session→bill. See [Admin Operations flow](../flows/admin-operations.md) and
[Admin Live Monitoring](../flows/admin-live-monitoring.md).
</content>
