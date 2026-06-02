import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/theme/app_colors.dart';

enum GzTab { home, book, sessions, wallet, profile }

class GzBottomNav extends StatelessWidget {
  const GzBottomNav({
    super.key,
    required this.currentTab,
    required this.onTap,
  });

  final GzTab currentTab;
  final ValueChanged<GzTab> onTap;

  static const _items = <(GzTab, dynamic)>[
    (GzTab.home, HugeIcons.strokeRoundedHome01),
    (GzTab.book, HugeIcons.strokeRoundedBook01),
    (GzTab.sessions, HugeIcons.strokeRoundedGameboy),
    (GzTab.wallet, HugeIcons.strokeRoundedWallet01),
    (GzTab.profile, HugeIcons.strokeRoundedUser),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(18, 14, 18, 22 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _items.map((item) {
          final isActive = item.$1 == currentTab;
          return Expanded(
            child: IconButton(
              onPressed: () => onTap(item.$1),
              icon: HugeIcon(
                icon: item.$2,
                color: isActive ? AppColors.textPrimary : AppColors.textMuted,
                size: 22,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          );
        }).toList(),
      ),
    );
  }
}
