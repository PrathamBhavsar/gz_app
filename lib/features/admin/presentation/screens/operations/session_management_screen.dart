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
import '../../providers/admin_auth_provider.dart';
import '../../providers/admin_operations_provider.dart';
import '../../providers/admin_permissions.dart';
import '../../providers/admin_live_provider.dart';

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
  Duration _elapsed = Duration.zero;
  String? _sessionId;
  int? _durationMinutes;
  bool _isActionLoading = false;
  StreamSubscription<WsEvent>? _wsSubscription;

  @override
  void initState() {
    super.initState();
    // If systemId is provided, find active session for that system
    // For now, load from floor map data
    Future.microtask(() => _loadSessionForSystem());
  }

  void _loadSessionForSystem() {
    final floorState = ref.read(floorMapProvider);
    if (floorState is FloorMapLoaded && widget.systemId != null) {
      final system = floorState.systems
          .where((s) => s.systemId == widget.systemId)
          .firstOrNull;
      if (system?.currentSession != null) {
        _sessionId = system!.currentSession!.sessionId;
        _durationMinutes = system.currentSession!.durationMinutes;
        if (system.currentSession!.startedAt != null) {
          _elapsed = DateTime.now()
              .difference(system.currentSession!.startedAt!);
          _startTimer();
        }
        if (_sessionId != null) {
          ref
              .read(sessionDetailProvider(_sessionId!).notifier)
              .loadSession(_sessionId!);
        }
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _elapsed += const Duration(seconds: 1));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _wsSubscription?.cancel();
    super.dispose();
  }

  String _formatElapsed(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final perms = ref.watch(adminPermissionsProvider);

    // Watch live events for session updates
    _listenToSessionEvents();

    // Ensure WS is connected
    ref.watch(wsAutoConnectProvider);

    // Watch session detail if sessionId is set
    SessionDetailState? sessionState;
    if (_sessionId != null) {
      sessionState = ref.watch(sessionDetailProvider(_sessionId!));
    }

    // Get system info from floor map
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
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.go(AppRoutes.adminDashboard),
        ),
        title: Row(
          children: [
            Text(systemName, style: AppTypography.headingSmall),
            const SizedBox(width: AppSpacing.sm),
            if (_sessionId != null) _buildLiveBadge(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.md),
            // System info bar
            _buildSystemInfoBar(systemName, platform),
            const SizedBox(height: AppSpacing.lg),

            // Live timer card
            if (_sessionId != null) ...[
              _buildTimerCard(),
              const SizedBox(height: AppSpacing.lg),
            ] else ...[
              _buildNoSessionCard(),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Player info
            if (playerName != null) ...[
              _buildPlayerInfoCard(playerName),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Action toolbar
            if (_sessionId != null)
              _buildActionToolbar(perms),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  /// Listen to WebSocket events for real-time session updates.
  void _listenToSessionEvents() {
    _wsSubscription?.cancel();
    _wsSubscription = ref.read(adminLiveServiceProvider).events.listen((event) {
      if (!mounted || _sessionId == null) return;
      switch (event.type) {
        case WsEventType.sessionEnded:
          final endedSessionId = event.payload['sessionId']?.toString();
          if (endedSessionId == _sessionId) {
            _timer?.cancel();
            setState(() {
              _sessionId = null;
              _isActionLoading = false;
            });
          }
        case WsEventType.sessionStarted:
        case WsEventType.systemStatusChange:
          // Refresh session detail if it affects this session
          ref.read(sessionDetailProvider(_sessionId!).notifier).loadSession(_sessionId!);
        default:
          break;
      }
    });
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.15),
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
          Text('Live',
              style: AppTypography.caption.copyWith(
                  color: AppColors.success, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSystemInfoBar(String name, String? platform) {
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
                  Text(platform,
                      style: AppTypography.caption
                          .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCard() {
    final remaining = _durationMinutes != null
        ? (_durationMinutes! * 60) - _elapsed.inSeconds
        : 0;
    final progress = _durationMinutes != null && _durationMinutes! > 0
        ? (_elapsed.inSeconds / (_durationMinutes! * 60)).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      ),
      child: Column(
        children: [
          // Elapsed time
          Text(
            _formatElapsed(_elapsed),
            style: AppTypography.headingLarge.copyWith(
              fontFamily: 'monospace',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Progress bar
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
          // Remaining time
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

  Widget _buildNoSessionCard() {
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
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go(AppRoutes.adminWalkIn),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.rose,
                foregroundColor: AppColors.background,
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadius),
                ),
              ),
              child:
                  Text('Start Walk-in', style: AppTypography.button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerInfoCard(String playerName) {
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
                Text('Walk-in',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionToolbar(AdminPermissions perms) {
    final canPauseResume = perms.canPauseResumeSessions;
    final canExtend = perms.canExtendSessions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Actions',
            style: AppTypography.headingSmall
                .copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            if (canPauseResume)
              Expanded(
                child: _buildActionButton(
                  icon: HugeIcons.strokeRoundedPause,
                  label: 'Pause',
                  color: AppColors.textPrimary,
                  bgColor: AppColors.surface,
                  onTap: () => _handleAction('pause'),
                ),
              ),
            if (canPauseResume)
              const SizedBox(width: AppSpacing.sm),
            if (canPauseResume)
              Expanded(
                child: _buildActionButton(
                  icon: HugeIcons.strokeRoundedPlay,
                  label: 'Resume',
                  color: AppColors.textPrimary,
                  bgColor: AppColors.surface,
                  onTap: () => _handleAction('resume'),
                ),
              ),
            if (canPauseResume)
              const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildActionButton(
                icon: HugeIcons.strokeRoundedStop,
                label: 'End',
                color: AppColors.background,
                bgColor: AppColors.rose,
                onTap: () => _handleEndSession(),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _buildActionButton(
                icon: HugeIcons.strokeRoundedForward15Seconds,
                label: 'Extend',
                color: AppColors.textPrimary,
                bgColor: AppColors.surface,
                onTap: canExtend ? () => _showExtendSheet() : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: _isActionLoading ? null : onTap,
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
            _isActionLoading
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
            Text(label,
                style: AppTypography.caption.copyWith(color: color)),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAction(String action) async {
    if (_sessionId == null) return;
    setState(() => _isActionLoading = true);

    final notifier =
        ref.read(sessionDetailProvider(_sessionId!).notifier);
    switch (action) {
      case 'pause':
        await notifier.pauseSession(_sessionId!);
      case 'resume':
        await notifier.resumeSession(_sessionId!);
    }

    if (mounted) setState(() => _isActionLoading = false);
  }

  Future<void> _handleEndSession() async {
    if (_sessionId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('End Session?',
            style: AppTypography.headingSmall
                .copyWith(color: AppColors.textPrimary)),
        content: Text(
          'This will end the current session and trigger billing.',
          style:
              AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: AppTypography.button
                    .copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('End Session',
                style: AppTypography.button.copyWith(color: AppColors.rose)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isActionLoading = true);
      await ref
          .read(sessionDetailProvider(_sessionId!).notifier)
          .endSession(_sessionId!);
      _timer?.cancel();
      if (mounted) {
        setState(() {
          _isActionLoading = false;
          _sessionId = null;
        });
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
            Text('Extend Session',
                style: AppTypography.headingSmall
                    .copyWith(color: AppColors.textPrimary)),
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
                _buildExtendChip('+15 min', 15),
                _buildExtendChip('+30 min', 30),
                _buildExtendChip('+1 hour', 60),
                _buildExtendChip('+2 hours', 120),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildExtendChip(String label, int minutes) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
        if (_sessionId == null) return;
        setState(() => _isActionLoading = true);
        await ref
            .read(sessionDetailProvider(_sessionId!).notifier)
            .extendSession(_sessionId!, minutes);
        if (mounted) setState(() => _isActionLoading = false);
      },
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
