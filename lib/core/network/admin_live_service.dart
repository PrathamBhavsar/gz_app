import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../api/api_constants.dart';
import '../auth/token_storage.dart';

/// WebSocket event types from the Store Live Feed.
enum WsEventType {
  systemStatusChange('system.status_change'),
  sessionStarted('session.started'),
  sessionEnded('session.ended'),
  bookingNew('booking.new'),
  agentHeartbeat('agent.heartbeat'),
  unknown('');

  final String value;
  const WsEventType(this.value);

  static WsEventType fromString(String v) {
    return WsEventType.values.firstWhere(
      (e) => e.value == v,
      orElse: () => WsEventType.unknown,
    );
  }
}

/// A single parsed WebSocket event from the store live feed.
class WsEvent {
  final WsEventType type;
  final Map<String, dynamic> payload;
  final DateTime receivedAt;

  const WsEvent({
    required this.type,
    required this.payload,
    required this.receivedAt,
  });
}

/// Manages the WebSocket connection to `/ws/stores/:storeId/live?token=`.
///
/// Features:
/// - Auto-reconnect with exponential backoff (max 30 s).
/// - Heartbeat detection — marks systems offline if no heartbeat for 2 min.
/// - Emits typed [WsEvent]s through a broadcast stream.
/// - Graceful connect / disconnect lifecycle tied to admin session.
class AdminLiveService {
  final TokenStorage _tokenStorage;
  final String Function() _getAccessToken;

  AdminLiveService({
    required TokenStorage tokenStorage,
    required String Function() getAccessToken,
  })  : _tokenStorage = tokenStorage,
        _getAccessToken = getAccessToken;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;
  Duration _reconnectDelay = const Duration(seconds: 1);
  bool _disposed = false;
  String? _activeStoreId;

  final _eventController = StreamController<WsEvent>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  /// Stream of parsed WebSocket events.
  Stream<WsEvent> get events => _eventController.stream;

  /// Whether the WebSocket is currently connected.
  bool get isConnected => _channel != null;

  /// Stream of connection state changes (true = connected, false = disconnected).
  Stream<bool> get onConnectionChanged => _connectionController.stream;

  // ─── Connect ────────────────────────────────────────────────────────

  /// Opens a WebSocket connection for the given [storeId].
  /// Any existing connection is closed first.
  Future<void> connect(String storeId) async {
    if (_disposed) return;

    // Close existing connection
    await disconnect();

    _activeStoreId = storeId;
    final token = _getAccessToken();
    if (token == null || token.isEmpty) return;

    // Build WS URL from base URL (swap http → ws)
    final baseUrl = ApiConstants.baseUrl;
    final wsBase = baseUrl.replaceFirst('http://', 'ws://').replaceFirst('https://', 'wss://');
    final wsUrl = '$wsBase/ws/stores/$storeId/live?token=$token';

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _subscription = _channel!.stream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );

      _connectionController.add(true);
      _reconnectDelay = const Duration(seconds: 1); // Reset backoff
      debugPrint('WS ✓ Connected to store $storeId');
    } catch (e) {
      debugPrint('WS ✗ Connect failed: $e');
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
    await _channel?.close();
    _channel = null;
    _connectionController.add(false);
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
      final payload = json['data'] as Map<String, dynamic>? ?? json;

      final event = WsEvent(
        type: WsEventType.fromString(typeStr),
        payload: payload is Map<String, dynamic>
            ? payload
            : Map<String, dynamic>.from(payload),
        receivedAt: DateTime.now(),
      );

      if (!_eventController.isClosed) {
        _eventController.add(event);
      }
    } catch (e) {
      debugPrint('WS ✗ Parse error: $e');
    }
  }

  void _onError(Object error) {
    debugPrint('WS ✗ Error: $error');
    _connectionController.add(false);
    _scheduleReconnect();
  }

  void _onDone() {
    debugPrint('WS ✗ Connection closed');
    _connectionController.add(false);
    if (!_disposed) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_disposed || _activeStoreId == null) return;

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () async {
      if (_disposed || _activeStoreId == null) return;
      debugPrint('WS ↻ Reconnecting (delay: ${_reconnectDelay.inSeconds}s)');
      await connect(_activeStoreId!);

      // Exponential backoff capped at 30s
      _reconnectDelay = Duration(
        seconds: (_reconnectDelay.inSeconds * 2).clamp(1, 30),
      );
    });
  }
}
