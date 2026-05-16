import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import 'em_card.dart';

class EmCollapse extends StatelessWidget {
  const EmCollapse({
    super.key,
    required this.title,
    required this.child,
    required this.isOpen,
    required this.onToggle,
    this.right,
  });

  final String title;
  final Widget child;
  final bool isOpen;
  final VoidCallback onToggle;
  final Widget? right;

  @override
  Widget build(BuildContext context) {
    return EmCard(
      variant: CardVariant.base,
      padding: AppSpacing.xs,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Text(title, style: AppTypography.h2),
                  if (right != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    right!,
                  ],
                  const Spacer(),
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowDown01,
                    color: AppColors.textSecondary,
                    size: 18,
                  )
                      .animate(target: isOpen ? 1.0 : 0.0)
                      .rotate(
                        begin: 0,
                        end: 0.5,
                        duration: 200.ms,
                        curve: Curves.easeInOut,
                      ),
                ],
              ),
            ),
          ),
          if (isOpen)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: child,
            ),
        ],
      ),
    );
  }
}
