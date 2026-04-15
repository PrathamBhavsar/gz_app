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
