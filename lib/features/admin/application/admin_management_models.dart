import '../../../../models/domain_admin.dart';
import '../../../../models/domain_billing.dart';
import '../../../../models/domain_global.dart';
import '../../../../models/domain_loyalty.dart';
import '../../../../models/domain_systems.dart';
import '../../../../models/enums.dart';

class AdminPricingData {
  const AdminPricingData({
    required this.rules,
    required this.systemTypes,
    required this.loadedAt,
  });

  final List<PricingRuleModel> rules;
  final List<SystemTypeModel> systemTypes;
  final DateTime loadedAt;

  PricingRuleModel? ruleById(String id) {
    for (final rule in rules) {
      if (rule.id == id) {
        return rule;
      }
    }
    return null;
  }

  String systemTypeName(String? id) {
    if (id == null || id.isEmpty) {
      return 'All systems';
    }
    for (final type in systemTypes) {
      if (type.id == id) {
        return type.name ?? 'System type';
      }
    }
    return 'System type';
  }
}

class AdminBillingData {
  const AdminBillingData({
    required this.selectedFilter,
    required this.ledger,
    required this.payments,
    required this.summary,
    required this.reconciliation,
    required this.loadedAt,
  });

  final String selectedFilter;
  final List<BillingLedgerModel> ledger;
  final List<PaymentModel> payments;
  final RevenueSummaryModel? summary;
  final ReconciliationModel? reconciliation;
  final DateTime loadedAt;
}

class AdminCampaignData {
  const AdminCampaignData({
    required this.campaigns,
    required this.systemTypes,
    required this.selectedFilter,
    required this.loadedAt,
  });

  final List<CampaignModel> campaigns;
  final List<SystemTypeModel> systemTypes;
  final String selectedFilter;
  final DateTime loadedAt;

  List<CampaignModel> get filtered {
    if (selectedFilter == 'All') return campaigns;
    final status = selectedFilter.toLowerCase() == 'active'
        ? CampaignStatus.active
        : selectedFilter.toLowerCase() == 'paused'
        ? CampaignStatus.paused
        : null;
    if (status == null) return campaigns;
    return campaigns.where((c) => c.status == status).toList();
  }

  CampaignModel? findById(String id) {
    for (final c in campaigns) {
      if (c.id == id) return c;
    }
    return null;
  }
}

class AdminDisputeData {
  const AdminDisputeData({
    required this.disputes,
    required this.selectedFilter,
    required this.loadedAt,
  });

  final List<BillingDisputeModel> disputes;
  final String selectedFilter;
  final DateTime loadedAt;

  List<BillingDisputeModel> get filtered {
    if (selectedFilter == 'All') return disputes;
    final status = switch (selectedFilter) {
      'Open' => DisputeStatus.open,
      'In Review' => DisputeStatus.underReview,
      'Resolved' => DisputeStatus.resolved,
      _ => null,
    };
    if (status == null) return disputes;
    return disputes.where((d) => d.status == status).toList();
  }
}

class AdminCreditsData {
  const AdminCreditsData({
    this.selectedUserId,
    this.user,
    this.balance,
    this.transactions = const [],
    this.loadedAt,
  });

  final String? selectedUserId;
  final UserModel? user;
  final CreditBalanceModel? balance;
  final List<CreditLedgerModel> transactions;
  final DateTime? loadedAt;

  bool get hasSelection =>
      selectedUserId != null && selectedUserId!.trim().isNotEmpty;
}
