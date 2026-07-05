# Registry: Admin Management Feature
> IMPLEMENTED — Phase 11 live admin money wiring is in place for pricing, billing, payments summary, and credits adjustments.

## Reality Check
The admin management money slice now has a real repository layer, Riverpod application state, and presentation wiring:
- `lib/features/admin/data/repositories/pricing_repository.dart`
- `lib/features/admin/data/repositories/admin_billing_repository.dart`
- `lib/features/admin/data/repositories/payments_repository.dart`
- `lib/features/admin/data/repositories/admin_credits_repository.dart`
- `lib/features/admin/application/admin_pricing_notifier.dart`
- `lib/features/admin/application/pricing_rule_command_notifier.dart`
- `lib/features/admin/application/admin_billing_notifier.dart`
- `lib/features/admin/application/admin_billing_detail_notifier.dart`
- `lib/features/admin/application/billing_override_notifier.dart`
- `lib/features/admin/application/admin_credits_notifier.dart`
- `lib/features/admin/application/admin_credits_command_notifier.dart`
- `lib/features/admin/application/admin_payment_detail_notifier.dart`
- `lib/features/admin/presentation/screens/management/pricing_rules_screen.dart`
- `lib/features/admin/presentation/screens/management/create_pricing_rule_screen.dart`
- `lib/features/admin/presentation/screens/management/edit_pricing_rule_screen.dart`
- `lib/features/admin/presentation/screens/management/billing_payments_screen.dart`
- `lib/features/admin/presentation/screens/management/billing_detail_sheet.dart`
- `lib/features/admin/presentation/screens/management/billing_override_sheet.dart`
- `lib/features/admin/presentation/screens/management/payment_detail_sheet.dart`
- `lib/features/admin/presentation/screens/management/credits_management_screen.dart`
- `lib/features/admin/presentation/screens/management/adjust_credits_sheet.dart`

## Files
| File | Purpose | Implemented? |
|---|---|---|
| `lib/features/admin/data/repositories/pricing_repository.dart` | Pricing rules list/create/update/delete transport | Yes |
| `lib/features/admin/data/repositories/admin_billing_repository.dart` | Billing ledger + revenue summary + override action | Yes |
| `lib/features/admin/data/repositories/payments_repository.dart` | Payments list + reconciliation + refund transport | Yes |
| `lib/features/admin/data/repositories/admin_credits_repository.dart` | Credits balance/transactions lookup + adjustment transport | Yes |
| `lib/features/admin/application/admin_pricing_notifier.dart` | Pricing rules + system types read state | Yes |
| `lib/features/admin/application/pricing_rule_command_notifier.dart` | Pricing create/update/delete actions | Yes |
| `lib/features/admin/application/admin_billing_notifier.dart` | Billing ledger + payments summary read state | Yes |
| `lib/features/admin/application/admin_billing_detail_notifier.dart` | Billing ledger row detail read state | Yes |
| `lib/features/admin/application/billing_override_notifier.dart` | Billing override action state | Yes |
| `lib/features/admin/application/admin_credits_notifier.dart` | Credits account lookup read state | Yes |
| `lib/features/admin/application/admin_credits_command_notifier.dart` | Credits adjustment action state | Yes |
| `lib/features/admin/application/admin_payment_detail_notifier.dart` | Payment detail read state | Yes |

## Screens
| Screen | Route | Status |
|---|---|---|
| Phase 11 Pricing Rules | `/admin/pricing` | Live API-backed list with system-type metadata |
| Phase 11 Create Pricing Rule | `/admin/pricing/create` | Live submit wiring |
| Phase 11 Edit Pricing Rule | `/admin/pricing/:id/edit` | Live update/delete wiring |
| Phase 11 Billing & Payments | `/admin/billing` | Live ledger + revenue/reconciliation summary |
| Phase 11 Billing Detail | modal from `/admin/billing` | Live ledger row drill-down with override history |
| Phase 11 Billing Override | modal from `/admin/billing` | Live override submit wiring |
| Phase 11 Payment Detail | modal from `/admin/billing` | Live payment drill-down including gateway payload |
| Phase 11 Credits | `/admin/credits` | Live user-id lookup + adjustment wiring |
| Phase 11 Adjust Credits | modal from `/admin/credits` | Live add/deduct submit wiring |

## Endpoints In Use
- `GET /stores/:storeId/pricing/rules`
- `POST /stores/:storeId/pricing/rules`
- `PATCH /stores/:storeId/pricing/rules/:id`
- `DELETE /stores/:storeId/pricing/rules/:id`
- `GET /stores/:storeId/billing/ledger`
- `GET /stores/:storeId/billing/ledger/:id`
- `POST /stores/:storeId/billing/:sessionId/bill`
- `GET /stores/:storeId/billing/revenue/summary`
- `POST /stores/:storeId/billing/ledger/:id/override`
- `GET /stores/:storeId/payments`
- `GET /stores/:storeId/payments/:id`
- `GET /stores/:storeId/payments/reconciliation`
- `GET /stores/:storeId/credits/balance/:userId`
- `GET /stores/:storeId/credits/transactions/:userId`
- `POST /stores/:storeId/credits/adjust`

## Notes
- The old inline mock pricing rules, billing rows, and credits transactions were removed from the touched Phase 11 screens.
- WP1 parity fix corrected billing override to the backend `ledger/:id/override` route; existing billing screens and sheets were reused unchanged.
- WP1 parity fix also corrected admin dispute detail fetching to the admin-auth `/disputes/admin/:id` route for the existing dispute management flow.
- `BillingPaymentsScreen` currently renders player/system identifiers directly from the billing ledger model because Phase 11 backend docs in `brain/API_INTEGRATION_PLAN.md` do not define richer joined display fields; this mismatch is tracked in `brain/phases/PHASE_11_ADMIN_MONEY_INCONSISTENCIES.md`.
- `CreditsManagementScreen` is wired against the documented credits endpoints and therefore requires a direct `userId` lookup. A search-by-name/phone/email endpoint is still missing from the Phase 11 contract and is also tracked in the inconsistency log.
- WP3 parity fix added dedicated billing/payment detail sheets because no shared widget already covered read-only admin financial drill-downs with loading/error/data states. The existing billing list card, `GzMetaRow`, `PageErrorDisplay`, and modal shell patterns were reused instead of adding a new full screen.
