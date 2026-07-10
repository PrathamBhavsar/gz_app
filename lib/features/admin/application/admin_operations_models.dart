import '../../../models/domain_activity.dart';
import '../../../models/domain_admin.dart';
import '../../../models/domain_analytics.dart';
import '../../../models/domain_systems.dart';

class AdminDashboardData {
  const AdminDashboardData({
    required this.dashboard,
    required this.liveSystems,
    required this.loadedAt,
  });

  final AnalyticsDashboardModel dashboard;
  final List<LiveSystemStatusModel> liveSystems;
  final DateTime loadedAt;
}

/// Store-wide activity feed backing the Session Management screen's
/// All/Current/Incoming/Past tabs. Items already come sorted latest-first.
class AdminSessionsData {
  const AdminSessionsData({required this.items, required this.loadedAt});

  final List<AdminActivityItem> items;
  final DateTime loadedAt;

  List<AdminActivityItem> get current =>
      items.where((i) => i.bucket == ActivityBucket.current).toList();
  List<AdminActivityItem> get incoming =>
      items.where((i) => i.bucket == ActivityBucket.incoming).toList();
  List<AdminActivityItem> get past =>
      items.where((i) => i.bucket == ActivityBucket.past).toList();
}

/// Per-system activity backing SystemSessionsScreen: the live/last session
/// highlight, incoming bookings, and past-7-days sessions for one system.
class AdminSystemSessionsData {
  const AdminSystemSessionsData({
    required this.system,
    required this.liveStatus,
    required this.current,
    required this.incoming,
    required this.past,
    required this.currentLogs,
    required this.loadedAt,
  });

  final SystemModel system;
  final LiveSystemStatusModel? liveStatus;
  final AdminActivityItem? current;
  final List<AdminActivityItem> incoming;
  final List<AdminActivityItem> past;
  final List<SessionLogModel> currentLogs;
  final DateTime loadedAt;

  bool get isLive => current != null;
}

class AdminBookingsData {
  const AdminBookingsData({
    required this.selectedDate,
    required this.selectedStatus,
    required this.bookings,
    required this.loadedAt,
  });

  final DateTime selectedDate;
  final String selectedStatus;
  final List<BookingModel> bookings;
  final DateTime loadedAt;

  AdminBookingsData copyWith({
    DateTime? selectedDate,
    String? selectedStatus,
    List<BookingModel>? bookings,
    DateTime? loadedAt,
  }) {
    return AdminBookingsData(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      bookings: bookings ?? this.bookings,
      loadedAt: loadedAt ?? this.loadedAt,
    );
  }
}
