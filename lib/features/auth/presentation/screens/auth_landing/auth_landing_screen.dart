import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../application/oauth_signup_notifier.dart';
import '../../../application/social_login_notifier.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_logo.dart';

class AuthLandingScreen extends ConsumerStatefulWidget {
  const AuthLandingScreen({super.key});

  @override
  ConsumerState<AuthLandingScreen> createState() => _AuthLandingScreenState();
}

class _AuthLandingScreenState extends ConsumerState<AuthLandingScreen> {
  DateTime? _lastBackPress;

  void _onPop(bool didPop, Object? result) {
    if (didPop) return;
    final now = DateTime.now();
    if (_lastBackPress == null ||
        now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
      _lastBackPress = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      SystemNavigator.pop();
    }
  }

  Future<void> _handleNeedsSignup(SocialLoginNeedsSignup state) async {
    final newUser = state.newUser;
    final email = newUser.prefill.email;
    final providerLabel = newUser.provider == 'discord' ? 'Discord' : 'Google';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Create an account?'),
        content: Text(
          email != null && email.isNotEmpty
              ? "We couldn't find an account for $email. "
                  'Do you want to sign up with $providerLabel?'
              : 'No account found for this $providerLabel login. '
                  'Do you want to sign up?',
          style: AppTypography.bodyR,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sign up'),
          ),
        ],
      ),
    );

    // Reset so re-tapping a provider works again.
    ref.read(socialLoginNotifierProvider.notifier).reset();

    if (confirmed == true && mounted) {
      // Hold the handoff in a provider — GoRouter drops `extra` on refresh.
      ref.read(pendingOAuthSignupProvider.notifier).state = newUser;
      context.push(AppRoutes.oauthSignupDetails, extra: newUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SocialLoginState>(socialLoginNotifierProvider, (previous, next) {
      if (!mounted) return;
      switch (next) {
        case SocialLoginSuccess():
          context.go(AppRoutes.home);
        case SocialLoginNeedsSignup():
          _handleNeedsSignup(next);
        case SocialLoginError(:final error):
          showErrorSnackbar(context, error);
          ref.read(socialLoginNotifierProvider.notifier).reset();
        case SocialLoginInitial():
        case SocialLoginLoading():
          break;
      }
    });

    final socialState = ref.watch(socialLoginNotifierProvider);
    final loadingProvider = socialState is SocialLoginLoading
        ? socialState.provider
        : null;
    final busy = loadingProvider != null;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPop,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: GzLogo()),
                const Spacer(),
                Text('Welcome back', style: AppTypography.h1),
                const SizedBox(height: 8),
                Text('Sign in to continue', style: AppTypography.bodyR),
                const SizedBox(height: 24),
                GzButton(
                  label: 'Continue with Google',
                  variant: GzButtonVariant.ghost,
                  loading: loadingProvider == 'google',
                  icon: const _CircleTextIcon(
                    label: 'G',
                    background: AppColors.surface,
                  ),
                  onPressed: busy
                      ? null
                      : () => ref
                            .read(socialLoginNotifierProvider.notifier)
                            .continueWithGoogle(),
                ),
                const SizedBox(height: 12),
                GzButton(
                  label: 'Continue with Discord',
                  variant: GzButtonVariant.ghost,
                  loading: loadingProvider == 'discord',
                  icon: const _CircleTextIcon(
                    label: 'D',
                    background: Color(0xFF5865F2),
                    foreground: Colors.white,
                  ),
                  onPressed: busy
                      ? null
                      : () => ref
                            .read(socialLoginNotifierProvider.notifier)
                            .continueWithDiscord(),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.rule)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or', style: AppTypography.small),
                    ),
                    const Expanded(child: Divider(color: AppColors.rule)),
                  ],
                ),
                const SizedBox(height: 18),
                GzButton(
                  label: 'Continue with email',
                  variant: GzButtonVariant.ghost,
                  onPressed: busy
                      ? null
                      : () => context.push(AppRoutes.emailLogin),
                ),
                const Spacer(),
                TextButton(
                  onPressed: busy
                      ? null
                      : () => context.push(AppRoutes.register),
                  child: Text(
                    'New here? Create account →',
                    style: AppTypography.body.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: busy
                      ? null
                      : () => context.push(AppRoutes.adminLogin),
                  child: Text(
                    'Admin? Sign in →',
                    style: AppTypography.small.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleTextIcon extends StatelessWidget {
  const _CircleTextIcon({
    required this.label,
    required this.background,
    this.foreground = AppColors.textPrimary,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.rule),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: AppTypography.small.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
