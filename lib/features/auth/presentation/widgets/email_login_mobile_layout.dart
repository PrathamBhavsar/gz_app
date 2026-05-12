import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/errors/app_exception.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_state.dart';

class EmailLoginMobileLayout extends ConsumerStatefulWidget {
  const EmailLoginMobileLayout({super.key});

  @override
  ConsumerState<EmailLoginMobileLayout> createState() =>
      _EmailLoginMobileLayoutState();
}

class _DebugFillButton extends StatelessWidget {
  const _DebugFillButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}

class _EmailLoginMobileLayoutState
    extends ConsumerState<EmailLoginMobileLayout> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  String? _errorMessage;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    // Listen once for auth state changes to navigate on success
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(authNotifierProvider, (previous, next) {
        if (next is AuthAuthenticated && !_navigated) {
          _navigated = true;
          context.go(AppRoutes.home);
        } else if (next is AuthError) {
          final err = next.error;
          if (mounted) {
            setState(() {
              _errorMessage = _formatError(err);
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _formatError(Object error) {
    if (error is NetworkException) return error.message;
    if (error is ApiException) return error.message;
    if (error is UnauthorizedException) return error.message;
    if (error is ValidationException) return error.message;
    final s = error.toString();
    return s.startsWith('Exception: ') ? s.substring(11) : s;
  }

  void _fillCredentials(String email) {
    _emailController.text = email;
    _passwordController.text = 'password123';
    setState(() => _errorMessage = null);
  }

  Future<void> _submit() async {
    setState(() => _errorMessage = null);

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email and password.');
      return;
    }

    await ref
        .read(authNotifierProvider.notifier)
        .loginWithEmail(email, password);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            'Welcome back,',
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text('Log in', style: AppTypography.headingLarge),
          const SizedBox(height: AppSpacing.xxl),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: AppTypography.bodyLarge,
            enabled: !isLoading,
            decoration: InputDecoration(
              labelText: 'Email Address',
              labelStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _passwordController,
            obscureText: !_passwordVisible,
            style: AppTypography.bodyLarge,
            enabled: !isLoading,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.textSecondary,
                ),
                onPressed: () =>
                    setState(() => _passwordVisible = !_passwordVisible),
              ),
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _errorMessage!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.rose),
            ),
          ],
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: isLoading
                  ? null
                  : () => context.push(AppRoutes.forgotPassword),
              child: Text(
                'Forgot Password?',
                style: AppTypography.button.copyWith(color: AppColors.rose),
              ),
            ),
          ),
          const Spacer(),
          if (kDebugMode) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Debug quick-fill',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      _DebugFillButton(
                        label: 'Admin',
                        onTap: () => _fillCredentials('admin@urban-gamer.com'),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      _DebugFillButton(
                        label: 'Staff',
                        onTap: () => _fillCredentials('staff@urban-gamer.com'),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      _DebugFillButton(
                        label: 'User',
                        onTap: () => _fillCredentials('teresa43@hotmail.com'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.background,
                      ),
                    )
                  : Text('Log in with Email', style: AppTypography.button),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
