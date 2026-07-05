---
type: Module
title: Home (Discovery)
description: Store discovery + search + detail, and the active-store selection that scopes all player calls.
resource: file://lib/features/home
tags: [home, discovery, stores, active-store]
timestamp: 2026-07-04
---

# Responsibilities
Browse/search stores, view a store, and hold the **active store** (persisted selection that supplies
`:storeId` to every store-scoped call). Notifiers: `home_notifier`, `store_search_notifier`,
`store_detail_notifier`, `active_store_notifier`. Repository: `store_repository.dart`. Backend: [stores](../references/backend-brain-link.md).

# Screens

| # | Screen | Route | Backend call | Notes |
| --- | --- | --- | --- | --- |
| 12 | HomeScreen | `/home` (tab) | `GET /stores` | Store list; entry to discovery. |
| 13 | StoreSearchScreen | `/home/search` | `GET /stores?search=&platform=` | Filtered search. |
| 14 | StoreDetailScreen | `/home/store/:slug` | `GET /stores/:slug`, `GET /stores/:storeId/campaigns/active`, `GET /stores/:storeId/systems/available` | Selecting a store sets the active store → enables booking. |

# Active store
`active_store_notifier` persists the chosen store; `store_selector_sheet.dart` switches it. Nearly all
player features read it to build `/stores/:storeId/...` paths ([Backend Contract](../systems/backend-contract.md)).
See [Discover → Book → Pay flow](../flows/discover-book-pay.md).
</content>
