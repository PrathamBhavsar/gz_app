import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Centred-title top bar: back arrow · title + optional subtitle · trailing widget.
class GzTopBar extends StatelessWidget implements PreferredSizeWidget {
  const GzTopBar({
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
            // Back button
            SizedBox(
              width: 40,
              child: disableBack
                  ? const SizedBox.shrink()
                  : GestureDetector(
                      onTap: onBack ?? () => Navigator.of(context).maybePop(),
                      child: Container(
                        width: 38, height: 38,
                        decoration: const BoxDecoration(color: Colors.transparent),
                        child: const HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowLeft01,
                          color: AppColors.textPrimary,
                          size: 22,
                        ),
                      ),
                    ),
            ),
            // Centre: title + subtitle
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: AppTypography.h2, textAlign: TextAlign.center),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(subtitle!, style: AppTypography.small, textAlign: TextAlign.center),
                    ),
                ],
              ),
            ),
            // Trailing
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
