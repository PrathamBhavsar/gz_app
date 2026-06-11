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

class AdminSessionsData {
  const AdminSessionsData({
    required this.sessions,
    required this.activeSessions,
    required this.selectedSession,
    required this.logs,
    required this.loadedAt,
  });

  final List<SessionModel> sessions;
  final List<SessionModel> activeSessions;
  final SessionModel? selectedSession;
  final List<SessionLogModel> logs;
  final DateTime loadedAt;
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
