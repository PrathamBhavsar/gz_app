class AppRoutes {
  AppRoutes._();

  // Auth Stack
  static const splash                   = '/';
  static const onboarding               = '/onboarding';
  static const authLanding              = '/auth';
  static const register                 = '/auth/register';
  static const otpVerification          = '/auth/otp';
  static const emailLogin               = '/auth/email-login';
  static const oauthSignupDetails       = '/auth/oauth/signup';
  static const forgotPassword           = '/auth/forgot-password';
  static const resetPassword            = '/auth/reset-password';
  static const emailVerificationPending = '/auth/email-verification-pending';
  static const emailVerified            = '/auth/email-verified';

  // Main App (Authenticated)
  static const home        = '/home';
  static const storeSearch = '/home/search';
  static const storeDetail = '/home/store/:slug';

  static const book             = '/book';
  static const bookAvailability = '/book/availability';
  static const bookSummary      = '/book/summary';
  static const bookSuccess      = '/book/success';

  static const sessions       = '/sessions';
  static const activeSession  = '/sessions/active';  // live session detail (legacy, kept for existing references)

  // Session sub-routes (Phase 5)
  static const bookingDetail        = '/sessions/booking/:id';
  static const paymentSheet         = '/sessions/booking/:id/pay'; // implemented as modal sheet
  static const checkIn              = '/sessions/booking/:id/check-in';
  static const activeSessionDetail  = '/sessions/active/:id';
  static const sessionHistoryDetail = '/sessions/history/:id';
  static const billingHistory       = '/sessions/billing';

  static const wallet         = '/wallet';
  static const creditHistory  = '/wallet/transactions';
  static const campaigns      = '/wallet/campaigns';
  static const campaignDetail = '/wallet/campaigns/:id';

  static const profile = '/profile';

  // Profile sub-routes (Phase 7)
  static const editProfile    = '/profile/edit';
  static const changePhone    = '/profile/change-phone';
  static const notifPrefs     = '/profile/notifications';
  static const disputesList   = '/profile/disputes';
  static const disputeCreate  = '/profile/disputes/create';
  static const disputeDetail  = '/profile/disputes/:id';

  // Notifications (full-screen push)
  static const notifications = '/notifications';

  // ── Path builders (interpolate :param placeholders) ──
  static String storeDetailPath(String slug) => '/home/store/$slug';
  static String bookingDetailPath(String id) => '/sessions/booking/$id';
  static String paymentSheetPath(String id) => '/sessions/booking/$id/pay';
  static String checkInPath(String id) => '/sessions/booking/$id/check-in';
  static String activeSessionDetailPath(String id) => '/sessions/active/$id';
  static String sessionHistoryDetailPath(String id) => '/sessions/history/$id';
  static String campaignDetailPath(String id) => '/wallet/campaigns/$id';
  static String disputeDetailPath(String id) => '/profile/disputes/$id';

  // Admin Auth Stack
  static const adminLogin         = '/auth/admin-login';
  static const adminPasswordReset = '/auth/admin-password-reset';

  // Admin App (Authenticated)
  static const adminDashboard    = '/admin/dashboard';
  static const adminSessions     = '/admin/sessions';
  static const adminSystemSessions = '/admin/systems/:id/sessions';
  static const adminSessionDetail  = '/admin/sessions/:id';
  static const adminWalkIn       = '/admin/walk-in';
  static const adminBookings     = '/admin/bookings';
  static const adminAnalytics    = '/admin/analytics';
  static const adminRevenue      = '/admin/analytics/revenue';
  static const adminUtilization  = '/admin/analytics/utilization';
  static const adminSessionStats = '/admin/analytics/sessions';
  static const adminPlayers      = '/admin/analytics/players';
  static const adminSystems      = '/admin/analytics/systems';
  static const adminPricing      = '/admin/pricing';
  static const adminBilling      = '/admin/billing';
  static const adminCampaigns    = '/admin/campaigns';
  static const adminCredits      = '/admin/credits';
  static const adminDisputes     = '/admin/disputes';
  static const adminSystemsMgmt   = '/admin/systems';
  static const adminManagement    = '/admin/management';
  static const adminStaff         = '/admin/staff';
  static const adminConfig        = '/admin/config';
  static const adminNotifications = '/admin/notifications';

  // Admin CRUD sub-routes
  static const adminBookingDetail  = '/admin/bookings/:id';
  static const adminDisputeDetail  = '/admin/disputes/:id';
  static const adminCreateCampaign = '/admin/campaigns/create';
  static const adminEditCampaign   = '/admin/campaigns/:id/edit';
  static const adminCreatePricing  = '/admin/pricing/create';
  static const adminEditPricing    = '/admin/pricing/:id/edit';
  static const adminInviteStaff    = '/admin/staff/invite';
  static const adminSystemsList    = '/admin/systems/list';
  static const adminAddSystem      = '/admin/systems/add';
  static const adminEditSystem     = '/admin/systems/edit/:id';
  static const adminSystemDetail   = '/admin/systems/:id';

  // Session logs
  static const sessionLogs = '/sessions/logs/:id';

  // ── Path builders ──
  static String adminBookingDetailPath(String id)  => '/admin/bookings/$id';
  static String adminDisputeDetailPath(String id)  => '/admin/disputes/$id';
  static String adminEditCampaignPath(String id)   => '/admin/campaigns/$id/edit';
  static String adminEditPricingPath(String id)    => '/admin/pricing/$id/edit';
  static String adminSystemDetailPath(String id)   => '/admin/systems/$id';
  static String adminAddSystemPath()               => '/admin/systems/add';
  static String adminEditSystemPath(String id)     => '/admin/systems/edit/$id';
  static String sessionLogsPath(String id)         => '/sessions/logs/$id';
  static String adminSystemSessionsPath(String id) => '/admin/systems/$id/sessions';
  static String adminSessionDetailPath(String id)  => '/admin/sessions/$id';
}
