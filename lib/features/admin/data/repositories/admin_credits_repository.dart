import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/domain_global.dart';
import '../../../../models/domain_loyalty.dart';
import 'admin_store_repository_support.dart';

class AdminCreditAccountPayload {
  const AdminCreditAccountPayload({
    required this.userId,
    required this.balance,
    required this.transactions,
    this.user,
  });

  final String userId;
  final UserModel? user;
  final CreditBalanceModel balance;
  final List<CreditLedgerModel> transactions;
}

class AdminCreditsRepository {
  AdminCreditsRepository(this._api, this._net, this._storage);

  final ApiClient _api;
  final NetworkChecker _net;
  final TokenStorage _storage;

  Future<AdminCreditAccountPayload> fetchAccount(String userId) async {
    await _net.assertConnection();

    final balanceRaw = await _api.get(
      await adminStorePath(
        _storage,
        ApiConstants.creditsUserBalance.replaceAll('{userId}', userId),
      ),
    );
    final transactionsRaw = await _api.get(
      await adminStorePath(
        _storage,
        ApiConstants.creditsUserTransactions.replaceAll('{userId}', userId),
      ),
    );

    final balanceMap = adminStoreAsMap(
      balanceRaw,
      responseName: 'credits balance',
    );
    final balancePayload = _extractObject(
      balanceMap,
      dataKeys: const ['balance', 'creditBalance'],
    );
    final user = _extractUser(balanceMap, balancePayload);
    final txMap = adminStoreAsMap(
      transactionsRaw,
      responseName: 'credits transactions',
    );
    final transactions =
        adminStoreExtractList(
              txMap,
              dataKeys: const ['transactions', 'items', 'ledger'],
            )
            .map((item) {
              return CreditLedgerModel.fromJson(
                adminStoreAsMap(item, responseName: 'credits transactions'),
              );
            })
            .toList(growable: false);

    return AdminCreditAccountPayload(
      userId: userId,
      user: user,
      balance: CreditBalanceModel.fromJson(balancePayload),
      transactions: transactions,
    );
  }

  Future<String> adjustCredits({
    required String userId,
    required int amount,
    required String reason,
    required bool isAddition,
  }) async {
    await _net.assertConnection();

    final raw = await _api.post(
      await adminStorePath(_storage, ApiConstants.creditsAdjust),
      body: {
        'user_id': userId,
        'amount': amount,
        'reason': reason,
        'transaction_type': isAddition ? 'admin_adjust' : 'redeemed',
        'operation': isAddition ? 'add' : 'deduct',
      },
    );
    final map = adminStoreAsMap(raw, responseName: 'credits adjustment');
    return map['message']?.toString() ?? 'Credits updated';
  }

  Map<String, dynamic> _extractObject(
    Map<String, dynamic> raw, {
    required List<String> dataKeys,
  }) {
    final data = raw['data'];
    if (data is Map) {
      final map = adminStoreAsMap(data, responseName: 'credits balance');
      for (final key in dataKeys) {
        final nested = map[key];
        if (nested is Map) {
          return adminStoreAsMap(nested, responseName: 'credits balance');
        }
      }
      return map;
    }

    for (final key in dataKeys) {
      final nested = raw[key];
      if (nested is Map) {
        return adminStoreAsMap(nested, responseName: 'credits balance');
      }
    }

    return raw;
  }

  UserModel? _extractUser(
    Map<String, dynamic> raw,
    Map<String, dynamic> payload,
  ) {
    final data = raw['data'];
    if (data is Map) {
      final map = adminStoreAsMap(data, responseName: 'credits balance');
      final user = map['user'];
      if (user is Map) {
        return UserModel.fromJson(
          adminStoreAsMap(user, responseName: 'credits balance'),
        );
      }
    }

    final user = raw['user'];
    if (user is Map) {
      return UserModel.fromJson(
        adminStoreAsMap(user, responseName: 'credits balance'),
      );
    }

    if (payload['user_id'] != null ||
        payload['name'] != null ||
        payload['email'] != null ||
        payload['phone'] != null) {
      return UserModel.fromJson(payload);
    }

    return null;
  }
}

final adminCreditsRepositoryProvider = Provider<AdminCreditsRepository>((ref) {
  return AdminCreditsRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref.watch(tokenStorageProvider),
  );
});
