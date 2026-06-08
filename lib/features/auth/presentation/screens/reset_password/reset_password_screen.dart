import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../application/password_reset_notifier.dart';
import '../../widgets/auth_input_field.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_top_bar.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, this.token});

  final String? token;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (widget.token == null || widget.token!.isEmpty) {
      showErrorSnackbar(context, const FormatException('Missing reset token'));
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
        .confirmPlayerReset(
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
      if (next is PasswordResetSuccess) {
        context.go(AppRoutes.emailLogin);
      } else if (next is PasswordResetError) {
        showErrorSnackbar(context, next.error);
      }
    });

    final resetState = ref.watch(passwordResetNotifierProvider);
    final isLoading = resetState is PasswordResetLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'Reset password'),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            children: [
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
                          setState(() => _showNewPassword = !_showNewPassword);
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
                    _submit();
                  }
                },
                enabled: !isLoading,
                trailing: IconButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
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
              const Spacer(),
              GzButton(
                label: 'Set new password',
                onPressed: isLoading ? null : _submit,
                loading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
