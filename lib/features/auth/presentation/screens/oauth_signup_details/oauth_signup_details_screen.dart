import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../application/oauth_signup_notifier.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../widgets/auth_input_field.dart';
import '../../../../../shared/widgets/gz_button.dart';

/// Phase 2 of social login: the user confirmed they want an account, so we
/// collect the remaining details and complete signup with the signup token.
class OAuthSignupDetailsScreen extends ConsumerStatefulWidget {
  const OAuthSignupDetailsScreen({super.key, required this.newUser});

  final OAuthNewUser? newUser;

  @override
  ConsumerState<OAuthSignupDetailsScreen> createState() =>
      _OAuthSignupDetailsScreenState();
}

class _OAuthSignupDetailsScreenState
    extends ConsumerState<OAuthSignupDetailsScreen> {
  late final TextEditingController _nameController;
  final TextEditingController _phoneController = TextEditingController();
  bool _acceptedTerms = false;

  @override
  void initState() {
    super.initState();
    final newUser = ref.read(pendingOAuthSignupProvider) ?? widget.newUser;
    _nameController = TextEditingController(text: newUser?.prefill.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    final newUser = ref.read(pendingOAuthSignupProvider) ?? widget.newUser;
    if (newUser == null) return;
    final name = _nameController.text.trim();
    if (name.length < 2) {
      showErrorSnackbar(context, 'Please enter your name.');
      return;
    }
    final phone = _phoneController.text.trim();
    ref.read(oauthSignupNotifierProvider.notifier).submit(
          signupToken: newUser.signupToken,
          name: name,
          phone: phone.isEmpty ? null : phone,
        );
  }

  @override
  Widget build(BuildContext context) {
    // Prefer the provider (survives GoRouter rebuilds) over `extra`.
    final newUser = ref.watch(pendingOAuthSignupProvider) ?? widget.newUser;
    if (newUser == null) {
      // Reached without a signup token (e.g. stale deep link) — bail out.
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sign-up session expired', style: AppTypography.h2),
                const SizedBox(height: 12),
                Text(
                  'Please start again from the sign-in screen.',
                  style: AppTypography.bodyR,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GzButton(
                  label: 'Back to sign in',
                  onPressed: () => context.go(AppRoutes.authLanding),
                ),
              ],
            ),
          ),
        ),
      );
    }

    ref.listen<OAuthSignupState>(oauthSignupNotifierProvider, (previous, next) {
      if (!mounted) return;
      if (next is OAuthSignupSuccess) {
        context.go(AppRoutes.home);
      } else if (next is OAuthSignupError) {
        showErrorSnackbar(context, next.error);
        ref.read(oauthSignupNotifierProvider.notifier).reset();
      }
    });

    final isLoading =
        ref.watch(oauthSignupNotifierProvider) is OAuthSignupLoading;
    final email = newUser.prefill.email;
    final providerLabel = newUser.provider == 'discord' ? 'Discord' : 'Google';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Finish signing up'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Connected with $providerLabel',
                style: AppTypography.bodyR.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              if (email != null && email.isNotEmpty) ...[
                Text('Email', style: AppTypography.small),
                const SizedBox(height: 6),
                AuthInputField(
                  controller: TextEditingController(text: email),
                  hint: 'Email',
                  enabled: false,
                ),
                const SizedBox(height: 16),
              ],
              Text('Name', style: AppTypography.small),
              const SizedBox(height: 6),
              AuthInputField(
                controller: _nameController,
                hint: 'Your name',
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              Text('Phone (optional)', style: AppTypography.small),
              const SizedBox(height: 6),
              AuthInputField(
                controller: _phoneController,
                hint: '+15551234567',
                enabled: !isLoading,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _acceptedTerms,
                    onChanged: isLoading
                        ? null
                        : (v) => setState(() => _acceptedTerms = v ?? false),
                  ),
                  Expanded(
                    child: Text(
                      'I agree to the Terms of Service and Privacy Policy.',
                      style: AppTypography.small,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GzButton(
                label: 'Create account',
                loading: isLoading,
                onPressed: (_acceptedTerms && !isLoading) ? _submit : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
