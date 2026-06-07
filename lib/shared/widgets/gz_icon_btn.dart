import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class GzIconBtn extends StatelessWidget {
  const GzIconBtn({
    super.key,
    required this.child,
    this.onTap,
    this.tooltip,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    Widget btn = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: AppColors.textPrimary.withValues(alpha: 0.08),
        highlightColor: AppColors.textPrimary.withValues(alpha: 0.05),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Center(child: child),
        ),
      ),
    );

    if (tooltip != null) {
      btn = Tooltip(message: tooltip!, child: btn);
    }

    return btn;
  }
}
