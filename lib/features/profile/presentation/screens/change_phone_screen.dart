import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_button.dart';
import '../../../../shared/widgets/gz_top_bar.dart';

class ChangePhoneScreen extends StatefulWidget {
  const ChangePhoneScreen({super.key});

  @override
  State<ChangePhoneScreen> createState() => _ChangePhoneScreenState();
}

class _ChangePhoneScreenState extends State<ChangePhoneScreen> {
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const GzTopBar(title: 'Change phone'),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current number: +91 98765 43210',
                style: AppTypography.bodyR,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('New phone number', style: AppTypography.meta),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLg),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.pillBg,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.borderRadius,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('+91', style: AppTypography.body),
                          SizedBox(width: AppSpacing.sm),
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedArrowDown01,
                            color: AppColors.textTertiary,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: '98765 43210',
                          border: InputBorder.none,
                        ),
                        style: AppTypography.body,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GzButton(
                label: 'Send OTP',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'OTP sent to +91 ${_phoneController.text.trim().isEmpty ? '98765 43210' : _phoneController.text.trim()}',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
