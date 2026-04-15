import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../models/api_responses.dart';
import '../../../auth/data/services/auth_service.dart';

class BookingService {
  final ApiClient _apiClient;

  BookingService(this._apiClient);

  Future<PaginatedSystemTypesResponse> getSystemTypes(String storeId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const PaginatedSystemTypesResponse(success: true, data: []); // Replace with mock if needed
  }

  Future<BookingResponse> createBooking(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const BookingResponse(success: true, data: null);
  }
}

final bookingServiceProvider = Provider<BookingService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BookingService(apiClient);
});
