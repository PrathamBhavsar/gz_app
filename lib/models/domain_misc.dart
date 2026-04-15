import 'enums.dart';

class NotificationModel {
  final String? id;
  final String? storeId;
  final String? userId;
  final NotificationChannel? channel;
  final NotificationStatus? status;
  final String? title;
  final String? body;
  final DateTime? scheduledAt;
  final DateTime? sentAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;
  final String? referenceType;
  final String? referenceId;
  final Map<String, dynamic>? gatewayResponse;
  final DateTime? createdAt;

  const NotificationModel({this.id, this.storeId, this.userId, this.channel, this.status, this.title, this.body, this.scheduledAt, this.sentAt, this.deliveredAt, this.readAt, this.referenceType, this.referenceId, this.gatewayResponse, this.createdAt});

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json['id']?.toString(),
    storeId: json['store_id']?.toString(),
    userId: json['user_id']?.toString(),
    channel: json['channel']?.toString().toNotificationChannel(),
    status: json['status']?.toString().toNotificationStatus(),
    title: json['title']?.toString(),
    body: json['body']?.toString(),
    scheduledAt: json['scheduled_at'] != null ? DateTime.tryParse(json['scheduled_at'].toString()) : null,
    sentAt: json['sent_at'] != null ? DateTime.tryParse(json['sent_at'].toString()) : null,
    deliveredAt: json['delivered_at'] != null ? DateTime.tryParse(json['delivered_at'].toString()) : null,
    readAt: json['read_at'] != null ? DateTime.tryParse(json['read_at'].toString()) : null,
    referenceType: json['reference_type']?.toString(),
    referenceId: json['reference_id']?.toString(),
    gatewayResponse: json['gateway_response'] as Map<String, dynamic>?,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'store_id': storeId, 'user_id': userId, 'channel': channel?.name, 'status': status?.name,
    'title': title, 'body': body, 'scheduled_at': scheduledAt?.toIso8601String(), 'sent_at': sentAt?.toIso8601String(),
    'delivered_at': deliveredAt?.toIso8601String(), 'read_at': readAt?.toIso8601String(), 'reference_type': referenceType,
    'reference_id': referenceId, 'gateway_response': gatewayResponse, 'created_at': createdAt?.toIso8601String(),
  };
}

class NotificationPreferenceModel {
  final String? id;
  final String? userId;
  final String? storeId;
  final NotificationChannel? channel;
  final String? notificationGroup;
  final bool? isEnabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NotificationPreferenceModel({this.id, this.userId, this.storeId, this.channel, this.notificationGroup, this.isEnabled, this.createdAt, this.updatedAt});

  factory NotificationPreferenceModel.fromJson(Map<String, dynamic> json) => NotificationPreferenceModel(
    id: json['id']?.toString(),
    userId: json['user_id']?.toString(),
    storeId: json['store_id']?.toString(),
    channel: json['channel']?.toString().toNotificationChannel(),
    notificationGroup: json['notification_group']?.toString(),
    isEnabled: json['is_enabled'] as bool?,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': userId, 'store_id': storeId, 'channel': channel?.name, 'notification_group': notificationGroup,
    'is_enabled': isEnabled, 'created_at': createdAt?.toIso8601String(), 'updated_at': updatedAt?.toIso8601String(),
  };
}

class StoreDailySummaryModel {
  final String? storeId;
  final DateTime? summaryDate;
  final int? totalSessions;
  final int? totalWalkIns;
  final int? totalBookings;
  final int? totalBookingNoShows;
  final double? totalRevenue;
  final double? totalDiscounts;
  final double? totalNetRevenue;
  final int? totalMinutesPlayed;
  final double? avgSessionDurationMinutes;
  final int? peakHour;
  final int? peakHourSessions;
  final int? totalSystemsAvailable;
  final double? occupancyRate;
  final int? uniquePlayers;
  final int? newPlayers;
  final double? creditsEarned;
  final double? creditsRedeemed;
  final Map<String, dynamic>? paymentBreakdown;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StoreDailySummaryModel({this.storeId, this.summaryDate, this.totalSessions, this.totalWalkIns, this.totalBookings, this.totalBookingNoShows, this.totalRevenue, this.totalDiscounts, this.totalNetRevenue, this.totalMinutesPlayed, this.avgSessionDurationMinutes, this.peakHour, this.peakHourSessions, this.totalSystemsAvailable, this.occupancyRate, this.uniquePlayers, this.newPlayers, this.creditsEarned, this.creditsRedeemed, this.paymentBreakdown, this.metadata, this.createdAt, this.updatedAt});

  factory StoreDailySummaryModel.fromJson(Map<String, dynamic> json) => StoreDailySummaryModel(
    storeId: json['store_id']?.toString(),
    summaryDate: json['summary_date'] != null ? DateTime.tryParse(json['summary_date'].toString()) : null,
    totalSessions: json['total_sessions'] as int?,
    totalWalkIns: json['total_walk_ins'] as int?,
    totalBookings: json['total_bookings'] as int?,
    totalBookingNoShows: json['total_booking_no_shows'] as int?,
    totalRevenue: double.tryParse(json['total_revenue']?.toString() ?? ''),
    totalDiscounts: double.tryParse(json['total_discounts']?.toString() ?? ''),
    totalNetRevenue: double.tryParse(json['total_net_revenue']?.toString() ?? ''),
    totalMinutesPlayed: json['total_minutes_played'] as int?,
    avgSessionDurationMinutes: double.tryParse(json['avg_session_duration_minutes']?.toString() ?? ''),
    peakHour: json['peak_hour'] as int?,
    peakHourSessions: json['peak_hour_sessions'] as int?,
    totalSystemsAvailable: json['total_systems_available'] as int?,
    occupancyRate: double.tryParse(json['occupancy_rate']?.toString() ?? ''),
    uniquePlayers: json['unique_players'] as int?,
    newPlayers: json['new_players'] as int?,
    creditsEarned: double.tryParse(json['credits_earned']?.toString() ?? ''),
    creditsRedeemed: double.tryParse(json['credits_redeemed']?.toString() ?? ''),
    paymentBreakdown: json['payment_breakdown'] as Map<String, dynamic>?,
    metadata: json['metadata'] as Map<String, dynamic>?,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'store_id': storeId, 'summary_date': summaryDate?.toIso8601String(), 'total_sessions': totalSessions,
    'total_walk_ins': totalWalkIns, 'total_bookings': totalBookings, 'total_booking_no_shows': totalBookingNoShows,
    'total_revenue': totalRevenue, 'total_discounts': totalDiscounts, 'total_net_revenue': totalNetRevenue,
    'total_minutes_played': totalMinutesPlayed, 'avg_session_duration_minutes': avgSessionDurationMinutes,
    'peak_hour': peakHour, 'peak_hour_sessions': peakHourSessions, 'total_systems_available': totalSystemsAvailable,
    'occupancy_rate': occupancyRate, 'unique_players': uniquePlayers, 'new_players': newPlayers,
    'credits_earned': creditsEarned, 'credits_redeemed': creditsRedeemed, 'payment_breakdown': paymentBreakdown,
    'metadata': metadata, 'created_at': createdAt?.toIso8601String(), 'updated_at': updatedAt?.toIso8601String(),
  };
}

class StoreHourlySummaryModel {
  final String? storeId;
  final DateTime? summaryDate;
  final int? hourOfDay;
  final int? sessionsStarted;
  final int? sessionsEnded;
  final int? activeSessionsPeak;
  final double? revenue;
  final int? systemsInUse;
  final int? totalSystems;
  final DateTime? createdAt;

  const StoreHourlySummaryModel({this.storeId, this.summaryDate, this.hourOfDay, this.sessionsStarted, this.sessionsEnded, this.activeSessionsPeak, this.revenue, this.systemsInUse, this.totalSystems, this.createdAt});

  factory StoreHourlySummaryModel.fromJson(Map<String, dynamic> json) => StoreHourlySummaryModel(
    storeId: json['store_id']?.toString(),
    summaryDate: json['summary_date'] != null ? DateTime.tryParse(json['summary_date'].toString()) : null,
    hourOfDay: json['hour_of_day'] as int?,
    sessionsStarted: json['sessions_started'] as int?,
    sessionsEnded: json['sessions_ended'] as int?,
    activeSessionsPeak: json['active_sessions_peak'] as int?,
    revenue: double.tryParse(json['revenue']?.toString() ?? ''),
    systemsInUse: json['systems_in_use'] as int?,
    totalSystems: json['total_systems'] as int?,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'store_id': storeId, 'summary_date': summaryDate?.toIso8601String(), 'hour_of_day': hourOfDay,
    'sessions_started': sessionsStarted, 'sessions_ended': sessionsEnded, 'active_sessions_peak': activeSessionsPeak,
    'revenue': revenue, 'systems_in_use': systemsInUse, 'total_systems': totalSystems, 'created_at': createdAt?.toIso8601String(),
  };
}
