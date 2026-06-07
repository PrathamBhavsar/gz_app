import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';

Future<void> showEndSessionSheet(
  BuildContext context, {
  required String sessionId,
  required String systemName,
  required String elapsed,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => EndSessionSheet(
      sessionId: sessionId,
      systemName: systemName,
      elapsed: elapsed,
    ),
  );
}

class EndSessionSheet extends StatefulWidget {
  const EndSessionSheet({
    super.key,
    required this.sessionId,
    required this.systemName,
    required this.elapsed,
  });

  final String sessionId;
  final String systemName;
  final String elapsed;

  @override
  State<EndSessionSheet> createState() => _EndSessionSheetState();
}

class _EndSessionSheetState extends State<EndSessionSheet> {
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
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
                // drag handle
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
                Row(
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedAlertCircle,
                      color: AppColors.err,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text('End session', style: AppTypography.h1),
                  ],
                ),
                const SizedBox(height: 4),
                Text(widget.systemName, style: AppTypography.bodyR),
                const SizedBox(height: 16),
                GzCard(
                  variant: CardVariant.tint,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('FINAL BILLING', style: AppTypography.meta),
                      const SizedBox(height: 10),
                      Text(widget.elapsed, style: AppTypography.heroMd),
                      const SizedBox(height: 8),
                      const GzMetaRow(label: 'Rate', value: '₹80/hr'),
                      const GzMetaRow(label: 'Total', value: '₹110', valueBold: true),
                      const GzMetaRow(label: 'Player', value: 'Rahul Mehra'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Session will end immediately. Billing will be finalized.',
                  style: AppTypography.bodyR,
                ),
                const SizedBox(height: 18),
                if (_confirmed) ...[
                  GzCard(
                    variant: CardVariant.inset,
                    child: Text(
                      'Session ended. Bill finalized.',
                      style: AppTypography.body.copyWith(
                        color: AppColors.ok,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                GzButton(
                  label: _confirmed ? 'Done' : 'End session now',
                  variant: _confirmed
                      ? GzButtonVariant.ghost
                      : GzButtonVariant.dangerOutline,
                  onPressed: _confirmed
                      ? () => Navigator.pop(context)
                      : () => setState(() => _confirmed = true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
