import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../providers/admin_auth_provider.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  bool _showPassword = false;

  Future<void> _signIn() async {
    await ref.read(adminAuthNotifierProvider.notifier).login(
      'operator@gamezone.com',
      'demo-password',
    );
    if (!mounted) return;
    context.go(AppRoutes.adminDashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(
        title: '',
        onBack: () => context.go(AppRoutes.authLanding),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Admin Portal', style: AppTypography.h1),
              const SizedBox(height: 4),
              Text(
                'Sign in to manage your store',
                style: AppTypography.bodyR,
              ),
              const SizedBox(height: 32),
              const _AdminField(hint: 'Email address'),
              const SizedBox(height: 14),
              _AdminField(
                hint: 'Password',
                obscureText: !_showPassword,
                trailing: IconButton(
                  onPressed: () {
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
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.adminPasswordReset),
                  child: Text(
                    'Forgot password?',
                    style: AppTypography.small.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              GzButton(label: 'Sign in', onPressed: _signIn),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Staff access · GameZone Operator',
                  style: AppTypography.small,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminField extends StatelessWidget {
  const _AdminField({
    required this.hint,
    this.trailing,
    this.obscureText = false,
  });

  final String hint;
  final Widget? trailing;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pillBg,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: TextField(
        readOnly: true,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTypography.body.copyWith(color: AppColors.textPrimary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: trailing,
        ),
      ),
    );
  }
}
