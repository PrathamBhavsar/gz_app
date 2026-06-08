import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../auth/application/password_reset_notifier.dart';
import '../../../auth/presentation/widgets/auth_input_field.dart';
import '../../../../core/errors/error_snackbar.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

class AdminPasswordResetScreen extends ConsumerStatefulWidget {
  const AdminPasswordResetScreen({super.key, this.token});

  final String? token;

  @override
  ConsumerState<AdminPasswordResetScreen> createState() =>
      _AdminPasswordResetScreenState();
}

class _AdminPasswordResetScreenState
    extends ConsumerState<AdminPasswordResetScreen> {
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    FocusScope.of(context).unfocus();
    await ref
        .read(passwordResetNotifierProvider.notifier)
        .requestAdminReset(_emailController.text.trim());
  }

  Future<void> _submitConfirm() async {
    if (widget.token == null || widget.token!.isEmpty) {
      showErrorSnackbar(context, const FormatException('Missing reset token'));
      return;
    }

    if (_newPasswordController.text.length < 8) {
      showErrorSnackbar(
        context,
        const FormatException('Password must be at least 8 characters'),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      showErrorSnackbar(
        context,
        const FormatException('Passwords do not match'),
      );
      return;
    }

    await ref
        .read(passwordResetNotifierProvider.notifier)
        .confirmAdminReset(
          token: widget.token!,
          password: _newPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<PasswordResetState>(passwordResetNotifierProvider, (
      previous,
      next,
    ) {
      if (!mounted) return;
      if (next is PasswordResetSuccess && widget.token != null) {
        context.go(AppRoutes.adminLogin);
      } else if (next is PasswordResetError) {
        showErrorSnackbar(context, next.error);
      }
    });

    final resetState = ref.watch(passwordResetNotifierProvider);
    final isLoading = resetState is PasswordResetLoading;
    final successMessage = resetState is PasswordResetSuccess
        ? resetState.message
        : null;
    final isConfirmMode = widget.token != null && widget.token!.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(
        title: '',
        onBack: () => context.go(AppRoutes.adminLogin),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reset password', style: AppTypography.h1),
              const SizedBox(height: 4),
              Text(
                isConfirmMode
                    ? 'Set a new password for your admin account.'
                    : 'Enter your admin email and we\'ll send a reset link.',
                style: AppTypography.bodyR,
              ),
              const SizedBox(height: 24),
              if (!isConfirmMode) ...[
                AuthInputField(
                  controller: _emailController,
                  hint: 'Admin email address',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (!isLoading) {
                      _submitRequest();
                    }
                  },
                  enabled: !isLoading,
                ),
                const SizedBox(height: 20),
                GzButton(
                  label: 'Send reset link',
                  onPressed: isLoading ? null : _submitRequest,
                  loading: isLoading,
                ),
              ] else ...[
                AuthInputField(
                  controller: _newPasswordController,
                  hint: 'New password',
                  obscureText: !_showNewPassword,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  trailing: IconButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(
                              () => _showNewPassword = !_showNewPassword,
                            );
                          },
                    icon: HugeIcon(
                      icon: _showNewPassword
                          ? HugeIcons.strokeRoundedView
                          : HugeIcons.strokeRoundedViewOffSlash,
                      color: AppColors.textTertiary,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AuthInputField(
                  controller: _confirmPasswordController,
                  hint: 'Confirm password',
                  obscureText: !_showConfirmPassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (!isLoading) {
                      _submitConfirm();
                    }
                  },
                  enabled: !isLoading,
                  trailing: IconButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(
                              () =>
                                  _showConfirmPassword = !_showConfirmPassword,
                            );
                          },
                    icon: HugeIcon(
                      icon: _showConfirmPassword
                          ? HugeIcons.strokeRoundedView
                          : HugeIcons.strokeRoundedViewOffSlash,
                      color: AppColors.textTertiary,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GzButton(
                  label: 'Set new password',
                  onPressed: isLoading ? null : _submitConfirm,
                  loading: isLoading,
                ),
              ],
              if (successMessage != null && !isConfirmMode) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.okBg,
                    borderRadius: BorderRadius.circular(
                      AppSpacing.borderRadius,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HugeIcon(
                        icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                        color: AppColors.ok,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          successMessage,
                          style: AppTypography.body.copyWith(
                            color: AppColors.ok,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
