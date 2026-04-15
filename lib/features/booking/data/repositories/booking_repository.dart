import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/network_checker.dart';
import '../services/booking_service.dart';
import '../../../../models/api_responses.dart';

class BookingRepository {
  final BookingService _bookingService;
  final NetworkChecker _networkChecker;

  BookingRepository(this._bookingService, this._networkChecker);

  Future<PaginatedSystemTypesResponse> fetchSystemTypes(String storeId) async {
    await _networkChecker.assertConnection();
    return await _bookingService.getSystemTypes(storeId);
  }

  Future<BookingResponse> placeBooking(Map<String, dynamic> data) async {
    await _networkChecker.assertConnection();
    return await _bookingService.createBooking(data);
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final service = ref.watch(bookingServiceProvider);
  final network = ref.watch(networkCheckerProvider);
  return BookingRepository(service, network);
});
