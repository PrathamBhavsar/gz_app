import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/network_checker.dart';
import '../../../../models/domain_loyalty.dart';
import '../../../../models/core.dart';

class WalletTransactionsPage {
  const WalletTransactionsPage({
    required this.transactions,
    required this.page,
    required this.hasMore,
    this.totalItems,
  });

  final List<CreditLedgerModel> transactions;
  final int page;
  final bool hasMore;
  final int? totalItems;
}

class WalletRepository {
  WalletRepository(this._api, this._net, this._ref);

  final ApiClient _api;
  final NetworkChecker _net;
  final Ref _ref;

  Future<CreditBalanceModel> fetchBalance() async {
    await _net.assertConnection();

    final raw = await _api.get(_store(ApiConstants.playerCreditsBalance));
    final payload = _extractObjectPayload(
      _asMap(raw),
      dataKeys: const ['balance', 'creditBalance'],
    );
    return CreditBalanceModel.fromJson(payload);
  }

  Future<WalletTransactionsPage> fetchTransactions({
    int page = 1,
    int limit = 20,
  }) async {
    await _net.assertConnection();

    final raw = await _api.get(
      _withQuery(_store(ApiConstants.playerCreditsTransactions), {
        'page': '$page',
        'limit': '$limit',
      }),
    );
    final map = _asMap(raw);
    final payload = _extractListPayload(
      map,
      dataKeys: const ['transactions', 'items', 'ledger'],
    );
    final pagination = _extractPagination(map);
    final currentPage = pagination?.currentPage ?? page;
    final totalPages = pagination?.totalPages;
    final hasMore = totalPages == null
        ? payload.length >= limit
        : currentPage < totalPages;

    return WalletTransactionsPage(
      transactions: payload
          .map((item) => CreditLedgerModel.fromJson(_asMap(item)))
          .toList(growable: false),
      page: currentPage,
      hasMore: hasMore,
      totalItems: pagination?.totalItems,
    );
  }

  Future<List<CampaignModel>> fetchActiveCampaigns() async {
    await _net.assertConnection();

    final raw = await _api.get(_store(ApiConstants.playerCampaignsActive));
    final payload = _extractListPayload(
      _asMap(raw),
      dataKeys: const ['campaigns', 'items'],
    );
    return payload
        .map((item) => CampaignModel.fromJson(_asMap(item)))
        .toList(growable: false);
  }

  Future<CampaignModel> fetchCampaignById(String id) async {
    final campaigns = await fetchActiveCampaigns();
    for (final campaign in campaigns) {
      if (campaign.id == id) {
        return campaign;
      }
    }
    throw const ValidationException('This campaign is no longer available');
  }

  Future<String> redeemCredits(int amount) async {
    await _net.assertConnection();

    final raw = await _api.post(
      _store(ApiConstants.playerCreditsRedeem),
      body: {'amount': amount},
    );
    final map = _asMap(raw);
    return map['message']?.toString() ?? 'Credits redeemed successfully';
  }

  Future<String> redeemCampaign(String campaignId) async {
    await _net.assertConnection();

    final raw = await _api.post(
      _store(ApiConstants.playerCampaignRedeem, id: campaignId),
    );
    final map = _asMap(raw);
    return map['message']?.toString() ?? 'Campaign redeemed successfully';
  }

  String _store(String template, {String? id}) {
    final storeId = _ref.read(activeStoreIdProvider);
    if (storeId == null || storeId.isEmpty) {
      throw const ValidationException('Select a store before using the wallet');
    }

    var path = template.replaceAll('{storeId}', storeId);
    if (id != null) {
      path = path.replaceAll('{id}', id);
    }
    return path;
  }

  String _withQuery(String path, Map<String, String> query) {
    if (query.isEmpty) {
      return path;
    }
    return '$path?${Uri(queryParameters: query).query}';
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
    }
    throw const ApiException(
      statusCode: 500,
      message: 'Expected object response from wallet API',
    );
  }

  List<dynamic> _extractListPayload(
    Map<String, dynamic> raw, {
    required List<String> dataKeys,
  }) {
    final data = raw['data'];
    if (data is List) {
      return data;
    }

    if (data is Map) {
      final map = _asMap(data);
      for (final key in dataKeys) {
        final nested = map[key];
        if (nested is List) {
          return nested;
        }
      }
    }

    for (final key in dataKeys) {
      final nested = raw[key];
      if (nested is List) {
        return nested;
      }
    }

    return const [];
  }

  Map<String, dynamic> _extractObjectPayload(
    Map<String, dynamic> raw, {
    required List<String> dataKeys,
  }) {
    final data = raw['data'];
    if (data is Map) {
      final map = _asMap(data);
      for (final key in dataKeys) {
        final nested = map[key];
        if (nested is Map) {
          return _asMap(nested);
        }
      }
      return map;
    }

    for (final key in dataKeys) {
      final nested = raw[key];
      if (nested is Map) {
        return _asMap(nested);
      }
    }

    return raw;
  }

  PaginationMeta? _extractPagination(Map<String, dynamic> raw) {
    final paginationRaw = raw['pagination'] ?? raw['meta'];
    if (paginationRaw is! Map) {
      return null;
    }
    final map = _asMap(paginationRaw);
    if (map.containsKey('currentPage') ||
        map.containsKey('totalPages') ||
        map.containsKey('totalItems') ||
        map.containsKey('itemsPerPage')) {
      return PaginationMeta.fromJson(map);
    }
    return PaginationMeta(
      currentPage: _toInt(map['page']),
      totalPages: _toInt(map['totalPages']),
      totalItems: _toInt(map['total']),
      itemsPerPage: _toInt(map['limit']),
    );
  }

  int? _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '');
  }
}

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepository(
    ref.watch(apiClientProvider),
    ref.watch(networkCheckerProvider),
    ref,
  );
});
