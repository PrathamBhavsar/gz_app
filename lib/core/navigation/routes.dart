class AppRoutes {
  AppRoutes._();

  // Auth Stack
  static const splash                   = '/';
  static const onboarding               = '/onboarding';
  static const authLanding              = '/auth';
  static const register                 = '/auth/register';
  static const otpVerification          = '/auth/otp';
  static const emailLogin               = '/auth/email-login';
  static const oauthHandler             = '/auth/oauth-handler';
  static const forgotPassword           = '/auth/forgot-password';
  static const resetPassword            = '/auth/reset-password';
  static const emailVerificationPending = '/auth/email-verification-pending';

  // Main App (Authenticated)
  static const home        = '/home';
  static const storeSearch = '/home/search';
  static const storeDetail = '/home/store/:slug';

  static const book             = '/book';
  static const bookAvailability = '/book/availability';
  static const bookSystems      = '/book/systems';
  static const bookSummary      = '/book/summary';
  static const bookSuccess      = '/book/success';

  static const sessions       = '/sessions';
  static const activeSession  = '/sessions/active';  // live session detail (legacy, kept for existing references)

  // Session sub-routes (Phase 5)
  static const bookingDetail        = '/sessions/booking/:id';
  static const checkIn              = '/sessions/booking/:id/check-in';
  static const activeSessionDetail  = '/sessions/active/:id';
  static const sessionHistoryDetail = '/sessions/history/:id';
  static const billingHistory       = '/sessions/billing';

  static const wallet         = '/wallet';
  static const creditHistory  = '/wallet/transactions';
  static const campaigns      = '/wallet/campaigns';
  static const campaignDetail = '/wallet/campaigns/:id';

  static const profile = '/profile';

  // Notifications (full-screen push)
  static const notifications = '/notifications';

  // Disputes (player-side)
  static const disputeCreate = '/disputes/create';
  static const disputeDetail = '/disputes/:id';

  // Admin Auth Stack
  static const adminLogin         = '/auth/admin-login';
  static const adminPasswordReset = '/auth/admin-password-reset';

  // Admin App (Authenticated)
  static const adminDashboard    = '/admin/dashboard';
  static const adminSessions     = '/admin/sessions';
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
  static const adminSystemsMgmt  = '/admin/systems';
  static const adminStaff        = '/admin/staff';
  static const adminConfig       = '/admin/config';
  static const adminNotifications = '/admin/notifications';
}
