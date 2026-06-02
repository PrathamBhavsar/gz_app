import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class GzAdminTopBar extends StatelessWidget implements PreferredSizeWidget {
  const GzAdminTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onBack,
    this.disableBack = false,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onBack;
  final bool disableBack;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(
          children: [
            if (!disableBack)
              IconButton(
                onPressed: onBack ??
                    () {
                      if (context.canPop()) context.pop();
                    },
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedArrowLeft01,
                  color: AppColors.textPrimary,
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(width: 36, height: 36),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            if (!disableBack) const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: AppTypography.h2),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(
                        subtitle!,
                        style: AppTypography.small.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) ...[trailing!],
          ],
        ),
      ),
    );
  }
}
