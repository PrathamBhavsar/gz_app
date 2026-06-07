import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';

Future<void> showExtendSessionSheet(
  BuildContext context, {
  required String sessionId,
  required String systemName,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ExtendSessionSheet(
      sessionId: sessionId,
      systemName: systemName,
    ),
  );
}

class ExtendSessionSheet extends StatefulWidget {
  const ExtendSessionSheet({
    super.key,
    required this.sessionId,
    required this.systemName,
  });

  final String sessionId;
  final String systemName;

  @override
  State<ExtendSessionSheet> createState() => _ExtendSessionSheetState();
}

class _ExtendSessionSheetState extends State<ExtendSessionSheet> {
  int _minutes = 30;

  static const _options = [15, 30, 45, 60];

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
                const Text('Extend session', style: AppTypography.h1),
                const SizedBox(height: 4),
                Text(widget.systemName, style: AppTypography.bodyR),
                const SizedBox(height: 16),
                const Text('Add time', style: AppTypography.h3),
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (int i = 0; i < _options.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _minutes = _options[i]),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: _minutes == _options[i]
                                  ? AppColors.textPrimary
                                  : AppColors.pillBg,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.borderRadiusPill,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${_options[i]} min',
                              style: AppTypography.body.copyWith(
                                color: _minutes == _options[i]
                                    ? AppColors.surface
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),
                GzCard(
                  variant: CardVariant.inset,
                  child: Column(
                    children: [
                      GzMetaRow(
                        label: 'Additional cost',
                        value:
                            '₹${(_minutes / 60 * 80).toStringAsFixed(0)}',
                      ),
                      const GzMetaRow(
                        label: 'New end time',
                        value: '07:22 PM',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                GzButton(
                  label: 'Extend by $_minutes min',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
