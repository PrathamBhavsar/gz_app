import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class GzCollapse extends StatefulWidget {
  const GzCollapse({
    super.key,
    required this.title,
    required this.child,
    this.initiallyOpen = false,
    this.trailing,
  });

  final String title;
  final Widget child;
  final bool initiallyOpen;
  final Widget? trailing;

  @override
  State<GzCollapse> createState() => _GzCollapseState();
}

class _GzCollapseState extends State<GzCollapse> {
  late bool _open = widget.initiallyOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: Text(widget.title, style: AppTypography.h2)),
                  if (widget.trailing != null) ...[
                    widget.trailing!,
                    const SizedBox(width: 10),
                  ],
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      color: AppColors.textTertiary,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_open)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: widget.child,
            ),
        ],
      ),
    );
  }
}
