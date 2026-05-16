import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class EmTopBar extends StatelessWidget implements PreferredSizeWidget {
  const EmTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.trailing,
    this.disableBack = false,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? trailing;
  final bool disableBack;

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
                  : GestureDetector(
                      onTap: onBack ?? () {
                        if (context.canPop()) context.pop();
                      },
                      child: const SizedBox(
                        width: 38,
                        height: 38,
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowLeft01,
                          color: AppColors.textPrimary,
                          size: 22,
                        ),
                      ),
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
                        style: AppTypography.small,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 40,
              child: trailing != null
                  ? Align(alignment: Alignment.centerRight, child: trailing)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
