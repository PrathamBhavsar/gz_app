import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/pricing_repository.dart';
import '../data/repositories/system_types_repository.dart';
import 'admin_management_models.dart';

class AdminPricingNotifier extends AsyncNotifier<AdminPricingData> {
  @override
  Future<AdminPricingData> build() => _load();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<AdminPricingData> _load() async {
    final pricingRepo = ref.read(pricingRepositoryProvider);
    final systemTypesRepo = ref.read(systemTypesRepositoryProvider);
    final rules = await pricingRepo.fetchRules();
    final systemTypes = await systemTypesRepo.fetchSystemTypes();
    return AdminPricingData(
      rules: rules,
      systemTypes: systemTypes,
      loadedAt: DateTime.now(),
    );
  }
}

final adminPricingNotifierProvider =
    AsyncNotifierProvider<AdminPricingNotifier, AdminPricingData>(
      AdminPricingNotifier.new,
    );
