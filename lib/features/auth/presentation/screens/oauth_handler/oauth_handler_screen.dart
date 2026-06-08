import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../application/oauth_login_notifier.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_logo.dart';

class OAuthHandlerScreen extends ConsumerStatefulWidget {
  const OAuthHandlerScreen({
    super.key,
    this.provider,
    this.code,
    this.stateParam,
    this.redirectUri,
  });

  final String? provider;
  final String? code;
  final String? stateParam;
  final String? redirectUri;

  @override
  ConsumerState<OAuthHandlerScreen> createState() => _OAuthHandlerScreenState();
}

class _OAuthHandlerScreenState extends ConsumerState<OAuthHandlerScreen> {
  bool _submitted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_submitted) {
      return;
    }

    if (widget.provider?.isNotEmpty == true &&
        widget.code?.isNotEmpty == true) {
      _submitted = true;
      Future.microtask(() {
        ref
            .read(oauthLoginNotifierProvider.notifier)
            .submit(
              provider: widget.provider!,
              code: widget.code!,
              stateParam: widget.stateParam,
              redirectUri: widget.redirectUri,
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<OAuthLoginState>(oauthLoginNotifierProvider, (previous, next) {
      if (!mounted) {
        return;
      }
      if (next is OAuthLoginSuccess) {
        context.go(AppRoutes.home);
      } else if (next is OAuthLoginError) {
        showErrorSnackbar(context, next.error);
        context.go(AppRoutes.authLanding);
      }
    });

    final providerLabel = switch (widget.provider) {
      'apple' => 'Apple',
      _ => 'Google',
    };
    final hasCallbackPayload =
        widget.provider?.isNotEmpty == true && widget.code?.isNotEmpty == true;
    final isLoading =
        ref.watch(oauthLoginNotifierProvider) is OAuthLoginLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const GzLogo(),
            const SizedBox(height: 24),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              hasCallbackPayload
                  ? 'Signing you in with $providerLabel...'
                  : 'Waiting for the $providerLabel OAuth callback.',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GzButton(
              label: hasCallbackPayload && !isLoading
                  ? 'Back to sign in'
                  : 'Back to sign in',
              onPressed: () => context.go(AppRoutes.authLanding),
            ),
          ],
        ),
      ),
    );
  }
}
