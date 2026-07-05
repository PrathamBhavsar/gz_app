import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../application/login_notifier.dart';
import '../../widgets/auth_input_field.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';

class EmailLoginScreen extends ConsumerStatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  ConsumerState<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends ConsumerState<EmailLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  static const _playerCredentials = [
    _CredentialShortcut('Teresa', 'teresa43@hotmail.com', 'password123'),
    _CredentialShortcut('Iris', 'iris8@hotmail.com', 'password123'),
    _CredentialShortcut('Joan', 'joan_ankunding80@yahoo.com', 'password123'),
    _CredentialShortcut('Gerardo', 'gerardo.weissnat@yahoo.com', 'password123'),
    _CredentialShortcut('Zakary', 'zakary66@yahoo.com', 'password123'),
    _CredentialShortcut('Ian', 'ian.watsica@yahoo.com', 'password123'),
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();
    await ref
        .read(loginNotifierProvider.notifier)
        .submit(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  void _fillCredential(_CredentialShortcut credential) {
    setState(() {
      _emailController.text = credential.email;
      _passwordController.text = credential.password;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginNotifierProvider, (previous, next) {
      if (!mounted) return;
      if (next is LoginSuccess) {
        context.go(AppRoutes.home);
      } else if (next is LoginError) {
        final error = next.error;
        if (error is ValidationException &&
            error.message.contains('verify your email')) {
          context.go(
            Uri(
              path: AppRoutes.emailVerificationPending,
              queryParameters: {'email': _emailController.text.trim()},
            ).toString(),
          );
          return;
        }
        showErrorSnackbar(context, next.error);
      }
    });

    final loginState = ref.watch(loginNotifierProvider);
    final isLoading = loginState is LoginLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'Email login'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthInputField(
                  controller: _emailController,
                  hint: 'Email address',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                ),
                const SizedBox(height: 16),
                AuthInputField(
                  controller: _passwordController,
                  hint: 'Password',
                  obscureText: !_showPassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (!isLoading) {
                      _signIn();
                    }
                  },
                  enabled: !isLoading,
                  trailing: IconButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() => _showPassword = !_showPassword);
                          },
                    icon: HugeIcon(
                      icon: _showPassword
                          ? HugeIcons.strokeRoundedView
                          : HugeIcons.strokeRoundedViewOffSlash,
                      color: AppColors.textTertiary,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _CredentialShortcutWrap(
                  credentials: _playerCredentials,
                  enabled: !isLoading,
                  onSelected: _fillCredential,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: Text(
                      'Forgot password?',
                      style: AppTypography.small.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GzButton(
                  label: 'Sign in',
                  onPressed: isLoading ? null : _signIn,
                  loading: isLoading,
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        context.pushReplacement(AppRoutes.register),
                    child: Text(
                      'Don\'t have an account? Register →',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textPrimary,
                      ),
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

class _CredentialShortcut {
  const _CredentialShortcut(this.label, this.email, this.password);

  final String label;
  final String email;
  final String password;
}

class _CredentialShortcutWrap extends StatelessWidget {
  const _CredentialShortcutWrap({
    required this.credentials,
    required this.enabled,
    required this.onSelected,
  });

  final List<_CredentialShortcut> credentials;
  final bool enabled;
  final ValueChanged<_CredentialShortcut> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final credential in credentials)
          ActionChip(
            label: Text(credential.label),
            onPressed: enabled ? () => onSelected(credential) : null,
            labelStyle: AppTypography.small.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: AppColors.surface,
            disabledColor: AppColors.pillBg,
            side: const BorderSide(color: AppColors.rule),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusChip),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }
}
