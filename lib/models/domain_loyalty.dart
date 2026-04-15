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

  const CreditLedgerModel({this.id, this.storeId, this.userId, this.transactionType, this.amount, this.balanceAfter, this.sourceId, this.sourceType, this.description, this.expiresAt, this.metadata, this.createdAt});

  factory CreditLedgerModel.fromJson(Map<String, dynamic> json) => CreditLedgerModel(
    id: json['id']?.toString(),
    storeId: json['store_id']?.toString(),
    userId: json['user_id']?.toString(),
    transactionType: json['transaction_type']?.toString().toCreditTransactionType(),
    amount: double.tryParse(json['amount']?.toString() ?? ''),
    balanceAfter: double.tryParse(json['balance_after']?.toString() ?? ''),
    sourceId: json['source_id']?.toString(),
    sourceType: json['source_type']?.toString(),
    description: json['description']?.toString(),
    expiresAt: json['expires_at'] != null ? DateTime.tryParse(json['expires_at'].toString()) : null,
    metadata: json['metadata'] as Map<String, dynamic>?,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'store_id': storeId, 'user_id': userId, 'transaction_type': transactionType?.name, 'amount': amount,
    'balance_after': balanceAfter, 'source_id': sourceId, 'source_type': sourceType, 'description': description,
    'expires_at': expiresAt?.toIso8601String(), 'metadata': metadata, 'created_at': createdAt?.toIso8601String(),
  };
}

class CreditBalanceModel {
  final String? storeId;
  final String? userId;
  final double? currentBalance;
  final double? availableBalance;
  final DateTime? lastTransactionAt;

  const CreditBalanceModel({this.storeId, this.userId, this.currentBalance, this.availableBalance, this.lastTransactionAt});

  factory CreditBalanceModel.fromJson(Map<String, dynamic> json) => CreditBalanceModel(
    storeId: json['store_id']?.toString(),
    userId: json['user_id']?.toString(),
    currentBalance: double.tryParse(json['current_balance']?.toString() ?? ''),
    availableBalance: double.tryParse(json['available_balance']?.toString() ?? ''),
    lastTransactionAt: json['last_transaction_at'] != null ? DateTime.tryParse(json['last_transaction_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'store_id': storeId, 'user_id': userId, 'current_balance': currentBalance, 'available_balance': availableBalance,
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

  const CampaignModel({this.id, this.storeId, this.name, this.campaignType, this.status, this.value, this.minTier, this.maxRedemptions, this.currentRedemptions, this.maxPerUser, this.validFrom, this.validUntil, this.applicableSystemTypes, this.description, this.terms, this.metadata, this.createdBy, this.createdAt, this.updatedAt});

  factory CampaignModel.fromJson(Map<String, dynamic> json) => CampaignModel(
    id: json['id']?.toString(),
    storeId: json['store_id']?.toString(),
    name: json['name']?.toString(),
    campaignType: json['campaign_type']?.toString().toCampaignType(),
    status: json['status']?.toString().toCampaignStatus(),
    value: double.tryParse(json['value']?.toString() ?? ''),
    minTier: json['min_tier'] as int?,
    maxRedemptions: json['max_redemptions'] as int?,
    currentRedemptions: json['current_redemptions'] as int?,
    maxPerUser: json['max_per_user'] as int?,
    validFrom: json['valid_from'] != null ? DateTime.tryParse(json['valid_from'].toString()) : null,
    validUntil: json['valid_until'] != null ? DateTime.tryParse(json['valid_until'].toString()) : null,
    applicableSystemTypes: (json['applicable_system_types'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
    description: json['description']?.toString(),
    terms: json['terms']?.toString(),
    metadata: json['metadata'] as Map<String, dynamic>?,
    createdBy: json['created_by']?.toString(),
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'store_id': storeId, 'name': name, 'campaign_type': campaignType?.name, 'status': status?.name,
    'value': value, 'min_tier': minTier, 'max_redemptions': maxRedemptions, 'current_redemptions': currentRedemptions,
    'max_per_user': maxPerUser, 'valid_from': validFrom?.toIso8601String(), 'valid_until': validUntil?.toIso8601String(),
    'applicable_system_types': applicableSystemTypes, 'description': description, 'terms': terms, 'metadata': metadata,
    'created_by': createdBy, 'created_at': createdAt?.toIso8601String(), 'updated_at': updatedAt?.toIso8601String(),
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

  const CampaignRedemptionModel({this.id, this.storeId, this.campaignId, this.userId, this.sessionId, this.billingId, this.discountAmount, this.redeemedAt, this.metadata});

  factory CampaignRedemptionModel.fromJson(Map<String, dynamic> json) => CampaignRedemptionModel(
    id: json['id']?.toString(),
    storeId: json['store_id']?.toString(),
    campaignId: json['campaign_id']?.toString(),
    userId: json['user_id']?.toString(),
    sessionId: json['session_id']?.toString(),
    billingId: json['billing_id']?.toString(),
    discountAmount: double.tryParse(json['discount_amount']?.toString() ?? ''),
    redeemedAt: json['redeemed_at'] != null ? DateTime.tryParse(json['redeemed_at'].toString()) : null,
    metadata: json['metadata'] as Map<String, dynamic>?,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'store_id': storeId, 'campaign_id': campaignId, 'user_id': userId, 'session_id': sessionId,
    'billing_id': billingId, 'discount_amount': discountAmount, 'redeemed_at': redeemedAt?.toIso8601String(),
    'metadata': metadata,
  };
}
