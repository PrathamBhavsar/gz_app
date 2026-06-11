import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../application/admin_command_state.dart';
import '../../../application/admin_session_command_notifier.dart';

Future<void> showEndSessionSheet(
  BuildContext context, {
  required String sessionId,
  required String systemName,
  required String elapsed,
  VoidCallback? onCompleted,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => EndSessionSheet(
      sessionId: sessionId,
      systemName: systemName,
      elapsed: elapsed,
      onCompleted: onCompleted,
    ),
  );
}

class EndSessionSheet extends ConsumerWidget {
  const EndSessionSheet({
    super.key,
    required this.sessionId,
    required this.systemName,
    required this.elapsed,
    this.onCompleted,
  });

  final String sessionId;
  final String systemName;
  final String elapsed;
  final VoidCallback? onCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(adminSessionCommandNotifierProvider(sessionId), (_, next) {
      if (next is AdminCommandSuccess) {
        showSuccessSnackbar(context, next.message);
        onCompleted?.call();
        Navigator.of(context).pop();
      } else if (next is AdminCommandError) {
        showErrorSnackbar(context, ValidationException(next.message));
      }
    });

    final state = ref.watch(adminSessionCommandNotifierProvider(sessionId));
    final loading = state is AdminCommandLoading;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12 + bottomInset),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.rule,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusPill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedAlertCircle,
                      color: AppColors.err,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text('End session', style: AppTypography.h1),
                  ],
                ),
                const SizedBox(height: 4),
                Text(systemName, style: AppTypography.bodyR),
                const SizedBox(height: 16),
                GzCard(
                  variant: CardVariant.tint,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CURRENT SESSION', style: AppTypography.meta),
                      const SizedBox(height: 10),
                      Text(elapsed, style: AppTypography.heroMd),
                      const SizedBox(height: 8),
                      const GzMetaRow(
                        label: 'Result',
                        value: 'Billing will be finalized immediately',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                GzButton(
                  label: 'End session now',
                  loading: loading,
                  variant: GzButtonVariant.dangerOutline,
                  onPressed: () => ref
                      .read(
                        adminSessionCommandNotifierProvider(sessionId).notifier,
                      )
                      .end(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
