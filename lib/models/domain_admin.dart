import 'core.dart';
import 'enums.dart';

// ============================================================
// StoreConfigModel — Store booking configuration settings
// GET /stores/:id/config | PATCH /stores/:id/config
// ============================================================

class StoreConfigModel {
  final String? storeId;
  final int? bookingWindowMinutes;
  final int? paymentWindowMinutes;
  final int? noShowGraceMinutes;
  final int? checkInEarlyMinutes;
  final int? maxBookingDurationMinutes;
  final bool? autoStartSessionOnCheckIn;
  final bool? allowWalkIns;
  final String? operatingHoursStart; // HH:mm
  final String? operatingHoursEnd; // HH:mm
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StoreConfigModel({
    this.storeId,
    this.bookingWindowMinutes,
    this.paymentWindowMinutes,
    this.noShowGraceMinutes,
    this.checkInEarlyMinutes,
    this.maxBookingDurationMinutes,
    this.autoStartSessionOnCheckIn,
    this.allowWalkIns,
    this.operatingHoursStart,
    this.operatingHoursEnd,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreConfigModel.fromJson(Map<String, dynamic> json) =>
      StoreConfigModel(
        storeId: json['store_id']?.toString(),
        bookingWindowMinutes: json['booking_window_minutes'] as int?,
        paymentWindowMinutes: json['payment_window_minutes'] as int?,
        noShowGraceMinutes: json['no_show_grace_minutes'] as int?,
        checkInEarlyMinutes: json['check_in_early_minutes'] as int?,
        maxBookingDurationMinutes: json['max_booking_duration_minutes'] as int?,
        autoStartSessionOnCheckIn:
            json['auto_start_session_on_check_in'] as bool?,
        allowWalkIns: json['allow_walk_ins'] as bool?,
        operatingHoursStart: json['operating_hours_start']?.toString(),
        operatingHoursEnd: json['operating_hours_end']?.toString(),
        isActive: json['is_active'] as bool?,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'].toString())
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
    'store_id': storeId,
    'booking_window_minutes': bookingWindowMinutes,
    'payment_window_minutes': paymentWindowMinutes,
    'no_show_grace_minutes': noShowGraceMinutes,
    'check_in_early_minutes': checkInEarlyMinutes,
    'max_booking_duration_minutes': maxBookingDurationMinutes,
    'auto_start_session_on_check_in': autoStartSessionOnCheckIn,
    'allow_walk_ins': allowWalkIns,
    'operating_hours_start': operatingHoursStart,
    'operating_hours_end': operatingHoursEnd,
    'is_active': isActive,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

// ============================================================
// AdminAuthModel — Admin user data returned from login
// ============================================================

class AdminAuthModel {
  final String? id;
  final String? name;
  final String? email;
  final String? role; // 'super_admin' | 'admin' | 'staff'
  final String? storeId;
  final Map<String, dynamic>? permissions;
  final DateTime? lastLoginAt;
  final bool? isActive;

  const AdminAuthModel({
    this.id,
    this.name,
    this.email,
    this.role,
    this.storeId,
    this.permissions,
    this.lastLoginAt,
    this.isActive,
  });

  factory AdminAuthModel.fromJson(Map<String, dynamic> json) => AdminAuthModel(
    id: json['id']?.toString(),
    name: json['name']?.toString(),
    email: json['email']?.toString(),
    role: json['role']?.toString(),
    storeId: json['storeId']?.toString(),
    permissions: json['permissions'] != null
        ? Map<String, dynamic>.from(json['permissions'] as Map<String, dynamic>)
        : null,
    lastLoginAt: json['lastLoginAt'] != null
        ? DateTime.tryParse(json['lastLoginAt'].toString())
        : null,
    isActive: json['isActive'] as bool?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'storeId': storeId,
    'permissions': permissions,
    'lastLoginAt': lastLoginAt?.toIso8601String(),
    'isActive': isActive,
  };
}

// ============================================================
// AdminAuthTokenResponse — Admin login response
// POST /auth/admin/login
// ============================================================

class AdminAuthTokenResponse {
  final String? accessToken;
  final String? refreshToken;
  final AdminAuthModel? admin;

  const AdminAuthTokenResponse({
    this.accessToken,
    this.refreshToken,
    this.admin,
  });

  factory AdminAuthTokenResponse.fromJson(Map<String, dynamic> json) =>
      AdminAuthTokenResponse(
        accessToken: json['accessToken']?.toString(),
        refreshToken: json['refreshToken']?.toString(),
        admin: json['admin'] != null
            ? AdminAuthModel.fromJson(json['admin'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'admin': admin?.toJson(),
  };
}

// ============================================================
// PriceCalculationModel — Price preview result
// POST /stores/:storeId/pricing/calculate
// ============================================================

class PriceCalculationModel {
  final String? baseRate;
  final String? appliedMultiplier;
  final String? grossAmount;
  final String? discountAmount;
  final String? netAmount;
  final int? durationMinutes;
  final List<PricingAppliedRuleModel>? appliedRules;

  const PriceCalculationModel({
    this.baseRate,
    this.appliedMultiplier,
    this.grossAmount,
    this.discountAmount,
    this.netAmount,
    this.durationMinutes,
    this.appliedRules,
  });

  factory PriceCalculationModel.fromJson(Map<String, dynamic> json) =>
      PriceCalculationModel(
        baseRate: json['baseRate']?.toString(),
        appliedMultiplier: json['appliedMultiplier']?.toString(),
        grossAmount: json['grossAmount']?.toString(),
        discountAmount: json['discountAmount']?.toString(),
        netAmount: json['netAmount']?.toString(),
        durationMinutes: json['durationMinutes'] as int?,
        appliedRules: json['appliedRules'] != null
            ? (json['appliedRules'] as List)
                  .map(
                    (e) => PricingAppliedRuleModel.fromJson(
                      e as Map<String, dynamic>,
                    ),
                  )
                  .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
    'baseRate': baseRate,
    'appliedMultiplier': appliedMultiplier,
    'grossAmount': grossAmount,
    'discountAmount': discountAmount,
    'netAmount': netAmount,
    'durationMinutes': durationMinutes,
    'appliedRules': appliedRules?.map((e) => e.toJson()).toList(),
  };
}

// ============================================================
// PricingAppliedRuleModel — Single pricing rule applied to a calculation
// ============================================================

class PricingAppliedRuleModel {
  final String? ruleId;
  final String? ruleName;
  final String? ruleType;
  final String? multiplier;
  final String? discount;

  const PricingAppliedRuleModel({
    this.ruleId,
    this.ruleName,
    this.ruleType,
    this.multiplier,
    this.discount,
  });

  factory PricingAppliedRuleModel.fromJson(Map<String, dynamic> json) =>
      PricingAppliedRuleModel(
        ruleId: json['ruleId']?.toString(),
        ruleName: json['ruleName']?.toString(),
        ruleType: json['ruleType']?.toString(),
        multiplier: json['multiplier']?.toString(),
        discount: json['discount']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'ruleId': ruleId,
    'ruleName': ruleName,
    'ruleType': ruleType,
    'multiplier': multiplier,
    'discount': discount,
  };
}

// ============================================================
// RevenueSummaryModel — Revenue summary for billing
// GET /stores/:storeId/billing/revenue/summary
// ============================================================

class RevenueSummaryModel {
  final String? totalRevenue;
  final String? totalNetRevenue;
  final String? totalDiscounts;
  final int? totalSessions;
  final int? totalMinutesPlayed;
  final Map<String, dynamic>? paymentMethodBreakdown;
  final String? pendingAmount;

  const RevenueSummaryModel({
    this.totalRevenue,
    this.totalNetRevenue,
    this.totalDiscounts,
    this.totalSessions,
    this.totalMinutesPlayed,
    this.paymentMethodBreakdown,
    this.pendingAmount,
  });

  factory RevenueSummaryModel.fromJson(Map<String, dynamic> json) =>
      RevenueSummaryModel(
        totalRevenue: json['totalRevenue']?.toString(),
        totalNetRevenue: json['totalNetRevenue']?.toString(),
        totalDiscounts: json['totalDiscounts']?.toString(),
        totalSessions: json['totalSessions'] as int?,
        totalMinutesPlayed: json['totalMinutesPlayed'] as int?,
        paymentMethodBreakdown: json['paymentMethodBreakdown'] != null
            ? Map<String, dynamic>.from(
                json['paymentMethodBreakdown'] as Map<String, dynamic>,
              )
            : null,
        pendingAmount: json['pendingAmount']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'totalRevenue': totalRevenue,
    'totalNetRevenue': totalNetRevenue,
    'totalDiscounts': totalDiscounts,
    'totalSessions': totalSessions,
    'totalMinutesPlayed': totalMinutesPlayed,
    'paymentMethodBreakdown': paymentMethodBreakdown,
    'pendingAmount': pendingAmount,
  };
}

// ============================================================
// ReconciliationModel — Payment reconciliation report
// GET /stores/:storeId/payments/reconciliation
// ============================================================

class ReconciliationModel {
  final String? expectedTotal;
  final String? actualTotal;
  final String? discrepancy;
  final int? matchedPayments;
  final int? unmatchedPayments;
  final int? outstandingItems;
  final List<ReconciliationEntryModel>? items;

  const ReconciliationModel({
    this.expectedTotal,
    this.actualTotal,
    this.discrepancy,
    this.matchedPayments,
    this.unmatchedPayments,
    this.outstandingItems,
    this.items,
  });

  factory ReconciliationModel.fromJson(Map<String, dynamic> json) =>
      ReconciliationModel(
        expectedTotal: json['expectedTotal']?.toString(),
        actualTotal: json['actualTotal']?.toString(),
        discrepancy: json['discrepancy']?.toString(),
        matchedPayments: json['matchedPayments'] as int?,
        unmatchedPayments: json['unmatchedPayments'] as int?,
        outstandingItems: json['outstandingItems'] as int?,
        items: json['items'] != null
            ? (json['items'] as List)
                  .map(
                    (e) => ReconciliationEntryModel.fromJson(
                      e as Map<String, dynamic>,
                    ),
                  )
                  .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
    'expectedTotal': expectedTotal,
    'actualTotal': actualTotal,
    'discrepancy': discrepancy,
    'matchedPayments': matchedPayments,
    'unmatchedPayments': unmatchedPayments,
    'outstandingItems': outstandingItems,
    'items': items?.map((e) => e.toJson()).toList(),
  };
}

// ============================================================
// ReconciliationEntryModel — Single reconciliation entry
// ============================================================

class ReconciliationEntryModel {
  final String? paymentId;
  final String? expectedAmount;
  final String? actualAmount;
  final String? status; // 'matched' | 'unmatched' | 'outstanding'
  final String? paymentMethod;
  final DateTime? recordedAt;

  const ReconciliationEntryModel({
    this.paymentId,
    this.expectedAmount,
    this.actualAmount,
    this.status,
    this.paymentMethod,
    this.recordedAt,
  });

  factory ReconciliationEntryModel.fromJson(Map<String, dynamic> json) =>
      ReconciliationEntryModel(
        paymentId: json['paymentId']?.toString(),
        expectedAmount: json['expectedAmount']?.toString(),
        actualAmount: json['actualAmount']?.toString(),
        status: json['status']?.toString(),
        paymentMethod: json['paymentMethod']?.toString(),
        recordedAt: json['recordedAt'] != null
            ? DateTime.tryParse(json['recordedAt'].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
    'paymentId': paymentId,
    'expectedAmount': expectedAmount,
    'actualAmount': actualAmount,
    'status': status,
    'paymentMethod': paymentMethod,
    'recordedAt': recordedAt?.toIso8601String(),
  };
}

// ============================================================
// LiveSystemStatusModel — Live system status for floor map
// GET /stores/:storeId/systems/live
// ============================================================

class LiveSystemStatusModel {
  final String? systemId;
  final String? name;
  final int? stationNumber;
  final String? platform;
  final String? status; // 'available' | 'in_use' | 'maintenance' | 'offline'
  final String? systemTypeName;
  final LiveSessionInfoModel? currentSession;
  final DateTime? lastHeartbeatAt;

  const LiveSystemStatusModel({
    this.systemId,
    this.name,
    this.stationNumber,
    this.platform,
    this.status,
    this.systemTypeName,
    this.currentSession,
    this.lastHeartbeatAt,
  });

  factory LiveSystemStatusModel.fromJson(Map<String, dynamic> json) =>
      LiveSystemStatusModel(
        systemId: json['systemId']?.toString(),
        name: json['name']?.toString(),
        stationNumber: json['stationNumber'] as int?,
        platform: json['platform']?.toString(),
        status: json['status']?.toString(),
        systemTypeName: json['systemTypeName']?.toString(),
        currentSession: json['currentSession'] != null
            ? LiveSessionInfoModel.fromJson(
                json['currentSession'] as Map<String, dynamic>,
              )
            : null,
        lastHeartbeatAt: json['lastHeartbeatAt'] != null
            ? DateTime.tryParse(json['lastHeartbeatAt'].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
    'systemId': systemId,
    'name': name,
    'stationNumber': stationNumber,
    'platform': platform,
    'status': status,
    'systemTypeName': systemTypeName,
    'currentSession': currentSession?.toJson(),
    'lastHeartbeatAt': lastHeartbeatAt?.toIso8601String(),
  };
}

// ============================================================
// LiveSessionInfoModel — Current session on a live system
// ============================================================

class LiveSessionInfoModel {
  final String? sessionId;
  final String? userId;
  final String? userName;
  final DateTime? startedAt;
  final int? durationMinutes;
  final String? bookingId;

  const LiveSessionInfoModel({
    this.sessionId,
    this.userId,
    this.userName,
    this.startedAt,
    this.durationMinutes,
    this.bookingId,
  });

  factory LiveSessionInfoModel.fromJson(Map<String, dynamic> json) =>
      LiveSessionInfoModel(
        sessionId: json['sessionId']?.toString(),
        userId: json['userId']?.toString(),
        userName: json['userName']?.toString(),
        startedAt: json['startedAt'] != null
            ? DateTime.tryParse(json['startedAt'].toString())
            : null,
        durationMinutes: json['durationMinutes'] as int?,
        bookingId: json['bookingId']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'sessionId': sessionId,
    'userId': userId,
    'userName': userName,
    'startedAt': startedAt?.toIso8601String(),
    'durationMinutes': durationMinutes,
    'bookingId': bookingId,
  };
}

// ============================================================
// WalkInBookingResponse — Combined booking + session from walk-in
// POST /stores/:storeId/bookings/walk-in
// ============================================================

class WalkInBookingResponse {
  final String? bookingId;
  final String? sessionId;
  final String? systemId;
  final String? systemName;
  final String? userId;
  final String? userName;
  final DateTime? startedAt;
  final String? status;

  const WalkInBookingResponse({
    this.bookingId,
    this.sessionId,
    this.systemId,
    this.systemName,
    this.userId,
    this.userName,
    this.startedAt,
    this.status,
  });

  factory WalkInBookingResponse.fromJson(Map<String, dynamic> json) =>
      WalkInBookingResponse(
        bookingId: json['bookingId']?.toString(),
        sessionId: json['sessionId']?.toString(),
        systemId: json['systemId']?.toString(),
        systemName: json['systemName']?.toString(),
        userId: json['userId']?.toString(),
        userName: json['userName']?.toString(),
        startedAt: json['startedAt'] != null
            ? DateTime.tryParse(json['startedAt'].toString())
            : null,
        status: json['status']?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'bookingId': bookingId,
    'sessionId': sessionId,
    'systemId': systemId,
    'systemName': systemName,
    'userId': userId,
    'userName': userName,
    'startedAt': startedAt?.toIso8601String(),
    'status': status,
  };
}
