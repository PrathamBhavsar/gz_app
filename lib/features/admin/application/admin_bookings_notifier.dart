import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/admin_bookings_repository.dart';
import 'admin_operations_models.dart';

class AdminBookingsNotifier extends AsyncNotifier<AdminBookingsData> {
  DateTime _selectedDate = DateTime.now();
  String _selectedStatus = 'All';

  @override
  Future<AdminBookingsData> build() => _load();

  Future<void> selectDate(DateTime value) async {
    _selectedDate = DateTime(value.year, value.month, value.day);
    await refresh();
  }

  Future<void> selectStatus(String value) async {
    _selectedStatus = value;
    await refresh();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<AdminBookingsData> _load() async {
    final bookings = await ref
        .read(adminBookingsRepositoryProvider)
        .fetchBookings(date: _selectedDate, status: _selectedStatus);
    return AdminBookingsData(
      selectedDate: _selectedDate,
      selectedStatus: _selectedStatus,
      bookings: bookings,
      loadedAt: DateTime.now(),
    );
  }
}

final adminBookingsNotifierProvider =
    AsyncNotifierProvider<AdminBookingsNotifier, AdminBookingsData>(
      AdminBookingsNotifier.new,
    );
