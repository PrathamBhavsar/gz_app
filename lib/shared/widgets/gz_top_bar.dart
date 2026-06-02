import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class GzTopBar extends StatelessWidget implements PreferredSizeWidget {
  const GzTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.trailingWidth = 40,
    this.disableBack = false,
    this.onBack,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final double trailingWidth;
  final bool disableBack;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: disableBack
                  ? const SizedBox.shrink()
                  : IconButton(
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
                      constraints: const BoxConstraints.tightFor(
                        width: 40,
                        height: 40,
                      ),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: AppTypography.h2, textAlign: TextAlign.center),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: AppTypography.small.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: trailingWidth,
              child: Align(
                alignment: Alignment.centerRight,
                child: trailing ?? const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
