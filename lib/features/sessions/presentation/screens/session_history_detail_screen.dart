import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/gz_collapse.dart';
import '../../../../shared/widgets/gz_loading_view.dart';
import '../../../../shared/widgets/gz_meta_row.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../../../shared/widgets/gz_top_bar.dart';
import '../../../../shared/widgets/page_error_display.dart';
import '../providers/session_runtime_providers.dart';

class SessionHistoryDetailScreen extends ConsumerWidget {
  const SessionHistoryDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionDetailNotifierProvider(id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: GzTopBar(title: 'Session receipt'),
      body: SafeArea(
        top: false,
        child: session.when(
          loading: () => const GzLoadingView(message: 'Loading session receipt...'),
          error: (error, _) => PageErrorDisplay(
            error: AppPageError.from(error),
            onRetry: () => ref.read(sessionDetailNotifierProvider(id).notifier).refresh(),
          ),
          data: (data) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.id.isEmpty ? 'Session' : data.id,
                      style: AppTypography.h3.copyWith(
                        fontFamily: 'GeistMono',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const GzTag(kind: GzTagKind.ok, label: 'Completed'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data.systemName} · ${data.storeName}',
                      style: AppTypography.h3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  children: [
                    GzMetaRow(label: 'Started', value: data.startedLabel),
                    GzMetaRow(label: 'Ended', value: data.endedLabel),
                    GzMetaRow(label: 'Duration', value: data.durationLabel),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  children: [
                    GzMetaRow(label: 'Rate', value: data.rateLabel),
                    GzMetaRow(
                      label: 'Total',
                      value: data.totalLabel,
                      valueBold: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _Card(
                child: Column(
                  children: [
                    GzMetaRow(label: 'Method', value: data.methodLabel),
                    GzMetaRow(label: 'Status', value: data.statusLabel),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GzCollapse(
                title: 'Session events',
                initiallyOpen: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final event in data.events)
                      _EventRow(time: event.time, event: event.event),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
      child: child,
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.time, required this.event});
  final String time;
  final String event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            time,
            style: AppTypography.small.copyWith(
              color: AppColors.textTertiary,
              fontFamily: 'GeistMono',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(event, style: AppTypography.bodyR)),
        ],
      ),
    );
  }
}
