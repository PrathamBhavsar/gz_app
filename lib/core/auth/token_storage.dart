import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _kRefreshTokenKey = 'gz_refresh_token';
const _kUserIdKey = 'gz_user_id';
const _kActiveStoreIdKey = 'gz_active_store_id';
const _kUserTypeKey = 'gz_user_type'; // 'player' | 'admin'
const _kAdminRoleKey = 'gz_admin_role'; // 'super_admin' | 'admin' | 'staff'
const _kAdminStoreIdKey =
    'gz_admin_store_id'; // Admin's store ID (separate from player activeStoreId)

// ─── In-memory access token ────────────────────────────────────────────────
// Kept in Riverpod state — never persisted (cleared on app restart = safe)
final accessTokenProvider = StateProvider<String?>((ref) => null);

// ─── Active Store Context ───────────────────────────────────────────────────
// Persists across app restarts. Used by all store-scoped API calls.
final activeStoreIdProvider = StateProvider<String?>((ref) => null);

// ─── Token Storage Service ─────────────────────────────────────────────────
// Wraps flutter_secure_storage for refresh token + userId + activeStoreId

class TokenStorage {
  final FlutterSecureStorage _storage;

  TokenStorage(this._storage);

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _kRefreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _kRefreshTokenKey);
  }

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _kUserIdKey, value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _kUserIdKey);
  }

  Future<void> saveActiveStoreId(String storeId) async {
    await _storage.write(key: _kActiveStoreIdKey, value: storeId);
  }

  Future<String?> getActiveStoreId() async {
    return await _storage.read(key: _kActiveStoreIdKey);
  }

  // ─── Admin-specific storage ────────────────────────────────────────

  Future<void> saveUserType(String userType) async {
    await _storage.write(key: _kUserTypeKey, value: userType);
  }

  Future<String?> getUserType() async {
    return await _storage.read(key: _kUserTypeKey);
  }

  Future<void> saveAdminRole(String role) async {
    await _storage.write(key: _kAdminRoleKey, value: role);
  }

  Future<String?> getAdminRole() async {
    return await _storage.read(key: _kAdminRoleKey);
  }

  Future<void> saveAdminStoreId(String storeId) async {
    await _storage.write(key: _kAdminStoreIdKey, value: storeId);
  }

  Future<String?> getAdminStoreId() async {
    return await _storage.read(key: _kAdminStoreIdKey);
  }

  Future<void> clearAll() async {
    await _storage.delete(key: _kRefreshTokenKey);
    await _storage.delete(key: _kUserIdKey);
    // Keep activeStoreId across logouts? No — clear it too.
    await _storage.delete(key: _kActiveStoreIdKey);
    // Clear admin-specific keys too
    await _storage.delete(key: _kUserTypeKey);
    await _storage.delete(key: _kAdminRoleKey);
    await _storage.delete(key: _kAdminStoreIdKey);
  }
}

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage(const FlutterSecureStorage());
});
