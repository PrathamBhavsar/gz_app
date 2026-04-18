import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/admin_live_service.dart';
import '../../../core/auth/token_storage.dart';
import '../../../core/api/api_client.dart';
import '../../admin/presentation/providers/admin_auth_provider.dart';

/// Riverpod provider for [AdminLiveService].
/// Lifecycle is tied to the admin session — connects when authenticated,
/// disconnects on logout.
final adminLiveServiceProvider = Provider<AdminLiveService>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  final apiClient = ref.watch(apiClientProvider);

  final service = AdminLiveService(
    tokenStorage: tokenStorage,
    getAccessToken: () => ref.read(accessTokenProvider) ?? '',
  );

  // Auto-connect when storeId is available
  final storeId = ref.watch(adminStoreIdProvider);
  if (storeId != null) {
    Future.microtask(() => service.connect(storeId));
  }

  // Cleanup on dispose
  ref.onDispose(() => service.dispose());

  return service;
});

/// Stream provider that exposes typed [WsEvent]s.
/// Widgets watch this to react to real-time updates.
final liveEventsProvider = StreamProvider<WsEvent>((ref) {
  final service = ref.watch(adminLiveServiceProvider);
  return service.events;
});

/// Connection status provider — true when WS is connected.
final liveConnectionProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(adminLiveServiceProvider);
  return service.onConnectionChanged;
});

/// Provider that auto-reconnects the WebSocket when the admin logs in
/// and the storeId changes.
final wsAutoConnectProvider = Provider<void>((ref) {
  final storeId = ref.watch(adminStoreIdProvider);
  final adminState = ref.watch(adminAuthNotifierProvider);

  if (storeId != null && adminState is AdminAuthAuthenticated) {
    final service = ref.read(adminLiveServiceProvider);
    Future.microtask(() => service.connect(storeId));
  }
});
