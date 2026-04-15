import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  /// Attempts a real DNS/socket connection to verify gateway access.
  Future<bool> _ping() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
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
