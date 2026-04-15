import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes.dart';

import '../features/auth/presentation/screens/splash/splash_screen.dart';
import '../features/auth/presentation/screens/onboarding/onboarding_screen.dart';
import '../features/auth/presentation/screens/auth_landing/auth_landing_screen.dart';
import '../features/auth/presentation/screens/register/register_screen.dart';
import '../features/auth/presentation/screens/otp/otp_verification_screen.dart';
import '../features/auth/presentation/screens/email_login/email_login_screen.dart';
import '../features/auth/presentation/screens/oauth_handler/oauth_handler_screen.dart';
import '../features/auth/presentation/screens/forgot_password/forgot_password_screen.dart';
import '../features/auth/presentation/screens/reset_password/reset_password_screen.dart';
import '../features/auth/presentation/screens/email_verification_pending/email_verification_pending_screen.dart';

import 'routes.dart';

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
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const Scaffold(body: Center(child: Text('Home placeholder'))),
      ),
    ],
    // The redirect logic will be injected here during Auth Notifier creation
    // redirect: (context, state) { ... }
  );
});
