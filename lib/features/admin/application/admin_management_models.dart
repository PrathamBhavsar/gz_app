import '../../../../models/domain_admin.dart';
import '../../../../models/domain_analytics.dart';
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

class AdminAnalyticsDashboardData {
  const AdminAnalyticsDashboardData({
    required this.dashboard,
    required this.revenueRows,
    required this.selectedPeriod,
    required this.loadedAt,
  });

  final AnalyticsDashboardModel dashboard;
  final List<RevenueAnalyticsRow> revenueRows;
  final String selectedPeriod;
  final DateTime loadedAt;

  List<double> get barHeights {
    if (revenueRows.isEmpty) return const [];
    final values = revenueRows
        .map((r) => double.tryParse(r.revenue ?? '0') ?? 0.0)
        .toList();
    final max = values.reduce((a, b) => a > b ? a : b);
    if (max == 0) return values.map((_) => 0.0).toList();
    return values.map((v) => (v / max).clamp(0.05, 1.0)).toList();
  }

  String get totalRevenue {
    if (revenueRows.isEmpty) {
      return dashboard.totalRevenue ?? '—';
    }
    final total = revenueRows.fold<double>(
      0,
      (sum, r) => sum + (double.tryParse(r.revenue ?? '0') ?? 0.0),
    );
    return '₹${total.toStringAsFixed(0)}';
  }
}

class AdminRevenueData {
  const AdminRevenueData({
    required this.model,
    required this.selectedFilter,
    required this.loadedAt,
  });

  final RevenueAnalyticsModel model;
  final String selectedFilter;
  final DateTime loadedAt;

  List<RevenueAnalyticsRow> get rows => model.data ?? const [];

  String get totalRevenue {
    final total = rows.fold<double>(
      0,
      (sum, r) => sum + (double.tryParse(r.revenue ?? '0') ?? 0.0),
    );
    return '₹${total.toStringAsFixed(0)}';
  }
}

class AdminUtilizationData {
  const AdminUtilizationData({
    required this.model,
    required this.selectedFilter,
    required this.loadedAt,
  });

  final UtilizationModel model;
  final String selectedFilter;
  final DateTime loadedAt;

  List<UtilizationHourModel> get sortedHours {
    final hours = List<UtilizationHourModel>.from(model.data ?? const []);
    hours.sort((a, b) => (a.hourOfDay ?? 0).compareTo(b.hourOfDay ?? 0));
    return hours;
  }

  UtilizationHourModel? get peakHour {
    final hours = sortedHours;
    if (hours.isEmpty) return null;
    return hours.reduce(
      (a, b) =>
          (a.activeSessionsPeak ?? 0) >= (b.activeSessionsPeak ?? 0) ? a : b,
    );
  }

  double get avgOccupancy {
    final hours = sortedHours;
    if (hours.isEmpty) return 0.0;
    final total = hours.fold<double>(
      0,
      (sum, h) =>
          sum +
          ((h.systemsInUse ?? 0) / ((h.totalSystems ?? 1).clamp(1, 999))),
    );
    return total / hours.length;
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
