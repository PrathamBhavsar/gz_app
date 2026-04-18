# Dart Models — Admin & Analytics Endpoints

**Purpose**: Ready-to-copy-paste Dart model files for the 13 missing admin/analytics endpoints. These files go into `gz_app/lib/models/`.

**Existing models to NOT regenerate**:
- `core.dart` (BaseApiResponse, FailureResponse, PaginationMeta, SuccessResponse, PaginatedSuccessResponse)
- `enums.dart` (21 enums)
- `domain_global.dart` (UserModel, StoreModel, etc.)
- `domain_systems.dart` (StoreAdminModel, SystemTypeModel, SystemModel, BookingModel, SessionModel, SessionLogModel)
- `domain_billing.dart` (PricingRuleModel, BillingLedgerModel, PaymentModel, AdminOverrideModel, BillingDisputeModel, TransactionModel)
- `domain_loyalty.dart` (CreditLedgerModel, CreditBalanceModel, CampaignModel, CampaignRedemptionModel)
- `domain_misc.dart` (NotificationModel, NotificationPreferenceModel, StoreDailySummaryModel, StoreHourlySummaryModel)
- `api_responses.dart` (all existing response wrappers)

---

## File: `lib/models/domain_analytics.dart`

```dart
import 'core.dart';
import 'enums.dart';

// ============================================================
// AnalyticsDashboardModel — Aggregated daily dashboard statistics
// GET /stores/:storeId/analytics/dashboard
// ============================================================

class AnalyticsDashboardModel {
  final String? date;
  final int? totalSessions;
  final String? totalRevenue;
  final String? totalNetRevenue;
  final int? totalMinutesPlayed;
  final String? avgSessionDurationMinutes;
  final String? occupancyRate;
  final int? uniquePlayers;
  final int? newPlayers;
  final int? peakHour;
  final int? totalBookingNoShows;
  final String? creditsEarned;
  final String? creditsRedeemed;
  final Map<String, dynamic>? paymentBreakdown;
  final String? source; // 'summary' | 'live'

  const AnalyticsDashboardModel({
    this.date,
    this.totalSessions,
    this.totalRevenue,
    this.totalNetRevenue,
    this.totalMinutesPlayed,
    this.avgSessionDurationMinutes,
    this.occupancyRate,
    this.uniquePlayers,
    this.newPlayers,
    this.peakHour,
    this.totalBookingNoShows,
    this.creditsEarned,
    this.creditsRedeemed,
    this.paymentBreakdown,
    this.source,
  });

  factory AnalyticsDashboardModel.fromJson(Map<String, dynamic> json) =>
      AnalyticsDashboardModel(
        date: json['date']?.toString(),
        totalSessions: json['totalSessions'] as int?,
        totalRevenue: json['totalRevenue']?.toString(),
        totalNetRevenue: json['totalNetRevenue']?.toString(),
        totalMinutesPlayed: json['totalMinutesPlayed'] as int?,
        avgSessionDurationMinutes:
            json['avgSessionDurationMinutes']?.toString(),
        occupancyRate: json['occupancyRate']?.toString(),
        uniquePlayers: json['uniquePlayers'] as int?,
        newPlayers: json['newPlayers'] as int?,
        peakHour: json['peakHour'] as int?,
        totalBookingNoShows: json['totalBookingNoShows'] as int?,
        creditsEarned: json['creditsEarned']?.toString(),
        creditsRedeemed: json['creditsRedeemed']?.toString(),
        paymentBreakdown: json['paymentBreakdown'] != null
            ? Map<String, dynamic>.from(
                json['paymentBreakdown'] as Map<String, dynamic>)
            : null,
        source: json['source']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'totalSessions': totalSessions,
        'totalRevenue': totalRevenue,
        'totalNetRevenue': totalNetRevenue,
        'totalMinutesPlayed': totalMinutesPlayed,
        'avgSessionDurationMinutes': avgSessionDurationMinutes,
        'occupancyRate': occupancyRate,
        'uniquePlayers': uniquePlayers,
        'newPlayers': newPlayers,
        'peakHour': peakHour,
        'totalBookingNoShows': totalBookingNoShows,
        'creditsEarned': creditsEarned,
        'creditsRedeemed': creditsRedeemed,
        'paymentBreakdown': paymentBreakdown,
        'source': source,
      };
}

// ============================================================
// RevenueAnalyticsRow — Single revenue data point
// ============================================================

class RevenueAnalyticsRow {
  final String? date;
  final String? revenue;
  final String? netRevenue;
  final String? discounts;
  final int? sessions;
  final int? minutes;

  const RevenueAnalyticsRow({
    this.date,
    this.revenue,
    this.netRevenue,
    this.discounts,
    this.sessions,
    this.minutes,
  });

  factory RevenueAnalyticsRow.fromJson(Map<String, dynamic> json) =>
      RevenueAnalyticsRow(
        date: json['date']?.toString(),
        revenue: json['revenue']?.toString(),
        netRevenue: json['netRevenue']?.toString(),
        discounts: json['discounts']?.toString(),
        sessions: json['sessions'] as int?,
        minutes: json['minutes'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'revenue': revenue,
        'netRevenue': netRevenue,
        'discounts': discounts,
        'sessions': sessions,
        'minutes': minutes,
      };
}

// ============================================================
// RevenueAnalyticsModel — Revenue breakdown by period
// GET /stores/:storeId/analytics/revenue
// ============================================================

class RevenueAnalyticsModel {
  final List<RevenueAnalyticsRow>? data;
  final String? dateFrom;
  final String? dateTo;
  final String? groupBy; // 'day' | 'week' | 'month'

  const RevenueAnalyticsModel({
    this.data,
    this.dateFrom,
    this.dateTo,
    this.groupBy,
  });

  factory RevenueAnalyticsModel.fromJson(Map<String, dynamic> json) =>
      RevenueAnalyticsModel(
        data: json['data'] != null
            ? (json['data'] as List)
                .map((e) =>
                    RevenueAnalyticsRow.fromJson(e as Map<String, dynamic>))
                .toList()
            : null,
        dateFrom: json['dateFrom']?.toString(),
        dateTo: json['dateTo']?.toString(),
        groupBy: json['groupBy']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'data': data?.map((e) => e.toJson()).toList(),
        'dateFrom': dateFrom,
        'dateTo': dateTo,
        'groupBy': groupBy,
      };
}

// ============================================================
// UtilizationHourModel — Single hourly utilization data point
// ============================================================

class UtilizationHourModel {
  final String? storeId;
  final String? summaryDate;
  final int? hourOfDay;
  final int? sessionsStarted;
  final int? sessionsEnded;
  final int? activeSessionsPeak;
  final String? revenue;
  final int? systemsInUse;
  final int? totalSystems;

  const UtilizationHourModel({
    this.storeId,
    this.summaryDate,
    this.hourOfDay,
    this.sessionsStarted,
    this.sessionsEnded,
    this.activeSessionsPeak,
    this.revenue,
    this.systemsInUse,
    this.totalSystems,
  });

  factory UtilizationHourModel.fromJson(Map<String, dynamic> json) =>
      UtilizationHourModel(
        storeId: json['store_id']?.toString(),
        summaryDate: json['summary_date']?.toString(),
        hourOfDay: json['hour_of_day'] as int?,
        sessionsStarted: json['sessions_started'] as int?,
        sessionsEnded: json['sessions_ended'] as int?,
        activeSessionsPeak: json['active_sessions_peak'] as int?,
        revenue: json['revenue']?.toString(),
        systemsInUse: json['systems_in_use'] as int?,
        totalSystems: json['total_systems'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'store_id': storeId,
        'summary_date': summaryDate,
        'hour_of_day': hourOfDay,
        'sessions_started': sessionsStarted,
        'sessions_ended': sessionsEnded,
        'active_sessions_peak': activeSessionsPeak,
        'revenue': revenue,
        'systems_in_use': systemsInUse,
        'total_systems': totalSystems,
      };
}

// ============================================================
// UtilizationModel — Utilization heatmap data
// GET /stores/:storeId/analytics/utilization
// ============================================================

class UtilizationModel {
  final List<UtilizationHourModel>? data;

  const UtilizationModel({this.data});

  factory UtilizationModel.fromJson(Map<String, dynamic> json) =>
      UtilizationModel(
        data: json['data'] != null
            ? (json['data'] as List)
                .map((e) =>
                    UtilizationHourModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
        'data': data?.map((e) => e.toJson()).toList(),
      };
}

// ============================================================
// SessionStatsModel — Session statistics
// GET /stores/:storeId/analytics/sessions/stats
// ============================================================

class SessionStatsModel {
  final int? totalSessions;
  final int? completed;
  final int? cancelled;
  final String? avgDurationMinutes;
  final int? totalMinutes;
  final int? walkInCount;
  final int? bookingCount;

  const SessionStatsModel({
    this.totalSessions,
    this.completed,
    this.cancelled,
    this.avgDurationMinutes,
    this.totalMinutes,
    this.walkInCount,
    this.bookingCount,
  });

  factory SessionStatsModel.fromJson(Map<String, dynamic> json) =>
      SessionStatsModel(
        totalSessions: json['totalSessions'] as int?,
        completed: json['completed'] as int?,
        cancelled: json['cancelled'] as int?,
        avgDurationMinutes: json['avgDurationMinutes']?.toString(),
        totalMinutes: json['totalMinutes'] as int?,
        walkInCount: json['walkInCount'] as int?,
        bookingCount: json['bookingCount'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'totalSessions': totalSessions,
        'completed': completed,
        'cancelled': cancelled,
        'avgDurationMinutes': avgDurationMinutes,
        'totalMinutes': totalMinutes,
        'walkInCount': walkInCount,
        'bookingCount': bookingCount,
      };
}

// ============================================================
// PlayerAnalyticsModel — Player analytics data
// GET /stores/:storeId/analytics/players
// ============================================================

class PlayerAnalyticsModel {
  final int? uniquePlayers;
  final int? newPlayers;
  final int? returningPlayers;
  final int? topPlayerMinutes;

  const PlayerAnalyticsModel({
    this.uniquePlayers,
    this.newPlayers,
    this.returningPlayers,
    this.topPlayerMinutes,
  });

  factory PlayerAnalyticsModel.fromJson(Map<String, dynamic> json) =>
      PlayerAnalyticsModel(
        uniquePlayers: json['uniquePlayers'] as int?,
        newPlayers: json['newPlayers'] as int?,
        returningPlayers: json['returningPlayers'] as int?,
        topPlayerMinutes: json['topPlayerMinutes'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'uniquePlayers': uniquePlayers,
        'newPlayers': newPlayers,
        'returningPlayers': returningPlayers,
        'topPlayerMinutes': topPlayerMinutes,
      };
}

// ============================================================
// SystemPerformanceEntry — Single system performance data
// ============================================================

class SystemPerformanceEntry {
  final String? systemId;
  final String? name;
  final int? stationNumber;
  final String? platform;
  final int? totalSessions;
  final int? totalMinutes;
  final String? totalRevenue;
  final String? utilizationRate;

  const SystemPerformanceEntry({
    this.systemId,
    this.name,
    this.stationNumber,
    this.platform,
    this.totalSessions,
    this.totalMinutes,
    this.totalRevenue,
    this.utilizationRate,
  });

  factory SystemPerformanceEntry.fromJson(Map<String, dynamic> json) =>
      SystemPerformanceEntry(
        systemId: json['systemId']?.toString(),
        name: json['name']?.toString(),
        stationNumber: json['stationNumber'] as int?,
        platform: json['platform']?.toString(),
        totalSessions: json['totalSessions'] as int?,
        totalMinutes: json['totalMinutes'] as int?,
        totalRevenue: json['totalRevenue']?.toString(),
        utilizationRate: json['utilizationRate']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'systemId': systemId,
        'name': name,
        'stationNumber': stationNumber,
        'platform': platform,
        'totalSessions': totalSessions,
        'totalMinutes': totalMinutes,
        'totalRevenue': totalRevenue,
        'utilizationRate': utilizationRate,
      };
}

// ============================================================
// SystemPerformanceModel — Per-system performance breakdown
// GET /stores/:storeId/analytics/systems/performance
// ============================================================

class SystemPerformanceModel {
  final List<SystemPerformanceEntry>? systems;

  const SystemPerformanceModel({this.systems});

  factory SystemPerformanceModel.fromJson(Map<String, dynamic> json) =>
      SystemPerformanceModel(
        systems: json['systems'] != null
            ? (json['systems'] as List)
                .map((e) => SystemPerformanceEntry.fromJson(
                    e as Map<String, dynamic>))
                .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
        'systems': systems?.map((e) => e.toJson()).toList(),
      };
}
```

---

## File: `lib/models/domain_admin.dart`

```dart
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
        maxBookingDurationMinutes:
            json['max_booking_duration_minutes'] as int?,
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
            ? Map<String, dynamic>.from(
                json['permissions'] as Map<String, dynamic>)
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
                .map((e) => PricingAppliedRuleModel.fromJson(
                    e as Map<String, dynamic>))
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
                json['paymentMethodBreakdown'] as Map<String, dynamic>)
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
                .map((e) => ReconciliationEntryModel.fromJson(
                    e as Map<String, dynamic>))
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
                json['currentSession'] as Map<String, dynamic>)
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
```

---

## File: `lib/models/api_responses_admin.dart`

```dart
import 'core.dart';
import 'domain_admin.dart';
import 'domain_analytics.dart';

// ============================================================
// Admin Auth Responses
// ============================================================

class AdminLoginResponse extends SuccessResponse<AdminAuthTokenResponse> {
  const AdminLoginResponse({super.message, super.data});

  factory AdminLoginResponse.fromJson(Map<String, dynamic> json) =>
      AdminLoginResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? AdminAuthTokenResponse.fromJson(
                json['data'] as Map<String, dynamic>)
            : null,
      );
}

class AdminProfileResponse extends SuccessResponse<AdminAuthModel> {
  const AdminProfileResponse({super.message, super.data});

  factory AdminProfileResponse.fromJson(Map<String, dynamic> json) =>
      AdminProfileResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? AdminAuthModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
}

// ============================================================
// Store Config Responses
// ============================================================

class StoreConfigResponse extends SuccessResponse<StoreConfigModel> {
  const StoreConfigResponse({super.message, super.data});

  factory StoreConfigResponse.fromJson(Map<String, dynamic> json) =>
      StoreConfigResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? StoreConfigModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
}

// ============================================================
// Analytics Responses
// ============================================================

class AnalyticsDashboardResponse
    extends SuccessResponse<AnalyticsDashboardModel> {
  const AnalyticsDashboardResponse({super.message, super.data});

  factory AnalyticsDashboardResponse.fromJson(Map<String, dynamic> json) =>
      AnalyticsDashboardResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? AnalyticsDashboardModel.fromJson(
                json['data'] as Map<String, dynamic>)
            : null,
      );
}

class RevenueAnalyticsResponse extends SuccessResponse<RevenueAnalyticsModel> {
  const RevenueAnalyticsResponse({super.message, super.data});

  factory RevenueAnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      RevenueAnalyticsResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? RevenueAnalyticsModel.fromJson(
                json['data'] as Map<String, dynamic>)
            : null,
      );
}

class UtilizationResponse extends SuccessResponse<UtilizationModel> {
  const UtilizationResponse({super.message, super.data});

  factory UtilizationResponse.fromJson(Map<String, dynamic> json) =>
      UtilizationResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? UtilizationModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
}

class SessionStatsResponse extends SuccessResponse<SessionStatsModel> {
  const SessionStatsResponse({super.message, super.data});

  factory SessionStatsResponse.fromJson(Map<String, dynamic> json) =>
      SessionStatsResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? SessionStatsModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
}

class PlayerAnalyticsResponse extends SuccessResponse<PlayerAnalyticsModel> {
  const PlayerAnalyticsResponse({super.message, super.data});

  factory PlayerAnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      PlayerAnalyticsResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? PlayerAnalyticsModel.fromJson(
                json['data'] as Map<String, dynamic>)
            : null,
      );
}

class SystemPerformanceResponse
    extends SuccessResponse<SystemPerformanceModel> {
  const SystemPerformanceResponse({super.message, super.data});

  factory SystemPerformanceResponse.fromJson(Map<String, dynamic> json) =>
      SystemPerformanceResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? SystemPerformanceModel.fromJson(
                json['data'] as Map<String, dynamic>)
            : null,
      );
}

// ============================================================
// Pricing Responses
// ============================================================

class PriceCalculationResponse extends SuccessResponse<PriceCalculationModel> {
  const PriceCalculationResponse({super.message, super.data});

  factory PriceCalculationResponse.fromJson(Map<String, dynamic> json) =>
      PriceCalculationResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? PriceCalculationModel.fromJson(
                json['data'] as Map<String, dynamic>)
            : null,
      );
}

// ============================================================
// Billing Responses
// ============================================================

class RevenueSummaryResponse extends SuccessResponse<RevenueSummaryModel> {
  const RevenueSummaryResponse({super.message, super.data});

  factory RevenueSummaryResponse.fromJson(Map<String, dynamic> json) =>
      RevenueSummaryResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? RevenueSummaryModel.fromJson(
                json['data'] as Map<String, dynamic>)
            : null,
      );
}

// ============================================================
// Payments Responses
// ============================================================

class ReconciliationResponse extends SuccessResponse<ReconciliationModel> {
  const ReconciliationResponse({super.message, super.data});

  factory ReconciliationResponse.fromJson(Map<String, dynamic> json) =>
      ReconciliationResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? ReconciliationModel.fromJson(
                json['data'] as Map<String, dynamic>)
            : null,
      );
}

// ============================================================
// Live Systems Responses
// ============================================================

class LiveSystemsResponse extends SuccessResponse<List<LiveSystemStatusModel>> {
  const LiveSystemsResponse({super.message, super.data});

  factory LiveSystemsResponse.fromJson(Map<String, dynamic> json) =>
      LiveSystemsResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? (json['data'] as List)
                .map((e) => LiveSystemStatusModel.fromJson(
                    e as Map<String, dynamic>))
                .toList()
            : null,
      );
}

// ============================================================
// Walk-In Booking Responses
// ============================================================

class WalkInBookingResponseWrapper extends SuccessResponse<WalkInBookingResponse> {
  const WalkInBookingResponseWrapper({super.message, super.data});

  factory WalkInBookingResponseWrapper.fromJson(Map<String, dynamic> json) =>
      WalkInBookingResponseWrapper(
        message: json['message'] as String?,
        data: json['data'] != null
            ? WalkInBookingResponse.fromJson(
                json['data'] as Map<String, dynamic>)
            : null,
      );
}
```
