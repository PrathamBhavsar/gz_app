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
        avgSessionDurationMinutes: json['avgSessionDurationMinutes']
            ?.toString(),
        occupancyRate: json['occupancyRate']?.toString(),
        uniquePlayers: json['uniquePlayers'] as int?,
        newPlayers: json['newPlayers'] as int?,
        peakHour: json['peakHour'] as int?,
        totalBookingNoShows: json['totalBookingNoShows'] as int?,
        creditsEarned: json['creditsEarned']?.toString(),
        creditsRedeemed: json['creditsRedeemed']?.toString(),
        paymentBreakdown: json['paymentBreakdown'] != null
            ? Map<String, dynamic>.from(
                json['paymentBreakdown'] as Map<String, dynamic>,
              )
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
                  .map(
                    (e) =>
                        RevenueAnalyticsRow.fromJson(e as Map<String, dynamic>),
                  )
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
                  .map(
                    (e) => UtilizationHourModel.fromJson(
                      e as Map<String, dynamic>,
                    ),
                  )
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
                  .map(
                    (e) => SystemPerformanceEntry.fromJson(
                      e as Map<String, dynamic>,
                    ),
                  )
                  .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
    'systems': systems?.map((e) => e.toJson()).toList(),
  };
}
