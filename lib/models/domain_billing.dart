import 'enums.dart';

class PricingRuleModel {
  final String? id;
  final String? storeId;
  final String? systemTypeId;
  final String? name;
  final PricingRuleType? ruleType;
  final List<int>? dayOfWeek;
  final String? startTime;
  final String? endTime;
  final double? multiplier;
  final double? fixedRate;
  final int? minTier;
  final int? priority;
  final bool? isActive;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PricingRuleModel({this.id, this.storeId, this.systemTypeId, this.name, this.ruleType, this.dayOfWeek, this.startTime, this.endTime, this.multiplier, this.fixedRate, this.minTier, this.priority, this.isActive, this.validFrom, this.validUntil, this.createdAt, this.updatedAt});

  factory PricingRuleModel.fromJson(Map<String, dynamic> json) => PricingRuleModel(
    id: json['id']?.toString(),
    storeId: json['store_id']?.toString(),
    systemTypeId: json['system_type_id']?.toString(),
    name: json['name']?.toString(),
    ruleType: json['rule_type']?.toString().toPricingRuleType(),
    dayOfWeek: (json['day_of_week'] as List<dynamic>?)?.map((e) => e as int).toList(),
    startTime: json['start_time']?.toString(),
    endTime: json['end_time']?.toString(),
    multiplier: double.tryParse(json['multiplier']?.toString() ?? ''),
    fixedRate: double.tryParse(json['fixed_rate']?.toString() ?? ''),
    minTier: json['min_tier'] as int?,
    priority: json['priority'] as int?,
    isActive: json['is_active'] as bool?,
    validFrom: json['valid_from'] != null ? DateTime.tryParse(json['valid_from'].toString()) : null,
    validUntil: json['valid_until'] != null ? DateTime.tryParse(json['valid_until'].toString()) : null,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'store_id': storeId, 'system_type_id': systemTypeId, 'name': name, 'rule_type': ruleType?.name,
    'day_of_week': dayOfWeek, 'start_time': startTime, 'end_time': endTime, 'multiplier': multiplier,
    'fixed_rate': fixedRate, 'min_tier': minTier, 'priority': priority, 'is_active': isActive,
    'valid_from': validFrom?.toIso8601String(), 'valid_until': validUntil?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(), 'updated_at': updatedAt?.toIso8601String(),
  };
}

class BillingLedgerModel {
  final String? id;
  final String? storeId;
  final String? sessionId;
  final String? userId;
  final String? systemId;
  final DateTime? billedFrom;
  final DateTime? billedUntil;
  final int? billedMinutes;
  final double? baseRate;
  final double? appliedMultiplier;
  final String? appliedRuleId;
  final double? grossAmount;
  final double? discountAmount;
  final double? netAmount;
  final String? billingReason;
  final String? notes;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;

  const BillingLedgerModel({this.id, this.storeId, this.sessionId, this.userId, this.systemId, this.billedFrom, this.billedUntil, this.billedMinutes, this.baseRate, this.appliedMultiplier, this.appliedRuleId, this.grossAmount, this.discountAmount, this.netAmount, this.billingReason, this.notes, this.metadata, this.createdAt});

  factory BillingLedgerModel.fromJson(Map<String, dynamic> json) => BillingLedgerModel(
    id: json['id']?.toString(),
    storeId: json['store_id']?.toString(),
    sessionId: json['session_id']?.toString(),
    userId: json['user_id']?.toString(),
    systemId: json['system_id']?.toString(),
    billedFrom: json['billed_from'] != null ? DateTime.tryParse(json['billed_from'].toString()) : null,
    billedUntil: json['billed_until'] != null ? DateTime.tryParse(json['billed_until'].toString()) : null,
    billedMinutes: json['billed_minutes'] as int?,
    baseRate: double.tryParse(json['base_rate']?.toString() ?? ''),
    appliedMultiplier: double.tryParse(json['applied_multiplier']?.toString() ?? ''),
    appliedRuleId: json['applied_rule_id']?.toString(),
    grossAmount: double.tryParse(json['gross_amount']?.toString() ?? ''),
    discountAmount: double.tryParse(json['discount_amount']?.toString() ?? ''),
    netAmount: double.tryParse(json['net_amount']?.toString() ?? ''),
    billingReason: json['billing_reason']?.toString(),
    notes: json['notes']?.toString(),
    metadata: json['metadata'] as Map<String, dynamic>?,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'store_id': storeId, 'session_id': sessionId, 'user_id': userId, 'system_id': systemId,
    'billed_from': billedFrom?.toIso8601String(), 'billed_until': billedUntil?.toIso8601String(),
    'billed_minutes': billedMinutes, 'base_rate': baseRate, 'applied_multiplier': appliedMultiplier,
    'applied_rule_id': appliedRuleId, 'gross_amount': grossAmount, 'discount_amount': discountAmount,
    'net_amount': netAmount, 'billing_reason': billingReason, 'notes': notes, 'metadata': metadata,
    'created_at': createdAt?.toIso8601String(),
  };
}

class PaymentModel {
  final String? id;
  final String? storeId;
  final String? billingId;
  final String? userId;
  final double? amount;
  final PaymentMethod? method;
  final PaymentStatus? status;
  final String? transactionRef;
  final String? idempotencyKey;
  final String? gatewayId;
  final Map<String, dynamic>? gatewayResponse;
  final DateTime? paidAt;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PaymentModel({this.id, this.storeId, this.billingId, this.userId, this.amount, this.method, this.status, this.transactionRef, this.idempotencyKey, this.gatewayId, this.gatewayResponse, this.paidAt, this.notes, this.createdAt, this.updatedAt});

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
    id: json['id']?.toString(),
    storeId: json['store_id']?.toString(),
    billingId: json['billing_id']?.toString(),
    userId: json['user_id']?.toString(),
    amount: double.tryParse(json['amount']?.toString() ?? ''),
    method: json['method']?.toString().toPaymentMethod(),
    status: json['status']?.toString().toPaymentStatus(),
    transactionRef: json['transaction_ref']?.toString(),
    idempotencyKey: json['idempotency_key']?.toString(),
    gatewayId: json['gateway_id']?.toString(),
    gatewayResponse: json['gateway_response'] as Map<String, dynamic>?,
    paidAt: json['paid_at'] != null ? DateTime.tryParse(json['paid_at'].toString()) : null,
    notes: json['notes']?.toString(),
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'store_id': storeId, 'billing_id': billingId, 'user_id': userId, 'amount': amount,
    'method': method?.name, 'status': status?.name, 'transaction_ref': transactionRef,
    'idempotency_key': idempotencyKey, 'gateway_id': gatewayId, 'gateway_response': gatewayResponse,
    'paid_at': paidAt?.toIso8601String(), 'notes': notes, 'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

class AdminOverrideModel {
  final String? id;
  final String? storeId;
  final String? adminId;
  final String? sessionId;
  final String? billingId;
  final OverrideType? overrideType;
  final double? originalValue;
  final double? overrideValue;
  final String? reason;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;

  const AdminOverrideModel({this.id, this.storeId, this.adminId, this.sessionId, this.billingId, this.overrideType, this.originalValue, this.overrideValue, this.reason, this.metadata, this.createdAt});

  factory AdminOverrideModel.fromJson(Map<String, dynamic> json) => AdminOverrideModel(
    id: json['id']?.toString(),
    storeId: json['store_id']?.toString(),
    adminId: json['admin_id']?.toString(),
    sessionId: json['session_id']?.toString(),
    billingId: json['billing_id']?.toString(),
    overrideType: json['override_type']?.toString().toOverrideType(),
    originalValue: double.tryParse(json['original_value']?.toString() ?? ''),
    overrideValue: double.tryParse(json['override_value']?.toString() ?? ''),
    reason: json['reason']?.toString(),
    metadata: json['metadata'] as Map<String, dynamic>?,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'store_id': storeId, 'admin_id': adminId, 'session_id': sessionId, 'billing_id': billingId,
    'override_type': overrideType?.name, 'original_value': originalValue, 'override_value': overrideValue,
    'reason': reason, 'metadata': metadata, 'created_at': createdAt?.toIso8601String(),
  };
}

class BillingDisputeModel {
  final String? id;
  final String? storeId;
  final String? billingId;
  final String? sessionId;
  final String? userId;
  final DisputeStatus? status;
  final String? reason;
  final double? disputeAmount;
  final DisputeResolution? resolution;
  final double? resolutionAmount;
  final String? resolvedBy;
  final DateTime? resolvedAt;
  final String? resolutionNotes;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BillingDisputeModel({this.id, this.storeId, this.billingId, this.sessionId, this.userId, this.status, this.reason, this.disputeAmount, this.resolution, this.resolutionAmount, this.resolvedBy, this.resolvedAt, this.resolutionNotes, this.metadata, this.createdAt, this.updatedAt});

  factory BillingDisputeModel.fromJson(Map<String, dynamic> json) => BillingDisputeModel(
    id: json['id']?.toString(),
    storeId: json['store_id']?.toString(),
    billingId: json['billing_id']?.toString(),
    sessionId: json['session_id']?.toString(),
    userId: json['user_id']?.toString(),
    status: json['status']?.toString().toDisputeStatus(),
    reason: json['reason']?.toString(),
    disputeAmount: double.tryParse(json['dispute_amount']?.toString() ?? ''),
    resolution: json['resolution']?.toString().toDisputeResolution(),
    resolutionAmount: double.tryParse(json['resolution_amount']?.toString() ?? ''),
    resolvedBy: json['resolved_by']?.toString(),
    resolvedAt: json['resolved_at'] != null ? DateTime.tryParse(json['resolved_at'].toString()) : null,
    resolutionNotes: json['resolution_notes']?.toString(),
    metadata: json['metadata'] as Map<String, dynamic>?,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'store_id': storeId, 'billing_id': billingId, 'session_id': sessionId, 'user_id': userId,
    'status': status?.name, 'reason': reason, 'dispute_amount': disputeAmount, 'resolution': resolution?.name,
    'resolution_amount': resolutionAmount, 'resolved_by': resolvedBy, 'resolved_at': resolvedAt?.toIso8601String(),
    'resolution_notes': resolutionNotes, 'metadata': metadata, 'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
