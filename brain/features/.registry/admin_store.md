# Registry: Admin Store & Systems Feature
> IMPLEMENTED — Phase 10 first live wiring is in place for systems, staff, config, and admin notifications.

## Reality Check
The admin store slice now has a real data layer, Riverpod application state, and presentation wiring:
- `lib/features/admin/data/repositories/systems_admin_repository.dart`
- `lib/features/admin/data/repositories/system_types_repository.dart`
- `lib/features/admin/data/repositories/store_config_repository.dart`
- `lib/features/admin/data/repositories/store_admins_repository.dart`
- `lib/features/admin/data/repositories/admin_notify_send_repository.dart`
- `lib/features/admin/application/admin_systems_notifier.dart`
- `lib/features/admin/application/admin_system_detail_notifier.dart`
- `lib/features/admin/application/admin_system_command_notifier.dart`
- `lib/features/admin/application/admin_system_type_command_notifier.dart`
- `lib/features/admin/application/store_admins_notifier.dart`
- `lib/features/admin/application/store_admin_command_notifier.dart`
- `lib/features/admin/application/store_config_notifier.dart`
- `lib/features/admin/application/store_config_command_notifier.dart`
- `lib/features/admin/application/admin_notify_send_notifier.dart`
- `lib/features/admin/presentation/screens/store/system_management_screen.dart`
- `lib/features/admin/presentation/screens/store/system_detail_screen.dart`
- `lib/features/admin/presentation/screens/store/add_edit_system_screen.dart`
- `lib/features/admin/presentation/screens/store/staff_management_screen.dart`
- `lib/features/admin/presentation/screens/store/invite_staff_screen.dart`
- `lib/features/admin/presentation/screens/store/edit_staff_sheet.dart`
- `lib/features/admin/presentation/screens/store/store_config_screen.dart`
- `lib/features/admin/presentation/screens/store/admin_notifications_screen.dart`

## Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/admin/data/repositories/systems_admin_repository.dart` | Admin systems list/detail/create/update/delete | Yes |
| `lib/features/admin/data/repositories/system_types_repository.dart` | System types list/create/update/delete transport | Yes |
| `lib/features/admin/data/repositories/store_config_repository.dart` | Store config read/write | Yes |
| `lib/features/admin/data/repositories/store_admins_repository.dart` | Staff/admin list/create/update/deactivate | Yes |
| `lib/features/admin/data/repositories/admin_notify_send_repository.dart` | Admin broadcast send flows | Yes |
| `lib/features/admin/application/admin_systems_notifier.dart` | Systems list + type filters state | Yes |
| `lib/features/admin/application/admin_system_detail_notifier.dart` | System detail + live-status join | Yes |
| `lib/features/admin/application/admin_system_command_notifier.dart` | System create/update/delete actions | Yes |
| `lib/features/admin/application/admin_system_type_command_notifier.dart` | System type CRUD actions | Yes |
| `lib/features/admin/application/store_admins_notifier.dart` | Staff roster read state | Yes |
| `lib/features/admin/application/store_admin_command_notifier.dart` | Invite/update/remove staff actions | Yes |
| `lib/features/admin/application/store_config_notifier.dart` | Store config read state | Yes |
| `lib/features/admin/application/store_config_command_notifier.dart` | Store config save action | Yes |
| `lib/features/admin/application/admin_notify_send_notifier.dart` | Broadcast send action | Yes |

## Screens
| Screen | Route | Status |
|---|---|---|
| Phase 10 Systems List | `/admin/systems/list` | Live API-backed list/filter UI |
| Phase 10 System Detail | `/admin/systems/:id` | Live API-backed detail UI |
| Phase 10 Add/Edit System | `/admin/systems/add`, `/admin/systems/edit/:id` | Live submit/delete wiring |
| Phase 10 System Types Sheet | modal from `/admin/systems/list` | Live create/update/delete type management |
| Phase 10 Staff Management | `/admin/staff` | Live roster rendering |
| Phase 10 Invite Staff | `/admin/staff/invite` | Live invite action |
| Phase 10 Edit Staff Sheet | modal from `/admin/staff` | Live role update/remove action |
| Phase 10 Store Config | `/admin/config` | Live read/save wiring |
| Phase 10 Admin Notifications | `/admin/notifications` | Live send action |

## Endpoints In Use
- `GET /stores/:storeId/systems`
- `GET /stores/:storeId/systems/live`
- `GET /stores/:storeId/systems/:id`
- `POST /stores/:storeId/systems`
- `PATCH /stores/:storeId/systems/:id`
- `DELETE /stores/:storeId/systems/:id`
- `GET /stores/:storeId/system-types`
- `POST /stores/:storeId/system-types`
- `PATCH /stores/:storeId/system-types/:id`
- `DELETE /stores/:storeId/system-types/:id`
- `GET /stores/:id/config`
- `PATCH /stores/:id/config`
- `GET /stores/:storeId/admins`
- `POST /stores/:storeId/admins`
- `PATCH /stores/:storeId/admins/:id`
- `DELETE /stores/:storeId/admins/:id`
- `POST /notifications/admin/send`
- `POST /notifications/admin/send/topic`

## Notes
- The old inline mock systems, staff roster, config defaults, and notification send stubs were removed from the touched Phase 10 screens.
- `SystemManagementScreen` now includes a modal type-management surface backed by `adminSystemTypeCommandNotifierProvider`, so system type CRUD is no longer repo-only.
- `admin_notify_send_repository.dart` still relies on inferred push-topic names from local docs, but it now sends `topic`, `audience`, `target`, `channel`, `title`, `body`, and `message` fields together to reduce contract mismatch risk.
