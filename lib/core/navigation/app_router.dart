import 'dart:ui';

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes.dart';

import '../../features/auth/presentation/screens/splash/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding/onboarding_screen.dart';
import '../../features/auth/presentation/screens/auth_landing/auth_landing_screen.dart';
import '../../features/auth/presentation/screens/register/register_screen.dart';
import '../../features/auth/presentation/screens/otp/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/email_login/email_login_screen.dart';
import '../../features/auth/presentation/screens/oauth_handler/oauth_handler_screen.dart';
import '../../features/auth/presentation/screens/forgot_password/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/reset_password/reset_password_screen.dart';
import '../../features/auth/presentation/screens/email_verification_pending/email_verification_pending_screen.dart';
import '../../features/auth/presentation/screens/email_verify_success/email_verify_success_screen.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/store_search/store_search_screen.dart';
import '../../features/home/presentation/screens/store_detail/store_detail_screen.dart';
import '../../features/main_shell/presentation/screens/main_page.dart';
import '../../features/booking/presentation/screens/slot_selection/booking_slot_selection_screen.dart';
import '../../features/booking/presentation/screens/availability/booking_availability_screen.dart';
import '../../features/booking/presentation/screens/system_selection/booking_system_selection_screen.dart';
import '../../features/booking/presentation/screens/summary/booking_summary_screen.dart';
import '../../features/booking/presentation/screens/success/booking_success_screen.dart';
import '../../features/sessions/presentation/screens/sessions_screen.dart';
import '../../features/sessions/presentation/screens/active_session_screen.dart';
import '../../features/sessions/presentation/screens/booking_detail_screen.dart';
import '../../features/sessions/presentation/screens/check_in_screen.dart';
import '../../features/sessions/presentation/screens/payment_screen.dart';
import '../../features/sessions/presentation/screens/active_session_detail_screen.dart';
import '../../features/sessions/presentation/screens/session_history_detail_screen.dart';
import '../../features/sessions/presentation/screens/billing_history_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../../features/wallet/presentation/screens/credit_history_screen.dart';
import '../../features/wallet/presentation/screens/campaigns_screen.dart';
import '../../features/wallet/presentation/screens/campaign_detail_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/change_phone_screen.dart';
import '../../features/profile/presentation/screens/notif_prefs_screen.dart';
import '../../features/profile/presentation/screens/disputes_list_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/disputes/presentation/screens/create_dispute_screen.dart';
import '../../features/disputes/presentation/screens/dispute_detail_screen.dart';

// Admin screens
import '../../features/admin/presentation/screens/admin_login_screen.dart';
import '../../features/admin/presentation/screens/admin_password_reset_screen.dart';
import '../../features/admin/presentation/widgets/admin_shell.dart';
import '../../features/admin/presentation/screens/operations/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/operations/session_management_screen.dart';
import '../../features/admin/presentation/screens/operations/walk_in_booking_screen.dart';
import '../../features/admin/presentation/screens/operations/booking_management_screen.dart';
import '../../features/admin/presentation/screens/analytics/admin_analytics_screen.dart';
import '../../features/admin/presentation/screens/analytics/revenue_analytics_screen.dart';
import '../../features/admin/presentation/screens/analytics/utilization_heatmap_screen.dart';
import '../../features/admin/presentation/screens/analytics/session_statistics_screen.dart';
import '../../features/admin/presentation/screens/analytics/player_analytics_screen.dart';
import '../../features/admin/presentation/screens/analytics/system_performance_screen.dart';
import '../../features/admin/presentation/screens/management/admin_management_screen.dart';
import '../../features/admin/presentation/screens/management/pricing_rules_screen.dart';
import '../../features/admin/presentation/screens/store/staff_management_screen.dart';
import '../../features/admin/presentation/screens/store/store_config_screen.dart';
import '../../features/admin/presentation/screens/store/admin_notifications_screen.dart';
import '../../features/admin/presentation/screens/management/billing_payments_screen.dart';
import '../../features/admin/presentation/screens/management/campaign_management_screen.dart';
import '../../features/admin/presentation/screens/management/credits_management_screen.dart';
import '../../features/admin/presentation/screens/management/dispute_resolution_screen.dart';
import '../../features/admin/presentation/screens/store/admin_store_screen.dart';
import '../../features/admin/presentation/screens/store/system_management_screen.dart';
import '../../features/admin/presentation/screens/store/system_detail_screen.dart';
import '../../features/admin/presentation/screens/store/add_edit_system_screen.dart';
import '../../features/admin/presentation/screens/store/invite_staff_screen.dart';
import '../../features/admin/presentation/screens/management/admin_dispute_detail_screen.dart';
import '../../features/admin/presentation/screens/management/create_campaign_screen.dart';
import '../../features/admin/presentation/screens/management/edit_campaign_screen.dart';
import '../../features/admin/presentation/screens/management/create_pricing_rule_screen.dart';
import '../../features/admin/presentation/screens/management/edit_pricing_rule_screen.dart';
import '../../features/admin/presentation/screens/operations/admin_booking_detail_screen.dart';
import '../../features/sessions/presentation/screens/session_logs_screen.dart';

enum PendingDeepLinkOverlay { notifications }

PendingDeepLinkOverlay? _pendingDeepLinkOverlay;

PendingDeepLinkOverlay? consumePendingDeepLinkOverlay() {
  final overlay = _pendingDeepLinkOverlay;
  _pendingDeepLinkOverlay = null;
  return overlay;
}

final routerProvider = Provider<GoRouter>((_) {
  return GoRouter(
    initialLocation: _initialLocation(),
    overridePlatformDefaultLocation: true,
    redirect: (context, state) {
      return _mapDeepLinkUriToRoute(state.uri);
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.authLanding,
        builder: (context, state) => const AuthLandingScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.emailLogin,
        builder: (context, state) => const EmailLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.oauthHandler,
        builder: (context, state) => const OAuthHandlerScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.emailVerificationPending,
        builder: (context, state) => const EmailVerificationPendingScreen(),
      ),
      GoRoute(
        path: AppRoutes.emailVerified,
        builder: (context, state) => const EmailVerifySuccessScreen(),
      ),

      // Admin Auth Stack
      GoRoute(
        path: AppRoutes.adminLogin,
        builder: (context, state) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminPasswordReset,
        builder: (context, state) => const AdminPasswordResetScreen(),
      ),

      // Main App Shell
      ShellRoute(
        builder: (context, state, child) => MainPage(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.book,
            builder: (context, state) => const BookingSlotSelectionScreen(),
          ),
          GoRoute(
            path: AppRoutes.sessions,
            builder: (context, state) => const SessionsScreen(),
          ),
          GoRoute(
            path: AppRoutes.wallet,
            builder: (context, state) => const WalletScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // Routes outside the shell or overlapping logic
      GoRoute(
        path: AppRoutes.storeSearch,
        builder: (context, state) => const StoreSearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.activeSession,
        builder: (context, state) => const ActiveSessionScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookingDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return BookingDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: AppRoutes.checkIn,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CheckInScreen(id: id);
        },
      ),
      GoRoute(
        path: AppRoutes.paymentSheet,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return PaymentScreen(id: id);
        },
      ),
      GoRoute(
        path: AppRoutes.activeSessionDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ActiveSessionDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: AppRoutes.sessionHistoryDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return SessionHistoryDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: AppRoutes.billingHistory,
        builder: (context, state) => const BillingHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.creditHistory,
        builder: (context, state) => const CreditHistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.campaigns,
        builder: (context, state) => const CampaignsScreen(),
      ),
      GoRoute(
        path: AppRoutes.campaignDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CampaignDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.changePhone,
        builder: (context, state) => const ChangePhoneScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifPrefs,
        builder: (context, state) => const NotifPrefsScreen(),
      ),
      GoRoute(
        path: AppRoutes.disputesList,
        builder: (context, state) => const DisputesListScreen(),
      ),
      GoRoute(
        path: AppRoutes.disputeCreate,
        builder: (context, state) => const CreateDisputeScreen(),
      ),
      GoRoute(
        path: AppRoutes.disputeDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return DisputeDetailScreen(id: id);
        },
      ),

      // Admin App Shell
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          // Tab 1: Operations
          GoRoute(
            path: AppRoutes.adminDashboard,
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminSessions,
            builder: (context, state) {
              final systemId = state.uri.queryParameters['systemId'];
              return SessionManagementScreen(systemId: systemId);
            },
          ),
          GoRoute(
            path: AppRoutes.adminWalkIn,
            builder: (context, state) => const WalkInBookingScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminBookings,
            builder: (context, state) => const BookingManagementScreen(),
          ),
          // Tab 2: Analytics
          GoRoute(
            path: AppRoutes.adminAnalytics,
            builder: (context, state) => const AdminAnalyticsScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminRevenue,
            builder: (context, state) => const RevenueAnalyticsScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminUtilization,
            builder: (context, state) => const UtilizationHeatmapScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminSessionStats,
            builder: (context, state) => const SessionStatisticsScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminPlayers,
            builder: (context, state) => const PlayerAnalyticsScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminSystems,
            builder: (context, state) => const SystemPerformanceScreen(),
          ),
          // Tab 3: Management
          GoRoute(
            path: AppRoutes.adminManagement,
            builder: (context, state) => const AdminManagementScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminPricing,
            builder: (context, state) => const PricingRulesScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminBilling,
            builder: (context, state) => const BillingPaymentsScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminCampaigns,
            builder: (context, state) => const CampaignManagementScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminCredits,
            builder: (context, state) => const CreditsManagementScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminDisputes,
            builder: (context, state) => const DisputeResolutionScreen(),
          ),
          // Tab 4: Store
          GoRoute(
            path: AppRoutes.adminSystemsMgmt,
            builder: (context, state) => const AdminStoreScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminSystemsList,
            builder: (context, state) => const SystemManagementScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminAddSystem,
            builder: (context, state) => const AddEditSystemScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminEditSystem,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return AddEditSystemScreen(id: id);
            },
          ),
          GoRoute(
            path: AppRoutes.adminSystemDetail,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return SystemDetailScreen(id: id);
            },
          ),
          GoRoute(
            path: AppRoutes.adminStaff,
            builder: (context, state) => const StaffManagementScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminInviteStaff,
            builder: (context, state) => const InviteStaffScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminConfig,
            builder: (context, state) => const StoreConfigScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminNotifications,
            builder: (context, state) => const AdminNotificationsScreen(),
          ),
          // Admin CRUD sub-routes (all tabs)
          GoRoute(
            path: AppRoutes.adminBookingDetail,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return AdminBookingDetailScreen(id: id);
            },
          ),
          GoRoute(
            path: AppRoutes.adminDisputeDetail,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return AdminDisputeDetailScreen(id: id);
            },
          ),
          GoRoute(
            path: AppRoutes.adminCreateCampaign,
            builder: (context, state) => const CreateCampaignScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminEditCampaign,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return EditCampaignScreen(id: id);
            },
          ),
          GoRoute(
            path: AppRoutes.adminCreatePricing,
            builder: (context, state) => const CreatePricingRuleScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminEditPricing,
            builder: (context, state) {
              final id = state.pathParameters['id'] ?? '';
              return EditPricingRuleScreen(id: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.storeDetail,
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return StoreDetailScreen(slug: slug);
        },
      ),
      GoRoute(
        path: AppRoutes.bookAvailability,
        builder: (context, state) => const BookingAvailabilityScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookSystems,
        builder: (context, state) => const BookingSystemSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookSummary,
        builder: (context, state) => const BookingSummaryScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookSuccess,
        builder: (context, state) => const BookingSuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.sessionLogs,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return SessionLogsScreen(sessionId: id);
        },
      ),
    ],
  );
});

String _initialLocation() {
  final defaultRouteName = PlatformDispatcher.instance.defaultRouteName;
  final initialUri = Uri.tryParse(defaultRouteName);
  return _mapDeepLinkUriToRoute(initialUri) ?? AppRoutes.splash;
}

String? _mapDeepLinkUriToRoute(Uri? uri) {
  if (uri == null || uri.scheme != 'gzapp') {
    return null;
  }

  switch (uri.host) {
    case 'bookings':
      if (uri.pathSegments.isNotEmpty) {
        return AppRoutes.bookingDetailPath(uri.pathSegments.first);
      }
    case 'stores':
      if (uri.pathSegments.isNotEmpty) {
        return AppRoutes.storeDetailPath(uri.pathSegments.first);
      }
    case 'notifications':
      _pendingDeepLinkOverlay = PendingDeepLinkOverlay.notifications;
      return AppRoutes.home;
    case 'reset-password':
      final token = uri.queryParameters['token'];
      return Uri(
        path: AppRoutes.resetPassword,
        queryParameters: token == null ? null : {'token': token},
      ).toString();
  }

  return null;
}
