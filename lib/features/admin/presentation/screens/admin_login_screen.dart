import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../auth/application/admin_auth_notifier.dart';
import '../../../auth/data/repositories/admin_auth_repository.dart';
import '../../../auth/presentation/widgets/auth_input_field.dart';
import '../../../../core/errors/error_snackbar.dart';
import '../../../../core/navigation/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

sealed class AdminLoginState {
  const AdminLoginState();
}

class AdminLoginInitial extends AdminLoginState {
  const AdminLoginInitial();
}

class AdminLoginLoading extends AdminLoginState {
  const AdminLoginLoading();
}

class AdminLoginSuccess extends AdminLoginState {
  const AdminLoginSuccess();
}

class AdminLoginError extends AdminLoginState {
  const AdminLoginError(this.error);

  final Object error;
}

class AdminLoginNotifier extends Notifier<AdminLoginState> {
  @override
  AdminLoginState build() => const AdminLoginInitial();

  Future<void> submit({required String email, required String password}) async {
    state = const AdminLoginLoading();
    try {
      final session = await ref
          .read(adminAuthRepositoryProvider)
          .login(email: email, password: password);
      await ref
          .read(adminAuthNotifierProvider.notifier)
          .setAuthenticated(session);
      state = const AdminLoginSuccess();
    } catch (error) {
      state = AdminLoginError(error);
    }
  }
}

final adminLoginNotifierProvider =
    NotifierProvider<AdminLoginNotifier, AdminLoginState>(
      AdminLoginNotifier.new,
    );

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  DateTime? _lastBackPress;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();
    await ref
        .read(adminLoginNotifierProvider.notifier)
        .submit(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

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

  @override
  Widget build(BuildContext context) {
    ref.listen<AdminLoginState>(adminLoginNotifierProvider, (previous, next) {
      if (!mounted) return;
      if (next is AdminLoginSuccess) {
        context.go(AppRoutes.adminDashboard);
      } else if (next is AdminLoginError) {
        showErrorSnackbar(context, next.error);
      }
    });

    final loginState = ref.watch(adminLoginNotifierProvider);
    final isLoading = loginState is AdminLoginLoading;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPop,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: GzTopBar(
          title: '',
          onBack: () => context.go(AppRoutes.authLanding),
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
                  AuthInputField(
                    controller: _emailController,
                    hint: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 14),
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
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(AppRoutes.adminPasswordReset),
                      child: Text(
                        'Forgot password?',
                        style: AppTypography.small.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GzButton(
                    label: 'Sign in',
                    onPressed: isLoading ? null : _signIn,
                    loading: isLoading,
                  ),
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
        ),
      ),
    );
  }
}
