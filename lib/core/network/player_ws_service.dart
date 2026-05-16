import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../api/api_constants.dart';
import '../auth/token_storage.dart';

/// WebSocket event types from the Player Notification feed.
enum PlayerWsEventType {
  notificationNew('notification.new'),
  sessionStarted('session.started'),
  sessionEnded('session.ended'),
  sessionExtended('session.extended'),
  bookingCheckedIn('booking.checked_in'),
  unknown('');

  final String value;
  const PlayerWsEventType(this.value);

  static PlayerWsEventType fromString(String v) {
    return PlayerWsEventType.values.firstWhere(
      (e) => e.value == v,
      orElse: () => PlayerWsEventType.unknown,
    );
  }
}

/// A single parsed WebSocket event from the player notification feed.
class PlayerWsEvent {
  final PlayerWsEventType type;
  final Map<String, dynamic> payload;
  final DateTime receivedAt;

  const PlayerWsEvent({
    required this.type,
    required this.payload,
    required this.receivedAt,
  });
}

/// Manages the WebSocket connection to `/ws/users/:userId/notify?token=`.
///
/// Features:
/// - Auto-reconnect with exponential backoff (1s, 2s, 4s, 8s, max 30s).
/// - Emits typed [PlayerWsEvent]s through a broadcast stream.
/// - Graceful connect / disconnect lifecycle tied to player session.
class PlayerWsService {
  PlayerWsService({
    required String? Function() getAccessToken,
  }) : _getAccessToken = getAccessToken;

  final String? Function() _getAccessToken;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;
  Duration _reconnectDelay = const Duration(seconds: 1);
  bool _disposed = false;
  String? _activeUserId;

  final _eventController = StreamController<PlayerWsEvent>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  /// Stream of parsed WebSocket events.
  Stream<PlayerWsEvent> get events => _eventController.stream;

  /// Whether the WebSocket is currently connected.
  bool get isConnected => _channel != null;

  /// Stream of connection state changes (true = connected, false = disconnected).
  Stream<bool> get onConnectionChanged => _connectionController.stream;

  // ─── Connect ────────────────────────────────────────────────────────

  /// Opens a WebSocket connection for the given [userId].
  /// Any existing connection is closed first.
  Future<void> connect(String userId) async {
    if (_disposed) return;

    await disconnect();

    _activeUserId = userId;
    final token = _getAccessToken();
    if (token == null || token.isEmpty) return;

    final baseUrl = ApiConstants.baseUrl;
    final wsBase = baseUrl
        .replaceFirst('http://', 'ws://')
        .replaceFirst('https://', 'wss://');
    final wsUrl = '$wsBase${ApiConstants.wsPlayerNotify.replaceAll('{userId}', userId)}?token=$token';

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _subscription = _channel!.stream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );

      _connectionController.add(true);
      _reconnectDelay = const Duration(seconds: 1);
      debugPrint('PlayerWS ✓ Connected for user $userId');
    } catch (e) {
      debugPrint('PlayerWS ✗ Connect failed: $e');
      _scheduleReconnect();
    }
  }

  // ─── Disconnect ─────────────────────────────────────────────────────

  /// Closes the WebSocket connection. Does NOT schedule reconnect.
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
    if (!_connectionController.isClosed) {
      _connectionController.add(false);
    }
  }

  // ─── Dispose ────────────────────────────────────────────────────────

  /// Permanently tears down this service. No reconnect will be attempted.
  Future<void> dispose() async {
    _disposed = true;
    await disconnect();
    await _eventController.close();
    await _connectionController.close();
  }

  // ─── Internal handlers ──────────────────────────────────────────────

  void _onData(dynamic raw) {
    if (raw is! String) return;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final typeStr = json['event'] as String? ?? json['type'] as String? ?? '';
      final rawPayload = json['data'] ?? json;
      final payload = rawPayload is Map<String, dynamic>
          ? rawPayload
          : Map<String, dynamic>.from(rawPayload as Map);

      final event = PlayerWsEvent(
        type: PlayerWsEventType.fromString(typeStr),
        payload: payload,
        receivedAt: DateTime.now(),
      );

      if (!_eventController.isClosed) {
        _eventController.add(event);
      }
    } catch (e) {
      debugPrint('PlayerWS ✗ Parse error: $e');
    }
  }

  void _onError(Object error) {
    debugPrint('PlayerWS ✗ Error: $error');
    if (!_connectionController.isClosed) _connectionController.add(false);
    _scheduleReconnect();
  }

  void _onDone() {
    debugPrint('PlayerWS ✗ Connection closed');
    if (!_connectionController.isClosed) _connectionController.add(false);
    if (!_disposed) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_disposed || _activeUserId == null) return;

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () async {
      if (_disposed || _activeUserId == null) return;
      debugPrint('PlayerWS ↻ Reconnecting (delay: ${_reconnectDelay.inSeconds}s)');
      await connect(_activeUserId!);

      // Exponential backoff capped at 30s
      _reconnectDelay = Duration(
        seconds: (_reconnectDelay.inSeconds * 2).clamp(1, 30),
      );
    });
  }
}

final playerWsServiceProvider = Provider<PlayerWsService>((ref) {
  final service = PlayerWsService(
    getAccessToken: () => ref.read(accessTokenProvider),
  );
  ref.onDispose(() => service.dispose());
  return service;
});
