import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

enum GzAdminTab { dashboard, sessions, management, store }

class GzAdminBottomNav extends StatelessWidget {
  const GzAdminBottomNav({
    super.key,
    required this.currentTab,
    required this.onTap,
  });

  final GzAdminTab currentTab;
  final ValueChanged<GzAdminTab> onTap;

  static const _items = <(GzAdminTab, String, dynamic)>[
    (GzAdminTab.dashboard, 'Floor', HugeIcons.strokeRoundedHome01),
    (GzAdminTab.sessions, 'Sessions', HugeIcons.strokeRoundedClock01),
    (GzAdminTab.management, 'Manage', HugeIcons.strokeRoundedBalanceScale),
    (GzAdminTab.store, 'Store', HugeIcons.strokeRoundedComputer),
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
        children: _items.map((item) {
          final isActive = item.$1 == currentTab;
          final color = isActive ? AppColors.rose : AppColors.textMuted;
          return Expanded(
            child: InkWell(
              onTap: () => onTap(item.$1),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HugeIcon(icon: item.$3, color: color, size: 20),
                    const SizedBox(height: 2),
                    Text(
                      item.$2,
                      style: AppTypography.small.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
