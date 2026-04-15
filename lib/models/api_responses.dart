import 'core.dart';
import 'domain_global.dart';
import 'domain_systems.dart';
import 'domain_billing.dart';
import 'domain_loyalty.dart';
import 'domain_misc.dart';

// --- USERS ---
class UserResponse extends SuccessResponse<UserModel> {
  const UserResponse({super.message, super.data});
  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    message: json['message'] as String?,
    data: json['data'] != null ? UserModel.fromJson(json['data']) : null,
  );
}

class PaginatedUsersResponse extends PaginatedSuccessResponse<UserModel> {
  const PaginatedUsersResponse({super.message, super.data, super.pagination});
  factory PaginatedUsersResponse.fromJson(Map<String, dynamic> json) => PaginatedUsersResponse(
    message: json['message'] as String?,
    data: (json['data'] as List<dynamic>?)?.map((e) => UserModel.fromJson(e)).toList(),
    pagination: json['pagination'] != null ? PaginationMeta.fromJson(json['pagination']) : null,
  );
}

// --- STORES ---
class StoreResponse extends SuccessResponse<StoreModel> {
  const StoreResponse({super.message, super.data});
  factory StoreResponse.fromJson(Map<String, dynamic> json) => StoreResponse(
    message: json['message'] as String?,
    data: json['data'] != null ? StoreModel.fromJson(json['data']) : null,
  );
}

class PaginatedStoresResponse extends PaginatedSuccessResponse<StoreModel> {
  const PaginatedStoresResponse({super.message, super.data, super.pagination});
  factory PaginatedStoresResponse.fromJson(Map<String, dynamic> json) => PaginatedStoresResponse(
    message: json['message'] as String?,
    data: (json['data'] as List<dynamic>?)?.map((e) => StoreModel.fromJson(e)).toList(),
    pagination: json['pagination'] != null ? PaginationMeta.fromJson(json['pagination']) : null,
  );
}

// --- SYSTEMS ---
class SystemResponse extends SuccessResponse<SystemModel> {
  const SystemResponse({super.message, super.data});
  factory SystemResponse.fromJson(Map<String, dynamic> json) => SystemResponse(
    message: json['message'] as String?,
    data: json['data'] != null ? SystemModel.fromJson(json['data']) : null,
  );
}

class PaginatedSystemsResponse extends PaginatedSuccessResponse<SystemModel> {
  const PaginatedSystemsResponse({super.message, super.data, super.pagination});
  factory PaginatedSystemsResponse.fromJson(Map<String, dynamic> json) => PaginatedSystemsResponse(
    message: json['message'] as String?,
    data: (json['data'] as List<dynamic>?)?.map((e) => SystemModel.fromJson(e)).toList(),
    pagination: json['pagination'] != null ? PaginationMeta.fromJson(json['pagination']) : null,
  );
}

// --- BOOKINGS ---
class BookingResponse extends SuccessResponse<BookingModel> {
  const BookingResponse({super.message, super.data});
  factory BookingResponse.fromJson(Map<String, dynamic> json) => BookingResponse(
    message: json['message'] as String?,
    data: json['data'] != null ? BookingModel.fromJson(json['data']) : null,
  );
}

class PaginatedBookingsResponse extends PaginatedSuccessResponse<BookingModel> {
  const PaginatedBookingsResponse({super.message, super.data, super.pagination});
  factory PaginatedBookingsResponse.fromJson(Map<String, dynamic> json) => PaginatedBookingsResponse(
    message: json['message'] as String?,
    data: (json['data'] as List<dynamic>?)?.map((e) => BookingModel.fromJson(e)).toList(),
    pagination: json['pagination'] != null ? PaginationMeta.fromJson(json['pagination']) : null,
  );
}

// --- SESSIONS ---
class SessionResponse extends SuccessResponse<SessionModel> {
  const SessionResponse({super.message, super.data});
  factory SessionResponse.fromJson(Map<String, dynamic> json) => SessionResponse(
    message: json['message'] as String?,
    data: json['data'] != null ? SessionModel.fromJson(json['data']) : null,
  );
}

class PaginatedSessionsResponse extends PaginatedSuccessResponse<SessionModel> {
  const PaginatedSessionsResponse({super.message, super.data, super.pagination});
  factory PaginatedSessionsResponse.fromJson(Map<String, dynamic> json) => PaginatedSessionsResponse(
    message: json['message'] as String?,
    data: (json['data'] as List<dynamic>?)?.map((e) => SessionModel.fromJson(e)).toList(),
    pagination: json['pagination'] != null ? PaginationMeta.fromJson(json['pagination']) : null,
  );
}

// --- PAYMENTS ---
class PaymentResponse extends SuccessResponse<PaymentModel> {
  const PaymentResponse({super.message, super.data});
  factory PaymentResponse.fromJson(Map<String, dynamic> json) => PaymentResponse(
    message: json['message'] as String?,
    data: json['data'] != null ? PaymentModel.fromJson(json['data']) : null,
  );
}

class PaginatedPaymentsResponse extends PaginatedSuccessResponse<PaymentModel> {
  const PaginatedPaymentsResponse({super.message, super.data, super.pagination});
  factory PaginatedPaymentsResponse.fromJson(Map<String, dynamic> json) => PaginatedPaymentsResponse(
    message: json['message'] as String?,
    data: (json['data'] as List<dynamic>?)?.map((e) => PaymentModel.fromJson(e)).toList(),
    pagination: json['pagination'] != null ? PaginationMeta.fromJson(json['pagination']) : null,
  );
}

// --- CAMPAIGNS ---
class CampaignResponse extends SuccessResponse<CampaignModel> {
  const CampaignResponse({super.message, super.data});
  factory CampaignResponse.fromJson(Map<String, dynamic> json) => CampaignResponse(
    message: json['message'] as String?,
    data: json['data'] != null ? CampaignModel.fromJson(json['data']) : null,
  );
}

class PaginatedCampaignsResponse extends PaginatedSuccessResponse<CampaignModel> {
  const PaginatedCampaignsResponse({super.message, super.data, super.pagination});
  factory PaginatedCampaignsResponse.fromJson(Map<String, dynamic> json) => PaginatedCampaignsResponse(
    message: json['message'] as String?,
    data: (json['data'] as List<dynamic>?)?.map((e) => CampaignModel.fromJson(e)).toList(),
    pagination: json['pagination'] != null ? PaginationMeta.fromJson(json['pagination']) : null,
  );
}
