class AppRoutes {
  AppRoutes._();

  // Auth Stack
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const authLanding = '/auth';
  static const register = '/auth/register';
  static const otpVerification = '/auth/otp';
  static const emailLogin = '/auth/email-login';
  static const oauthHandler = '/auth/oauth-handler';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword = '/auth/reset-password';
  static const emailVerificationPending = '/auth/email-verification-pending';

  // Main App (Authenticated)
  static const home = '/home';
}
