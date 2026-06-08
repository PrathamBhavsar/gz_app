# UX FLOW & SCREEN INVENTORY
> Maintain this file as routes and API ownership change.

## Player Flow
1. `SplashScreen` — `/`
   API: none directly; bootstraps auth/session resolution.
2. `OnboardingScreen` — `/onboarding`
   API: none.
3. `AuthLandingScreen` — `/auth`
   API: none yet.
4. `RegisterScreen` — `/auth/register`
   API target: `POST /auth/register`.
5. `OtpVerificationScreen` — `/auth/otp`
   API target: `POST /auth/login/otp`, `POST /auth/verify/otp`.
6. `EmailLoginScreen` — `/auth/email-login`
   API target: `POST /auth/login/email`.
7. `OAuthHandlerScreen` — `/auth/oauth-handler`
   API target: `POST /auth/login/oauth/:provider`.
8. `ForgotPasswordScreen` — `/auth/forgot-password`
   API target: `POST /auth/password/reset/request`.
9. `ResetPasswordScreen` — `/auth/reset-password`
   API target: `POST /auth/password/reset/confirm`.
10. `EmailVerificationPendingScreen` — `/auth/email-verification-pending`
    API target: verification status flow, exact transport TBD.
11. `EmailVerifySuccessScreen` — `/auth/email-verified`
    API: none.
12. `HomeScreen` — `/home`
    API target: `GET /stores`.
13. `StoreSearchScreen` — `/home/search`
    API target: `GET /stores?search=&platform=`.
14. `StoreDetailScreen` — `/home/store/:slug`
    API target: `GET /stores/:slug`, `GET /stores/:storeId/campaigns/active`, `GET /stores/:storeId/systems/available`.
15. `BookingSlotSelectionScreen` — `/book`
    API target: `GET /stores/:storeId/systems/available`.
16. `BookingAvailabilityScreen` — `/book/availability`
    API target: `GET /stores/:storeId/bookings/availability`.
17. `BookingSystemSelectionScreen` — `/book/systems`
    API target: `GET /stores/:storeId/systems/available`.
18. `BookingSummaryScreen` — `/book/summary`
    API target: `POST /stores/:storeId/bookings`.
19. `BookingSuccessScreen` — `/book/success`
    API target: `POST /stores/:storeId/bookings/:id/pay`.
20. `SessionsScreen` — `/sessions`
    API target: `GET /stores/:storeId/sessions/my`, `GET /stores/:storeId/bookings/my`.
21. `ActiveSessionScreen` — `/sessions/active`
    API target: active session bootstrap, exact flow TBD.
22. `BookingDetailScreen` — `/sessions/booking/:id`
    API target: `GET /stores/:storeId/bookings/:id`, `POST /stores/:storeId/bookings/:id/cancel`.
23. `CheckInScreen` — `/sessions/booking/:id/check-in`
    API target: `POST /stores/:storeId/bookings/:id/check-in`.
24. `PaymentScreen` — `/sessions/booking/:id/pay`
    API target: `POST /stores/:storeId/bookings/:id/pay`.
25. `ActiveSessionDetailScreen` — `/sessions/active/:id`
    API target: `GET /stores/:storeId/sessions/:id`.
26. `SessionHistoryDetailScreen` — `/sessions/history/:id`
    API target: `GET /stores/:storeId/sessions/:id`.
27. `BillingHistoryScreen` — `/sessions/billing`
    API target: `GET /stores/:storeId/billing/my`.
28. `SessionLogsScreen` — `/sessions/logs/:id`
    API target: `GET /stores/:storeId/sessions/:id/logs`.
29. `WalletScreen` — `/wallet`
    API target: `GET /stores/:storeId/credits/balance`, `GET /stores/:storeId/credits/transactions`, `GET /stores/:storeId/campaigns/active`.
30. `CreditHistoryScreen` — `/wallet/transactions`
    API target: `GET /stores/:storeId/credits/transactions`.
31. `CampaignsScreen` — `/wallet/campaigns`
    API target: `GET /stores/:storeId/campaigns/active`.
32. `CampaignDetailScreen` — `/wallet/campaigns/:id`
    API target: `POST /stores/:storeId/campaigns/:id/redeem`.
33. `NotificationsScreen` — `/notifications`
    API target: `GET /notifications`, `PATCH /notifications/:id/read`, `POST /notifications/read-all`.
34. `ProfileScreen` — `/profile`
    API target: `GET /auth/me`.
35. `EditProfileScreen` — `/profile/edit`
    API target: `PATCH /auth/me`.
36. `ChangePhoneScreen` — `/profile/change-phone`
    API target: `POST /auth/phone/change`, verify endpoint TBD.
37. `NotifPrefsScreen` — `/profile/notifications`
    API target: `GET /notifications/preferences`, `PATCH /notifications/preferences`.
38. `DisputesListScreen` — `/profile/disputes`
    API target: `GET /stores/:storeId/disputes/my`.
39. `CreateDisputeScreen` — `/profile/disputes/create`
    API target: `POST /stores/:storeId/disputes`.
40. `DisputeDetailScreen` — `/profile/disputes/:id`
    API target: `GET /stores/:storeId/disputes/:id`, `POST /stores/:storeId/disputes/:id/withdraw`.

## Admin Flow
41. `AdminLoginScreen` — `/auth/admin-login`
    API target: `POST /auth/admin/login`.
42. `AdminPasswordResetScreen` — `/auth/admin-password-reset`
    API target: admin password reset request/confirm flow.
43. `AdminDashboardScreen` — `/admin/dashboard`
    API target: `GET /stores/:storeId/analytics/dashboard`, `GET /stores/:storeId/systems/live`.
44. `SessionManagementScreen` — `/admin/sessions`
    API target: `GET /stores/:storeId/sessions`, `GET /stores/:storeId/sessions/active`.
45. `WalkInBookingScreen` — `/admin/walk-in`
    API target: `POST /stores/:storeId/bookings/walk-in`.
46. `BookingManagementScreen` — `/admin/bookings`
    API target: `GET /stores/:storeId/bookings`, `PATCH /stores/:storeId/bookings/:id`.
47. `AdminBookingDetailScreen` — `/admin/bookings/:id`
    API target: `GET /stores/:storeId/bookings/:id`.
48. `AdminAnalyticsScreen` — `/admin/analytics`
    API target: `GET /stores/:storeId/analytics/dashboard`.
49. `RevenueAnalyticsScreen` — `/admin/analytics/revenue`
    API target: `GET /stores/:storeId/analytics/revenue`.
50. `UtilizationHeatmapScreen` — `/admin/analytics/utilization`
    API target: `GET /stores/:storeId/analytics/utilization`.
51. `SessionStatisticsScreen` — `/admin/analytics/sessions`
    API target: `GET /stores/:storeId/analytics/sessions/stats`.
52. `PlayerAnalyticsScreen` — `/admin/analytics/players`
    API target: `GET /stores/:storeId/analytics/players`.
53. `SystemPerformanceScreen` — `/admin/analytics/systems`
    API target: `GET /stores/:storeId/analytics/systems/performance`.
54. `AdminManagementScreen` — `/admin/management`
    API target: aggregate management hub, no single endpoint.
55. `PricingRulesScreen` — `/admin/pricing`
    API target: `GET /stores/:storeId/pricing/rules`.
56. `CreatePricingRuleScreen` — `/admin/pricing/create`
    API target: `POST /stores/:storeId/pricing/rules`.
57. `EditPricingRuleScreen` — `/admin/pricing/:id/edit`
    API target: `PATCH /stores/:storeId/pricing/rules/:id`.
58. `BillingPaymentsScreen` — `/admin/billing`
    API target: billing ledger, revenue summary, payments, reconciliation endpoints.
59. `CampaignManagementScreen` — `/admin/campaigns`
    API target: `GET /stores/:storeId/campaigns`.
60. `CreateCampaignScreen` — `/admin/campaigns/create`
    API target: `POST /stores/:storeId/campaigns`.
61. `EditCampaignScreen` — `/admin/campaigns/:id/edit`
    API target: `PATCH /stores/:storeId/campaigns/:id`.
62. `CreditsManagementScreen` — `/admin/credits`
    API target: balance, transaction history, and `POST /stores/:storeId/credits/adjust`.
63. `DisputeResolutionScreen` — `/admin/disputes`
    API target: `GET /stores/:storeId/disputes`.
64. `AdminDisputeDetailScreen` — `/admin/disputes/:id`
    API target: `GET /stores/:storeId/disputes/:id`, review and resolve actions.
65. `AdminStoreScreen` — `/admin/management` and related store-area navigation
    API target: store management hub.
66. `SystemManagementScreen` — `/admin/systems`
    API target: `GET /stores/:storeId/systems`, `GET /stores/:storeId/systems/live`.
67. `AddEditSystemScreen` — `/admin/systems/add`, `/admin/systems/edit/:id`
    API target: `POST/PATCH /stores/:storeId/systems`.
68. `SystemDetailScreen` — `/admin/systems/:id`
    API target: `GET /stores/:storeId/systems/:id`.
69. `StaffManagementScreen` — `/admin/staff`
    API target: `GET /stores/:storeId/admins`.
70. `InviteStaffScreen` — `/admin/staff/invite`
    API target: `POST /stores/:storeId/admins`.
71. `StoreConfigScreen` — `/admin/config`
    API target: `GET/PATCH /stores/:id/config`.
72. `AdminNotificationsScreen` — `/admin/notifications`
    API target: `POST /notifications/admin/send`, `POST /notifications/admin/send/topic`.
