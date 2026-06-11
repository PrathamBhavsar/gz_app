/// Centralized API constants — all URLs, base URLs, and endpoint paths
/// must be referenced from here. No hardcoded strings elsewhere.
class ApiConstants {
  ApiConstants._();

  // ─── Base URLs ─────────────────────────────────────────────────────
  static const String prodBaseUrl = 'https://gz.api.splin.app';
  static const String devBaseUrl = 'http://192.168.1.2:3000';

  /// Active base URL — switch between prod/dev here (or wire to env config).
  static const String baseUrl = devBaseUrl;

  // ─── Health Check ──────────────────────────────────────────────────
  static const String healthEndpoint = '/health';
  static const String healthUrl = '$devBaseUrl$healthEndpoint';

  // ─── Auth Endpoints ────────────────────────────────────────────────
  static const String authLoginEmail = '/auth/login/email';
  static const String authLoginOtp = '/auth/login/otp';
  static String authLoginOAuth(String provider) =>
      '/auth/login/oauth/$provider';
  static const String authVerifyOtp = '/auth/verify/otp';
  static const String authVerifyEmail = '/auth/verify/email';
  static const String authMe = '/auth/me';
  static const String authPasswordResetRequest = '/auth/password/reset/request';
  static const String authPasswordResetConfirm = '/auth/password/reset/confirm';
  static const String authLogout = '/auth/logout';
  static const String authRegister = '/auth/register';
  static const String authRefresh = '/auth/refresh';
  static const String authMeDevice = '/auth/me/device';
  static const String authPhoneChange = '/auth/phone/change';
  static const String authPhoneChangeVerify = '/auth/phone/change/verify';

  // ─── Admin Auth Endpoints ──────────────────────────────────────────
  static const String authAdminLogin = '/auth/admin/login';
  static const String authAdminLogout = '/auth/admin/logout';
  static const String authAdminMe = '/auth/admin/me';
  static const String authAdminPasswordResetRequest =
      '/auth/admin/password-reset/request';
  static const String authAdminPasswordResetConfirm =
      '/auth/admin/password-reset/confirm';

  // ─── Analytics Endpoints ───────────────────────────────────────────
  static const String analyticsDashboard =
      '/stores/{storeId}/analytics/dashboard';
  static const String analyticsRevenue = '/stores/{storeId}/analytics/revenue';
  static const String analyticsUtilization =
      '/stores/{storeId}/analytics/utilization';
  static const String analyticsSessionStats =
      '/stores/{storeId}/analytics/sessions/stats';
  static const String analyticsPlayers = '/stores/{storeId}/analytics/players';
  static const String analyticsSystemPerformance =
      '/stores/{storeId}/analytics/systems/performance';

  // ─── Store Admins Endpoints ────────────────────────────────────────
  static const String storeAdminsList = '/stores/{storeId}/admins';
  static const String storeAdminsCreate = '/stores/{storeId}/admins';
  static const String storeAdminsUpdate = '/stores/{storeId}/admins/{id}';
  static const String storeAdminsDeactivate = '/stores/{storeId}/admins/{id}';

  // ─── Systems Management Endpoints ──────────────────────────────────
  static const String systemsLive = '/stores/{storeId}/systems/live';
  static const String systemsList = '/stores/{storeId}/systems';
  static const String systemDetail = '/stores/{storeId}/systems/{id}';
  static const String systemsAvailable = '/stores/{storeId}/systems/available';

  // ─── Sessions Admin Endpoints ──────────────────────────────────────
  static const String sessionsList = '/stores/{storeId}/sessions';
  static const String sessionCreate = '/stores/{storeId}/sessions';
  static const String sessionsActive = '/stores/{storeId}/sessions/active';
  static const String sessionDetail = '/stores/{storeId}/sessions/{id}';
  static const String sessionPause = '/stores/{storeId}/sessions/{id}/pause';
  static const String sessionResume = '/stores/{storeId}/sessions/{id}/resume';
  static const String sessionEnd = '/stores/{storeId}/sessions/{id}/end';
  static const String sessionExtend = '/stores/{storeId}/sessions/{id}/extend';
  static const String sessionLogs = '/stores/{storeId}/sessions/{id}/logs';

  // ─── Bookings Admin Endpoints ──────────────────────────────────────
  static const String bookingsList = '/stores/{storeId}/bookings';
  static const String bookingDetail = '/stores/{storeId}/bookings/{id}';
  static const String bookingUpdate = '/stores/{storeId}/bookings/{id}';
  static const String bookingsAvailability =
      '/stores/{storeId}/bookings/availability';
  static const String bookingWalkIn = '/stores/{storeId}/bookings/walk-in';
  static const String bookingCheckIn =
      '/stores/{storeId}/bookings/{id}/check-in';
  static const String bookingCancel = '/stores/{storeId}/bookings/{id}/cancel';

  // ─── Pricing Endpoints ────────────────────────────────────────────
  static const String pricingRules = '/stores/{storeId}/pricing/rules';
  static const String pricingCalculate = '/stores/{storeId}/pricing/calculate';

  // ─── Billing Endpoints ────────────────────────────────────────────
  static const String billingLedger = '/stores/{storeId}/billing/ledger';
  static const String billingOverride =
      '/stores/{storeId}/billing/{id}/override';
  static const String billingRevenueSummary =
      '/stores/{storeId}/billing/revenue/summary';

  // ─── Payments Endpoints ───────────────────────────────────────────
  static const String paymentsList = '/stores/{storeId}/payments';
  static const String paymentsReconciliation =
      '/stores/{storeId}/payments/reconciliation';
  static const String paymentRefund = '/stores/{storeId}/payments/{id}/refund';

  // ─── Credits Admin Endpoints ──────────────────────────────────────
  static const String creditsUserBalance =
      '/stores/{storeId}/credits/balance/{userId}';
  static const String creditsUserTransactions =
      '/stores/{storeId}/credits/transactions/{userId}';
  static const String creditsAdjust = '/stores/{storeId}/credits/adjust';

  // ─── Campaigns Admin Endpoints ────────────────────────────────────
  static const String campaignsAdminList = '/stores/{storeId}/campaigns';
  static const String campaignDetail = '/stores/{storeId}/campaigns/{id}';
  static const String campaignPause = '/stores/{storeId}/campaigns/{id}/pause';
  static const String campaignResume =
      '/stores/{storeId}/campaigns/{id}/resume';
  static const String campaignRedemptions =
      '/stores/{storeId}/campaigns/{id}/redemptions';

  // ─── Disputes Admin Endpoints ─────────────────────────────────────
  static const String disputesAdminList = '/stores/{storeId}/disputes';
  static const String disputeDetail = '/stores/{storeId}/disputes/{id}';
  static const String disputeReview = '/stores/{storeId}/disputes/{id}/review';
  static const String disputeResolve =
      '/stores/{storeId}/disputes/{id}/resolve';

  // ─── Notifications Admin Endpoints ────────────────────────────────
  static const String notificationsAdminSend = '/notifications/admin/send';
  static const String notificationsAdminSendTopic =
      '/notifications/admin/send/topic';

  // ─── Store Config Endpoints ───────────────────────────────────────
  static const String storeConfig = '/stores/{id}/config';

  // ─── Public Store Discovery Endpoints ─────────────────────────────
  static const String storesList = '/stores';
  static const String storeBySlug = '/stores/{slug}';

  // ─── System Types Endpoints ───────────────────────────────────────
  static const String systemTypes = '/stores/{storeId}/system-types';
  static const String systemTypeDetail = '/stores/{storeId}/system-types/{id}';

  // ─── Player Endpoints ──────────────────────────────────────────────
  static const String sessionsMy = '/stores/{storeId}/sessions/my';
  static const String bookingsMyList = '/stores/{storeId}/bookings/my';
  static const String playerBookingDetail = '/stores/{storeId}/bookings/{id}';
  static const String playerSessionDetail = '/stores/{storeId}/sessions/{id}';
  static const String playerSessionLogs =
      '/stores/{storeId}/sessions/{id}/logs';
  static const String billingMy = '/stores/{storeId}/billing/my';
  static const String bookingPayment = '/stores/{storeId}/bookings/{id}/pay';
  static const String wsPlayerNotify = '/ws/users/{userId}/notify';

  // ─── Player Credits Endpoints ──────────────────────────────────────────────
  static const String playerCreditsBalance =
      '/stores/{storeId}/credits/balance';
  static const String playerCreditsTransactions =
      '/stores/{storeId}/credits/transactions';
  static const String playerCreditsRedeem = '/stores/{storeId}/credits/redeem';

  // ─── Player Campaigns Endpoints ────────────────────────────────────────────
  static const String playerCampaignsActive =
      '/stores/{storeId}/campaigns/active';
  static const String playerCampaignRedeem =
      '/stores/{storeId}/campaigns/{id}/redeem';

  // ─── Player Disputes Endpoints ─────────────────────────────────────────────
  static const String playerDisputesMy = '/stores/{storeId}/disputes/my';
  static const String playerDisputeDetail = '/stores/{storeId}/disputes/{id}';
  static const String playerDisputeCreate = '/stores/{storeId}/disputes';
  static const String playerDisputeWithdraw =
      '/stores/{storeId}/disputes/{id}/withdraw';

  // ─── Player Notifications Endpoints ────────────────────────────────────────
  static const String playerNotifications = '/notifications';
  static const String playerNotificationDetail = '/notifications/{id}';
  static const String playerNotificationRead = '/notifications/{id}/read';
  static const String playerNotificationsReadAll = '/notifications/read-all';
  static const String playerNotifPrefs = '/notifications/preferences';
}
