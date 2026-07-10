import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/network/admin_live_service.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../models/domain_activity.dart';
import '../../../../../shared/widgets/gz_activity_card.dart';
import '../../../../../shared/widgets/gz_admin_top_bar.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_chip.dart';
import '../../../../../shared/widgets/gz_loading_view.dart';
import '../../../../../shared/widgets/page_error_display.dart';
import '../../../application/admin_operations_models.dart';
import '../../../application/admin_sessions_notifier.dart';

enum _Tab { all, current, incoming, past }

extension on _Tab {
  String get label => switch (this) {
    _Tab.all => 'All',
    _Tab.current => 'Current',
    _Tab.incoming => 'Incoming',
    _Tab.past => 'Past',
  };
}

/// Store-wide activity feed: All / Current / Incoming / Past, latest first.
class SessionManagementScreen extends ConsumerStatefulWidget {
  const SessionManagementScreen({super.key, this.systemId});

  /// Retained for the (unused-by-default) deep-link case; the store-wide
  /// feed is not filtered by this — SystemSessionsScreen is the per-system view.
  final String? systemId;

  @override
  ConsumerState<SessionManagementScreen> createState() =>
      _SessionManagementScreenState();
}

class _SessionManagementScreenState
    extends ConsumerState<SessionManagementScreen> {
  _Tab _tab = _Tab.all;

  @override
  Widget build(BuildContext context) {
    ref.listen(adminLiveEventsProvider, (_, next) {
      next.whenData((_) {
        ref.read(adminSessionsNotifierProvider.notifier).refresh();
      });
    });

    final sessions = ref.watch(adminSessionsNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzAdminTopBar(
        title: 'Session Management',
        onBack: () => context.go(AppRoutes.adminDashboard),
      ),
      body: sessions.when(
        loading: () => const GzLoadingView(message: 'Loading sessions'),
        error: (error, _) => PageErrorDisplay(
          error: AppPageError.from(error),
          onRetry: () =>
              ref.read(adminSessionsNotifierProvider.notifier).refresh(),
        ),
        data: (data) => _buildContent(context, data),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AdminSessionsData data) {
    final items = _itemsFor(data, _tab);
    return SafeArea(
      top: false,
      child: RefreshIndicator(
        onRefresh: () =>
            ref.read(adminSessionsNotifierProvider.notifier).refresh(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _Tab.values
                      .map(
                        (tab) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GzChip(
                            label:
                                '${tab.label} (${_itemsFor(data, tab).length})',
                            active: _tab == tab,
                            onTap: () => setState(() => _tab = tab),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      children: [
                        GzCard(
                          child: Text(
                            'No ${_tab.label.toLowerCase()} activity.',
                            style: AppTypography.bodyR,
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      children: items
                          .map(
                            (item) => GzActivityCard(
                              item: item,
                              onTap:
                                  item.kind == ActivityKind.session &&
                                      item.id != null
                                  ? () => context.push(
                                      AppRoutes.adminSessionDetailPath(
                                        item.id!,
                                      ),
                                    )
                                  : null,
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<AdminActivityItem> _itemsFor(AdminSessionsData data, _Tab tab) {
    switch (tab) {
      case _Tab.all:
        return data.items;
      case _Tab.current:
        return data.current;
      case _Tab.incoming:
        return data.incoming;
      case _Tab.past:
        return data.past;
    }
  }
}
