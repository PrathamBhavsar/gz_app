import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/navigation/routes.dart';
import '../../../../../core/network/admin_live_service.dart';
import '../../providers/admin_operations_provider.dart';
import '../../providers/admin_permissions.dart';
import '../../providers/admin_live_provider.dart';

final _sessionIdProvider = StateProvider.autoDispose<String?>((ref) => null);
final _sessionElapsedProvider =
    StateProvider.autoDispose<Duration>((ref) => Duration.zero);
final _sessionActionLoadingProvider =
    StateProvider.autoDispose<bool>((ref) => false);

String _formatElapsed(Duration d) {
  final hours = d.inHours.toString().padLeft(2, '0');
  final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$hours:$minutes:$seconds';
}

/// Session Management — Screen 43.
/// Granular control over an individual system and its active session.
class SessionManagementScreen extends ConsumerStatefulWidget {
  final String? systemId;
  const SessionManagementScreen({super.key, this.systemId});

  @override
  ConsumerState<SessionManagementScreen> createState() =>
      _SessionManagementScreenState();
}

class _SessionManagementScreenState
    extends ConsumerState<SessionManagementScreen> {
  Timer? _timer;
  int? _durationMinutes;
  StreamSubscription<WsEvent>? _wsSubscription;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadSessionForSystem());
  }

  void _loadSessionForSystem() {
    final floorState = ref.read(floorMapProvider);
    if (floorState is FloorMapLoaded && widget.systemId != null) {
      final system = floorState.systems
          .where((s) => s.systemId == widget.systemId)
          .firstOrNull;
      if (system?.currentSession != null) {
        final sessionId = system!.currentSession!.sessionId;
        _durationMinutes = system.currentSession!.durationMinutes;
        ref.read(_sessionIdProvider.notifier).state = sessionId;
        if (system.currentSession!.startedAt != null) {
          ref.read(_sessionElapsedProvider.notifier).state =
              DateTime.now().difference(system.currentSession!.startedAt!);
          _startTimer();
        }
        if (sessionId != null) {
          ref
              .read(sessionDetailProvider(sessionId).notifier)
              .loadSession(sessionId);
        }
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        ref.read(_sessionElapsedProvider.notifier).state +=
            const Duration(seconds: 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _wsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessionId = ref.watch(_sessionIdProvider);
    final elapsed = ref.watch(_sessionElapsedProvider);
    final isActionLoading = ref.watch(_sessionActionLoadingProvider);
    final perms = ref.watch(adminPermissionsProvider);

    _listenToSessionEvents();
    ref.watch(wsAutoConnectProvider);

    if (sessionId != null) {
      ref.watch(sessionDetailProvider(sessionId));
    }

    final floorState = ref.read(floorMapProvider);
    String systemName = widget.systemId ?? 'System';
    String? platform;
    String? playerName;
    if (floorState is FloorMapLoaded) {
      final system = floorState.systems
          .where((s) => s.systemId == widget.systemId)
          .firstOrNull;
      systemName = system?.name ?? systemName;
      platform = system?.platform;
      playerName = system?.currentSession?.userName;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => context.go(AppRoutes.adminDashboard),
        ),
        title: Row(
          children: [
            Text(systemName, style: AppTypography.headingSmall),
            const SizedBox(width: AppSpacing.sm),
            if (sessionId != null) const _LiveBadge(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            _SystemInfoBar(name: systemName, platform: platform),
            const SizedBox(height: AppSpacing.lg),
            if (sessionId != null) ...[
              _SessionTimerCard(
                elapsed: elapsed,
                durationMinutes: _durationMinutes,
              ),
              const SizedBox(height: AppSpacing.lg),
            ] else ...[
              _NoSessionCard(
                onStartWalkIn: () => context.go(AppRoutes.adminWalkIn),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            if (playerName != null) ...[
              _PlayerInfoCard(playerName: playerName),
              const SizedBox(height: AppSpacing.lg),
            ],
            if (sessionId != null)
              _ActionToolbar(
                perms: perms,
                isActionLoading: isActionLoading,
                onPause: () => _handleAction('pause'),
                onResume: () => _handleAction('resume'),
                onEnd: _handleEndSession,
                onExtend: _showExtendSheet,
              ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  void _listenToSessionEvents() {
    _wsSubscription?.cancel();
    _wsSubscription = ref.read(adminLiveServiceProvider).events.listen((event) {
      if (!mounted) return;
      final sessionId = ref.read(_sessionIdProvider);
      if (sessionId == null) return;
      switch (event.type) {
        case WsEventType.sessionEnded:
          final endedSessionId = event.payload['sessionId']?.toString();
          if (endedSessionId == sessionId) {
            _timer?.cancel();
            ref.read(_sessionIdProvider.notifier).state = null;
            ref.read(_sessionActionLoadingProvider.notifier).state = false;
          }
        case WsEventType.sessionStarted:
        case WsEventType.systemStatusChange:
          ref
              .read(sessionDetailProvider(sessionId).notifier)
              .loadSession(sessionId);
        default:
          break;
      }
    });
  }

  Future<void> _handleAction(String action) async {
    final sessionId = ref.read(_sessionIdProvider);
    if (sessionId == null) return;
    ref.read(_sessionActionLoadingProvider.notifier).state = true;

    final notifier = ref.read(sessionDetailProvider(sessionId).notifier);
    switch (action) {
      case 'pause':
        await notifier.pauseSession(sessionId);
      case 'resume':
        await notifier.resumeSession(sessionId);
    }

    if (mounted) ref.read(_sessionActionLoadingProvider.notifier).state = false;
  }

  Future<void> _handleEndSession() async {
    final sessionId = ref.read(_sessionIdProvider);
    if (sessionId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'End Session?',
          style:
              AppTypography.headingSmall.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'This will end the current session and trigger billing.',
          style: AppTypography.bodyMedium
              .copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: Text(
              'Cancel',
              style:
                  AppTypography.button.copyWith(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => ctx.pop(true),
            child: Text(
              'End Session',
              style: AppTypography.button.copyWith(color: AppColors.rose),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ref.read(_sessionActionLoadingProvider.notifier).state = true;
      await ref
          .read(sessionDetailProvider(sessionId).notifier)
          .endSession(sessionId);
      _timer?.cancel();
      if (mounted) {
        ref.read(_sessionActionLoadingProvider.notifier).state = false;
        ref.read(_sessionIdProvider.notifier).state = null;
        context.go(AppRoutes.adminDashboard);
      }
    }
  }

  void _showExtendSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadiusLg),
        ),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Extend Session',
              style: AppTypography.headingSmall
                  .copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Select duration to extend:',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _ExtendChip(label: '+15 min', onTap: () => _doExtend(ctx, 15)),
                _ExtendChip(label: '+30 min', onTap: () => _doExtend(ctx, 30)),
                _ExtendChip(label: '+1 hour', onTap: () => _doExtend(ctx, 60)),
                _ExtendChip(
                    label: '+2 hours', onTap: () => _doExtend(ctx, 120)),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Future<void> _doExtend(BuildContext sheetCtx, int minutes) async {
    sheetCtx.pop();
    final sessionId = ref.read(_sessionIdProvider);
    if (sessionId == null) return;
    ref.read(_sessionActionLoadingProvider.notifier).state = true;
    await ref
        .read(sessionDetailProvider(sessionId).notifier)
        .extendSession(sessionId, minutes);
    if (mounted) {
      ref.read(_sessionActionLoadingProvider.notifier).state = false;
    }
  }
}

// ─── Live Badge ───────────────────────────────────────────────────────────────

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'Live',
            style: AppTypography.caption
                .copyWith(color: AppColors.success, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ─── System Info Bar ──────────────────────────────────────────────────────────

class _SystemInfoBar extends StatelessWidget {
  const _SystemInfoBar({required this.name, this.platform});
  final String name;
  final String? platform;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Row(
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedGameboy,
            color: AppColors.rose,
            size: 32,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.headingSmall),
                if (platform != null)
                  Text(
                    platform!,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Timer Card ───────────────────────────────────────────────────────────────

class _SessionTimerCard extends StatelessWidget {
  const _SessionTimerCard({required this.elapsed, this.durationMinutes});
  final Duration elapsed;
  final int? durationMinutes;

  @override
  Widget build(BuildContext context) {
    final remaining = durationMinutes != null
        ? (durationMinutes! * 60) - elapsed.inSeconds
        : 0;
    final progress = durationMinutes != null && durationMinutes! > 0
        ? (elapsed.inSeconds / (durationMinutes! * 60)).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        children: [
          Text(
            _formatElapsed(elapsed),
            style: AppTypography.headingLarge.copyWith(
              fontFamily: 'monospace',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.secondary,
              color: remaining < 600 ? AppColors.rose : AppColors.success,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            remaining > 0
                ? '${(remaining / 60).ceil()} min remaining'
                : 'Time exceeded',
            style: AppTypography.bodySmall.copyWith(
              color: remaining < 600 && remaining > 0
                  ? AppColors.rose
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── No Session Card ──────────────────────────────────────────────────────────

class _NoSessionCard extends StatelessWidget {
  const _NoSessionCard({required this.onStartWalkIn});
  final VoidCallback onStartWalkIn;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedClock01,
            color: AppColors.textSecondary,
            size: 48,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Active Session',
            style:
                AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onStartWalkIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rose,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
                ),
              ),
              child: Text('Start Walk-in', style: AppTypography.button),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Player Info Card ─────────────────────────────────────────────────────────

class _PlayerInfoCard extends StatelessWidget {
  const _PlayerInfoCard({required this.playerName});
  final String playerName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Row(
        children: [
          const HugeIcon(
            icon: HugeIcons.strokeRoundedUserCircle,
            color: AppColors.textSecondary,
            size: 32,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(playerName, style: AppTypography.bodyLarge),
                Text(
                  'Walk-in',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action Toolbar ───────────────────────────────────────────────────────────

class _ActionToolbar extends StatelessWidget {
  const _ActionToolbar({
    required this.perms,
    required this.isActionLoading,
    required this.onPause,
    required this.onResume,
    required this.onEnd,
    required this.onExtend,
  });
  final AdminPermissions perms;
  final bool isActionLoading;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onEnd;
  final VoidCallback? onExtend;

  @override
  Widget build(BuildContext context) {
    final canPauseResume = perms.canPauseResumeSessions;
    final canExtend = perms.canExtendSessions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions',
          style: AppTypography.headingSmall
              .copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            if (canPauseResume)
              Expanded(
                child: _ActionButton(
                  icon: HugeIcons.strokeRoundedPause,
                  label: 'Pause',
                  color: AppColors.textPrimary,
                  bgColor: AppColors.surface,
                  isLoading: isActionLoading,
                  onTap: onPause,
                ),
              ),
            if (canPauseResume) const SizedBox(width: AppSpacing.sm),
            if (canPauseResume)
              Expanded(
                child: _ActionButton(
                  icon: HugeIcons.strokeRoundedPlay,
                  label: 'Resume',
                  color: AppColors.textPrimary,
                  bgColor: AppColors.surface,
                  isLoading: isActionLoading,
                  onTap: onResume,
                ),
              ),
            if (canPauseResume) const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ActionButton(
                icon: HugeIcons.strokeRoundedStop,
                label: 'End',
                color: AppColors.background,
                bgColor: AppColors.rose,
                isLoading: isActionLoading,
                onTap: onEnd,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ActionButton(
                icon: HugeIcons.strokeRoundedForward01,
                label: 'Extend',
                color: AppColors.textPrimary,
                bgColor: AppColors.surface,
                isLoading: isActionLoading,
                onTap: canExtend ? onExtend : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.isLoading,
    this.onTap,
  });
  final List<List<dynamic>> icon;
  final String label;
  final Color color;
  final Color bgColor;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          border: bgColor == AppColors.surface
              ? Border.all(color: AppColors.border)
              : null,
        ),
        child: Column(
          children: [
            isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.rose,
                    ),
                  )
                : HugeIcon(icon: icon, color: color, size: 20),
            const SizedBox(height: AppSpacing.xs),
            Text(label, style: AppTypography.caption.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

// ─── Extend Chip ──────────────────────────────────────────────────────────────

class _ExtendChip extends StatelessWidget {
  const _ExtendChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(label, style: AppTypography.bodyMedium),
      ),
    );
  }
}
