import '../../../../models/domain_loyalty.dart';
import '../../../../models/enums.dart';
import '../../../../shared/widgets/gz_tag.dart';
import '../../booking/presentation/booking_presenters.dart';
import '../../sessions/application/session_ui_models.dart'
    show formatReadableDate, formatReadableDateLong;

class WalletData {
  const WalletData({
    required this.balance,
    required this.recentTransactions,
    required this.campaigns,
  });

  final CreditBalanceModel balance;
  final List<CreditLedgerModel> recentTransactions;
  final List<CampaignModel> campaigns;
}

class CreditHistoryState {
  const CreditHistoryState({
    required this.entries,
    required this.page,
    required this.hasMore,
    required this.isLoadingMore,
  });

  final List<CreditLedgerModel> entries;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  CreditHistoryState copyWith({
    List<CreditLedgerModel>? entries,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return CreditHistoryState(
      entries: entries ?? this.entries,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

String walletCreditsLabel(double? value) {
  final amount = value ?? 0;
  if (amount == amount.roundToDouble()) {
    return amount.toInt().toString();
  }
  return amount.toStringAsFixed(0);
}

String walletCreditsAmountLabel(CreditLedgerModel entry) {
  final amount = entry.amount ?? 0;
  final prefix = amount >= 0 ? '+' : '−';
  return '$prefix${amount.abs().round()}';
}

bool isCreditGain(CreditLedgerModel entry) => (entry.amount ?? 0) >= 0;

String creditEntryLabel(CreditLedgerModel entry) {
  if (entry.description != null && entry.description!.trim().isNotEmpty) {
    return entry.description!.trim();
  }
  return switch (entry.transactionType) {
    CreditTransactionType.earned => 'Booking credit',
    CreditTransactionType.redeemed => 'Redemption',
    CreditTransactionType.bonus => 'Bonus credits',
    CreditTransactionType.adminAdjust => 'Manual adjustment',
    CreditTransactionType.expired => 'Expired credits',
    CreditTransactionType.refund => 'Refund credits',
    null => 'Credit update',
  };
}

String creditEntryDateLabel(CreditLedgerModel entry) {
  return formatReadableDate(entry.createdAt);
}

GzTagKind campaignTagKind(CampaignModel campaign) {
  final status = campaign.status;
  if (status == CampaignStatus.active) {
    return GzTagKind.ok;
  }
  if (status == CampaignStatus.expired || _isExpired(campaign)) {
    return GzTagKind.mute;
  }
  if (status == CampaignStatus.paused || status == CampaignStatus.cancelled) {
    return GzTagKind.warn;
  }
  return GzTagKind.info;
}

String campaignStatusLabel(CampaignModel campaign) {
  final status = campaign.status;
  if (_isExpired(campaign)) {
    return 'Expired';
  }
  return switch (status) {
    CampaignStatus.active => 'Active',
    CampaignStatus.scheduled => 'Scheduled',
    CampaignStatus.paused => 'Paused',
    CampaignStatus.expired => 'Expired',
    CampaignStatus.cancelled => 'Cancelled',
    CampaignStatus.draft => 'Draft',
    null => 'Offer',
  };
}

String campaignValidityLabel(CampaignModel campaign) {
  final validUntil = campaign.validUntil;
  if (validUntil == null) {
    return 'Ongoing';
  }
  if (_isExpired(campaign)) {
    return 'Ended ${formatReadableDate(validUntil)}';
  }
  return 'Expires ${formatReadableDate(validUntil)}';
}

String campaignLongValidityLabel(CampaignModel campaign) {
  final from = campaign.validFrom;
  final until = campaign.validUntil;
  if (from == null && until == null) {
    return 'Ongoing';
  }
  if (from != null && until != null) {
    return '${formatReadableDateLong(from)} – ${formatReadableDateLong(until)}';
  }
  if (from != null) {
    return 'From ${formatReadableDateLong(from)}';
  }
  return 'Until ${formatReadableDateLong(until)}';
}

String campaignBenefitLabel(CampaignModel campaign) {
  return campaignValueLabel(campaign);
}

String campaignEligibilityLabel(CampaignModel campaign) {
  final parts = <String>[];
  if (campaign.minTier != null && campaign.minTier! > 0) {
    parts.add('Tier ${campaign.minTier}+');
  }
  if (campaign.maxPerUser != null && campaign.maxPerUser! > 0) {
    parts.add(
      'Max ${campaign.maxPerUser} use${campaign.maxPerUser == 1 ? '' : 's'} per user',
    );
  }
  if (parts.isEmpty) {
    return 'Open to eligible players';
  }
  return parts.join(' · ');
}

String campaignApplicableSystemsLabel(CampaignModel campaign) {
  final systems = campaign.applicableSystemTypes;
  if (systems == null || systems.isEmpty) {
    return 'All systems';
  }
  return systems.join(', ');
}

List<String> campaignHowItWorks(CampaignModel campaign) {
  return [
    'Benefit: ${campaignBenefitLabel(campaign)}',
    'Validity: ${campaignLongValidityLabel(campaign)}',
    'Eligible systems: ${campaignApplicableSystemsLabel(campaign)}',
    if (campaign.terms != null && campaign.terms!.trim().isNotEmpty)
      campaign.terms!.trim(),
  ];
}

bool campaignCanRedeem(CampaignModel campaign) {
  if (_isExpired(campaign)) {
    return false;
  }
  return campaign.status == null || campaign.status == CampaignStatus.active;
}

bool _isExpired(CampaignModel campaign) {
  final validUntil = campaign.validUntil;
  if (validUntil == null) {
    return false;
  }
  return validUntil.isBefore(DateTime.now());
}
