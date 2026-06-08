import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/navigation/routes.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/network/player_ws_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../notifications/presentation/providers/notification_feed_notifier.dart';
import '../../../notifications/presentation/screens/notification_center_sheet.dart';
import '../../../../shared/widgets/gz_bottom_nav.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  GzTab _currentTab = GzTab.home;
  DateTime? _lastBackPress;
  StreamSubscription<PlayerWsEvent>? _wsSubscription;

  @override
  void initState() {
    super.initState();
    _connectPlayerWs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentTab = _tabForLocation(GoRouterState.of(context).matchedLocation);
    _showPendingDeepLinkOverlayIfNeeded();
  }

  Future<void> _connectPlayerWs() async {
    final userId = await ref.read(tokenStorageProvider).getUserId();
    if (!mounted || userId == null || userId.isEmpty) {
      return;
    }

    final service = ref.read(playerWsServiceProvider);
    await service.connect(userId);

    _wsSubscription = service.events.listen(_handleWsEvent);
  }

  void _handleWsEvent(PlayerWsEvent event) {
    if (!mounted) {
      return;
    }

    switch (event.type) {
      case PlayerWsEventType.notificationNew:
        ref
            .read(notificationFeedProvider.notifier)
            .prependFromWs(event.payload);
        break;
      case PlayerWsEventType.sessionEnded:
        final currentPath = GoRouter.of(
          context,
        ).routeInformationProvider.value.uri.path;
        if (currentPath.startsWith('/sessions/active/')) {
          context.go(AppRoutes.sessions);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Session ended')));
        }
        break;
      case PlayerWsEventType.sessionExtended:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Session extended')));
        break;
      case PlayerWsEventType.sessionStarted:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Session started')));
        break;
      case PlayerWsEventType.bookingCheckedIn:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Booking checked in')));
        break;
      case PlayerWsEventType.unknown:
        break;
    }
  }

  void _showPendingDeepLinkOverlayIfNeeded() {
    final overlay = consumePendingDeepLinkOverlay();
    if (overlay != PendingDeepLinkOverlay.notifications) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(showNotificationCenter(context));
    });
  }

  GzTab _tabForLocation(String location) {
    if (location.startsWith('/book')) return GzTab.book;
    if (location.startsWith('/sessions')) return GzTab.sessions;
    if (location.startsWith('/wallet')) return GzTab.wallet;
    if (location.startsWith('/profile')) return GzTab.profile;
    return GzTab.home;
  }

  void _onTap(GzTab tab) {
    if (tab == _currentTab) return;
    setState(() => _currentTab = tab);
    switch (tab) {
      case GzTab.home:
        context.go(AppRoutes.home);
      case GzTab.book:
        context.go(AppRoutes.book);
      case GzTab.sessions:
        context.go(AppRoutes.sessions);
      case GzTab.wallet:
        context.go(AppRoutes.wallet);
      case GzTab.profile:
        context.go(AppRoutes.profile);
    }
  }

  void _onPop(bool didPop, Object? result) {
    if (didPop) return;
    final now = DateTime.now();
    if (_lastBackPress == null ||
        now.difference(_lastBackPress!) > const Duration(seconds: 2)) {
      _lastBackPress = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Press back again to exit'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  void dispose() {
    _wsSubscription?.cancel();
    unawaited(ref.read(playerWsServiceProvider).disconnect());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPop,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: widget.child,
        bottomNavigationBar: GzBottomNav(
          currentTab: _currentTab,
          onTap: _onTap,
        ),
      ),
    );
  }
}
