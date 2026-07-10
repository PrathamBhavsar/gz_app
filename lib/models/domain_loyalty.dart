import 'enums.dart';

class CreditLedgerModel {
  final String? id;
  final String? storeId;
  final String? userId;
  final CreditTransactionType? transactionType;
  final double? amount;
  final double? balanceAfter;
  final String? sourceId;
  final String? sourceType;
  final String? description;
  final DateTime? expiresAt;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;

  const CreditLedgerModel({
    this.id,
    this.storeId,
    this.userId,
    this.transactionType,
    this.amount,
    this.balanceAfter,
    this.sourceId,
    this.sourceType,
    this.description,
    this.expiresAt,
    this.metadata,
    this.createdAt,
  });

  factory CreditLedgerModel.fromJson(Map<String, dynamic> json) =>
      CreditLedgerModel(
        id: json['id']?.toString(),
        storeId: (json['store_id'] ?? json['storeId'])?.toString(),
        userId: (json['user_id'] ?? json['userId'])?.toString(),
        transactionType: (json['transaction_type'] ?? json['transactionType'])
            ?.toString()
            .toCreditTransactionType(),
        amount: double.tryParse(json['amount']?.toString() ?? ''),
        balanceAfter: double.tryParse(
          (json['balance_after'] ?? json['balanceAfter'])?.toString() ?? '',
        ),
        sourceId: (json['source_id'] ?? json['sourceId'])?.toString(),
        sourceType: (json['source_type'] ?? json['sourceType'])?.toString(),
        description: json['description']?.toString(),
        expiresAt: (json['expires_at'] ?? json['expiresAt']) != null
            ? DateTime.tryParse(
                (json['expires_at'] ?? json['expiresAt']).toString(),
              )
            : null,
        metadata: json['metadata'] as Map<String, dynamic>?,
        createdAt: (json['created_at'] ?? json['createdAt']) != null
            ? DateTime.tryParse(
                (json['created_at'] ?? json['createdAt']).toString(),
              )
            : null,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'user_id': userId,
    'transaction_type': transactionType?.name,
    'amount': amount,
    'balance_after': balanceAfter,
    'source_id': sourceId,
    'source_type': sourceType,
    'description': description,
    'expires_at': expiresAt?.toIso8601String(),
    'metadata': metadata,
    'created_at': createdAt?.toIso8601String(),
  };
}

class CreditBalanceModel {
  final String? storeId;
  final String? userId;
  final String? storeName;
  final double? currentBalance;
  final double? availableBalance;
  final DateTime? lastTransactionAt;

  const CreditBalanceModel({
    this.storeId,
    this.userId,
    this.storeName,
    this.currentBalance,
    this.availableBalance,
    this.lastTransactionAt,
  });

  factory CreditBalanceModel.fromJson(
    Map<String, dynamic> json,
  ) => CreditBalanceModel(
    storeId: (json['store_id'] ?? json['storeId'])?.toString(),
    userId: (json['user_id'] ?? json['userId'])?.toString(),
    storeName: json['store_name']?.toString() ?? json['storeName']?.toString(),
    currentBalance: double.tryParse(
      (json['current_balance'] ?? json['balance'])?.toString() ?? '',
    ),
    availableBalance: double.tryParse(
      (json['available_balance'] ?? json['current_balance'] ?? json['balance'])
              ?.toString() ??
          '',
    ),
    lastTransactionAt:
        (json['last_transaction_at'] ?? json['lastTransactionAt']) != null
        ? DateTime.tryParse(
            (json['last_transaction_at'] ?? json['lastTransactionAt'])
                .toString(),
          )
        : null,
  );

  Map<String, dynamic> toJson() => {
    'store_id': storeId,
    'user_id': userId,
    'store_name': storeName,
    'current_balance': currentBalance,
    'available_balance': availableBalance,
    'last_transaction_at': lastTransactionAt?.toIso8601String(),
  };
}

class CampaignModel {
  final String? id;
  final String? storeId;
  final String? name;
  final CampaignType? campaignType;
  final CampaignStatus? status;
  final double? value;
  final int? minTier;
  final int? maxRedemptions;
  final int? currentRedemptions;
  final int? maxPerUser;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final List<String>? applicableSystemTypes;
  final String? description;
  final String? terms;
  final Map<String, dynamic>? metadata;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CampaignModel({
    this.id,
    this.storeId,
    this.name,
    this.campaignType,
    this.status,
    this.value,
    this.minTier,
    this.maxRedemptions,
    this.currentRedemptions,
    this.maxPerUser,
    this.validFrom,
    this.validUntil,
    this.applicableSystemTypes,
    this.description,
    this.terms,
    this.metadata,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) => CampaignModel(
    id: json['id']?.toString(),
    storeId: (json['store_id'] ?? json['storeId'])?.toString(),
    name: json['name']?.toString(),
    campaignType: (json['campaign_type'] ?? json['campaignType'] ?? json['type'])
        ?.toString()
        .toCampaignType(),
    status: json['status']?.toString().toCampaignStatus(),
    value: double.tryParse(
      (json['value'] ?? json['discount_value'] ?? json['discountValue'])
              ?.toString() ??
          '',
    ),
    minTier: (json['min_tier'] ?? json['minTier']) as int?,
    maxRedemptions: (json['max_redemptions'] ?? json['maxRedemptions']) as int?,
    currentRedemptions:
        (json['current_redemptions'] ??
                json['currentRedemptions'] ??
                json['redemption_count'] ??
                json['redemptionCount'])
            as int?,
    maxPerUser: (json['max_per_user'] ?? json['maxPerUser']) as int?,
    validFrom: (json['valid_from'] ?? json['validFrom']) != null
        ? DateTime.tryParse((json['valid_from'] ?? json['validFrom']).toString())
        : null,
    validUntil: (json['valid_until'] ?? json['validUntil']) != null
        ? DateTime.tryParse(
            (json['valid_until'] ?? json['validUntil']).toString(),
          )
        : null,
    applicableSystemTypes:
        (json['applicable_system_types'] ?? json['applicableSystemTypes'])
            is List<dynamic>
        ? ((json['applicable_system_types'] ?? json['applicableSystemTypes'])
                  as List<dynamic>)
              .map((e) => e.toString())
              .toList()
        : null,
    description: json['description']?.toString(),
    terms: json['terms']?.toString(),
    metadata: json['metadata'] as Map<String, dynamic>?,
    createdBy: json['created_by']?.toString() ?? json['createdBy']?.toString(),
    createdAt: (json['created_at'] ?? json['createdAt']) != null
        ? DateTime.tryParse(
            (json['created_at'] ?? json['createdAt']).toString(),
          )
        : null,
    updatedAt: (json['updated_at'] ?? json['updatedAt']) != null
        ? DateTime.tryParse(
            (json['updated_at'] ?? json['updatedAt']).toString(),
          )
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'name': name,
    'campaign_type': campaignType?.name,
    'status': status?.name,
    'value': value,
    'min_tier': minTier,
    'max_redemptions': maxRedemptions,
    'current_redemptions': currentRedemptions,
    'max_per_user': maxPerUser,
    'valid_from': validFrom?.toIso8601String(),
    'valid_until': validUntil?.toIso8601String(),
    'applicable_system_types': applicableSystemTypes,
    'description': description,
    'terms': terms,
    'metadata': metadata,
    'created_by': createdBy,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

class CampaignRedemptionModel {
  final String? id;
  final String? storeId;
  final String? campaignId;
  final String? userId;
  final String? sessionId;
  final String? billingId;
  final double? discountAmount;
  final DateTime? redeemedAt;
  final Map<String, dynamic>? metadata;

  const CampaignRedemptionModel({
    this.id,
    this.storeId,
    this.campaignId,
    this.userId,
    this.sessionId,
    this.billingId,
    this.discountAmount,
    this.redeemedAt,
    this.metadata,
  });

  factory CampaignRedemptionModel.fromJson(Map<String, dynamic> json) =>
      CampaignRedemptionModel(
        id: json['id']?.toString(),
        storeId: (json['store_id'] ?? json['storeId'])?.toString(),
        campaignId: (json['campaign_id'] ?? json['campaignId'])?.toString(),
        userId: (json['user_id'] ?? json['userId'])?.toString(),
        sessionId: (json['session_id'] ?? json['sessionId'])?.toString(),
        billingId: (json['billing_id'] ?? json['billingId'])?.toString(),
        discountAmount: double.tryParse(
          (json['discount_amount'] ?? json['discountAmount'])?.toString() ??
              '',
        ),
        redeemedAt: (json['redeemed_at'] ?? json['redeemedAt']) != null
            ? DateTime.tryParse(
                (json['redeemed_at'] ?? json['redeemedAt']).toString(),
              )
            : null,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'campaign_id': campaignId,
    'user_id': userId,
    'session_id': sessionId,
    'billing_id': billingId,
    'discount_amount': discountAmount,
    'redeemed_at': redeemedAt?.toIso8601String(),
    'metadata': metadata,
  };
}
