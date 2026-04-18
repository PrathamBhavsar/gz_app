import 'package:flutter/material.dart';
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

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/store_search/store_search_screen.dart';
import '../../features/home/presentation/screens/store_detail/store_detail_screen.dart';
import '../../features/main_shell/presentation/screens/main_page.dart';
import '../../features/booking/presentation/screens/slot_selection/booking_slot_selection_screen.dart';
import '../../features/booking/presentation/screens/system_selection/booking_system_selection_screen.dart';
import '../../features/booking/presentation/screens/summary/booking_summary_screen.dart';
import '../../features/booking/presentation/screens/success/booking_success_screen.dart';
import '../../features/sessions/presentation/screens/sessions_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

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
import '../../features/admin/presentation/screens/management/billing_payments_screen.dart';
import '../../features/admin/presentation/screens/management/campaign_management_screen.dart';
import '../../features/admin/presentation/screens/management/credits_management_screen.dart';
import '../../features/admin/presentation/screens/management/dispute_resolution_screen.dart';
import '../../features/admin/presentation/screens/store/admin_store_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
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
            path: AppRoutes.adminStaff,
            builder: (context, state) =>
                const _PlaceholderScreen(title: 'Staff Management'),
          ),
          GoRoute(
            path: AppRoutes.adminConfig,
            builder: (context, state) =>
                const _PlaceholderScreen(title: 'Store Config'),
          ),
          GoRoute(
            path: AppRoutes.adminNotifications,
            builder: (context, state) =>
                const _PlaceholderScreen(title: 'Notifications'),
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
    ],

    // The redirect logic will be injected here during Auth Notifier creation
    // redirect: (context, state) { ... }
  );
});

/// Placeholder screen for admin routes not yet fully implemented.
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, color: Color(0xFF888888), size: 48),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(color: Color(0xFF888888), fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming soon',
              style: TextStyle(color: Color(0xFF888888), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

/// Admin shell wrapper — wraps the AdminMobileLayout around the child route.
class AdminShell extends StatelessWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AdminMobileLayout(child: child);
  }
}
