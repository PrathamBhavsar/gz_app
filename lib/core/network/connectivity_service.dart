import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class ConnectivityService {
  ConnectivityService() {
    _init();
  }

  final _controller = StreamController<bool>.broadcast();
  Stream<bool> get onConnectivityChanged => _controller.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  void _init() {
    Connectivity().onConnectivityChanged.listen((results) async {
      if (results.contains(ConnectivityResult.none) && results.length == 1) {
        _emit(false);
      } else {
        // Always ping — being on WiFi does NOT mean internet works
        final reachable = await _ping();
        _emit(reachable);
      }
    });
  }

  /// Call this manually to get the current real state.
  Future<bool> checkNow() async {
    final results = await Connectivity().checkConnectivity();
    if (results.contains(ConnectivityResult.none) && results.length == 1) {
      _emit(false);
      return false;
    }
    final reachable = await _ping();
    _emit(reachable);
    return reachable;
  }

  /// Pings the actual API server to verify internet + backend reachability.
  /// Uses HTTP HEAD — works over WiFi, mobile data, any connection type.
  Future<bool> _ping() async {
    try {
      final response = await http
          .head(Uri.parse('http://192.168.1.4:3000/health'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode < 500;
    } catch (_) {
      return false;
    }
  }

  void _emit(bool value) {
    _isConnected = value;
    _controller.add(value);
  }

  void dispose() => _controller.close();
}

/// Global Riverpod provider — use this everywhere
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(service.dispose);
  return service;
});

/// Stream provider for easy watching in widgets
final connectivityStreamProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).onConnectivityChanged;
});
