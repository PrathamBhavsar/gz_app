import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../application/register_notifier.dart';
import '../../widgets/auth_input_field.dart';
import '../../../../../shared/widgets/gz_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
    if (_nameController.text.trim().length < 2) {
      showErrorSnackbar(
        context,
        const FormatException('Full name must be at least 2 characters'),
      );
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      showErrorSnackbar(context, const FormatException('Email is required'));
      return;
    }
    if (_passwordController.text.length < 8) {
      showErrorSnackbar(
        context,
        const FormatException('Password must be at least 8 characters'),
      );
      return;
    }
    await ref
        .read(registerNotifierProvider.notifier)
        .submit(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RegisterState>(registerNotifierProvider, (previous, next) {
      if (!mounted) return;
      if (next is RegisterSuccess) {
        final result = next.result;
        context.push(
          Uri(
            path: AppRoutes.emailVerificationPending,
            queryParameters: {
              if (result.email != null && result.email!.isNotEmpty)
                'email': result.email!,
            },
          ).toString(),
        );
      } else if (next is RegisterError) {
        showErrorSnackbar(context, next.error);
      }
    });

    final registerState = ref.watch(registerNotifierProvider);
    final isLoading = registerState is RegisterLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimary,
            size: 22,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Create an account', style: AppTypography.h1),
                      const SizedBox(height: 28),
                      AuthInputField(
                        controller: _nameController,
                        hint: 'Full Name',
                        focused: true,
                        textInputAction: TextInputAction.next,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      AuthInputField(
                        controller: _phoneController,
                        hint: 'Phone Number',
                        suffixText: '(Optional)',
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      AuthInputField(
                        controller: _emailController,
                        hint: 'Email Address',
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
                            _register();
                          }
                        },
                        enabled: !isLoading,
                        trailing: IconButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  setState(
                                    () => _showPassword = !_showPassword,
                                  );
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
                    ],
                  ),
                ),
              ),
              GzButton(
                label: 'Register',
                onPressed: isLoading ? null : _register,
                loading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
