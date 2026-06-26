import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/errors/error_snackbar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/gz_button.dart';
import '../../../../../shared/widgets/gz_card.dart';
import '../../../../../shared/widgets/gz_meta_row.dart';
import '../../../application/admin_system_key_notifier.dart';

Future<void> showRegenerateSystemKeySheet(
  BuildContext context, {
  required String systemId,
  required String systemName,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        RegenerateSystemKeySheet(systemId: systemId, systemName: systemName),
  );
}

class RegenerateSystemKeySheet extends ConsumerWidget {
  const RegenerateSystemKeySheet({
    super.key,
    required this.systemId,
    required this.systemName,
  });

  final String systemId;
  final String systemName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminSystemKeyNotifierProvider(systemId));
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md + bottomInset,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: AppSpacing.xs,
                    decoration: BoxDecoration(
                      color: AppColors.rule,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadiusPill,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Regenerate API key', style: AppTypography.h1),
                const SizedBox(height: AppSpacing.xs),
                Text(systemName, style: AppTypography.bodyR),
                const SizedBox(height: AppSpacing.md),
                if (state is AdminSystemKeySuccess)
                  _SuccessView(
                    apiKey: state.result.apiKey ?? '',
                    systemId: systemId,
                  )
                else ...[
                  GzCard(
                    variant: CardVariant.inset,
                    padding: AppSpacing.md,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('This immediately invalidates the old key.'),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'Update the connected system agent configuration before it reconnects.',
                          style: AppTypography.bodyR,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  GzButton(
                    label: 'Regenerate key',
                    loading: state is AdminSystemKeyLoading,
                    onPressed: () => ref
                        .read(adminSystemKeyNotifierProvider(systemId).notifier)
                        .regenerate(),
                  ),
                ],
                if (state is AdminSystemKeyError) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppPageError.from(state.error).message,
                    style: AppTypography.bodyR.copyWith(color: AppColors.err),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessView extends ConsumerWidget {
  const _SuccessView({required this.apiKey, required this.systemId});

  final String apiKey;
  final String systemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GzCard(
          variant: CardVariant.tint,
          padding: AppSpacing.md,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GzMetaRow(label: 'Status', value: 'New key generated'),
              GzMetaRow(label: 'System', value: systemId),
              const SizedBox(height: AppSpacing.sm),
              SelectableText(
                apiKey,
                style: AppTypography.num.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GzButton(
          label: 'Copy key',
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: apiKey));
            if (!context.mounted) {
              return;
            }
            showSuccessSnackbar(context, 'API key copied');
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        GzButton(
          label: 'Done',
          variant: GzButtonVariant.ghost,
          onPressed: () {
            ref.read(adminSystemKeyNotifierProvider(systemId).notifier).reset();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
