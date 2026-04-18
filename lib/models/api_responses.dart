import 'core.dart';
import 'domain_global.dart';
import 'domain_systems.dart';
import 'domain_billing.dart';
import 'domain_loyalty.dart';
import 'domain_misc.dart';

// --- AUTH TOKEN RESPONSE ---
// Shape returned by /auth/login/email, /auth/verify/otp, /auth/refresh
// Server wraps under { success, message, data: { accessToken, refreshToken, user } }
class AuthTokenResponse {
  final String accessToken;
  final String? refreshToken;
  final UserModel? user;

  const AuthTokenResponse({
    required this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory AuthTokenResponse.fromJson(Map<String, dynamic> json) {
    // Unwrap from { data: { ... } } if present
    final payload = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    return AuthTokenResponse(
      accessToken: payload['accessToken'] as String,
      refreshToken: payload['refreshToken'] as String?,
      user: payload['user'] != null
          ? UserModel.fromJson(payload['user'] as Map<String, dynamic>)
          : null,
    );
  }
}

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
  factory PaginatedUsersResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedUsersResponse(
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => UserModel.fromJson(e))
            .toList(),
        pagination: json['pagination'] != null
            ? PaginationMeta.fromJson(json['pagination'])
            : null,
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
  factory PaginatedStoresResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedStoresResponse(
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => StoreModel.fromJson(e))
            .toList(),
        pagination: json['pagination'] != null
            ? PaginationMeta.fromJson(json['pagination'])
            : null,
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
  factory PaginatedSystemsResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedSystemsResponse(
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => SystemModel.fromJson(e))
            .toList(),
        pagination: json['pagination'] != null
            ? PaginationMeta.fromJson(json['pagination'])
            : null,
      );
}

// --- BOOKINGS ---
class BookingResponse extends SuccessResponse<BookingModel> {
  const BookingResponse({super.message, super.data});
  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      BookingResponse(
        message: json['message'] as String?,
        data: json['data'] != null ? BookingModel.fromJson(json['data']) : null,
      );
}

class PaginatedBookingsResponse extends PaginatedSuccessResponse<BookingModel> {
  const PaginatedBookingsResponse({
    super.message,
    super.data,
    super.pagination,
  });
  factory PaginatedBookingsResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedBookingsResponse(
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => BookingModel.fromJson(e))
            .toList(),
        pagination: json['pagination'] != null
            ? PaginationMeta.fromJson(json['pagination'])
            : null,
      );
}

// --- SESSIONS ---
class SessionResponse extends SuccessResponse<SessionModel> {
  const SessionResponse({super.message, super.data});
  factory SessionResponse.fromJson(Map<String, dynamic> json) =>
      SessionResponse(
        message: json['message'] as String?,
        data: json['data'] != null ? SessionModel.fromJson(json['data']) : null,
      );
}

class PaginatedSessionsResponse extends PaginatedSuccessResponse<SessionModel> {
  const PaginatedSessionsResponse({
    super.message,
    super.data,
    super.pagination,
  });
  factory PaginatedSessionsResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedSessionsResponse(
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => SessionModel.fromJson(e))
            .toList(),
        pagination: json['pagination'] != null
            ? PaginationMeta.fromJson(json['pagination'])
            : null,
      );
}

// --- PAYMENTS ---
class PaymentResponse extends SuccessResponse<PaymentModel> {
  const PaymentResponse({super.message, super.data});
  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      PaymentResponse(
        message: json['message'] as String?,
        data: json['data'] != null ? PaymentModel.fromJson(json['data']) : null,
      );
}

class PaginatedPaymentsResponse extends PaginatedSuccessResponse<PaymentModel> {
  const PaginatedPaymentsResponse({
    super.message,
    super.data,
    super.pagination,
  });
  factory PaginatedPaymentsResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedPaymentsResponse(
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => PaymentModel.fromJson(e))
            .toList(),
        pagination: json['pagination'] != null
            ? PaginationMeta.fromJson(json['pagination'])
            : null,
      );
}

// --- CAMPAIGNS ---
class CampaignResponse extends SuccessResponse<CampaignModel> {
  const CampaignResponse({super.message, super.data});
  factory CampaignResponse.fromJson(Map<String, dynamic> json) =>
      CampaignResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? CampaignModel.fromJson(json['data'])
            : null,
      );
}

class PaginatedCampaignsResponse
    extends PaginatedSuccessResponse<CampaignModel> {
  const PaginatedCampaignsResponse({
    super.message,
    super.data,
    super.pagination,
  });
  factory PaginatedCampaignsResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedCampaignsResponse(
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => CampaignModel.fromJson(e))
            .toList(),
        pagination: json['pagination'] != null
            ? PaginationMeta.fromJson(json['pagination'])
            : null,
      );
}

class PaginatedSystemTypesResponse
    extends PaginatedSuccessResponse<SystemTypeModel> {
  const PaginatedSystemTypesResponse({
    super.message,
    super.data,
    super.pagination,
  });

  factory PaginatedSystemTypesResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedSystemTypesResponse(
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => SystemTypeModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        pagination: json['pagination'] != null
            ? PaginationMeta.fromJson(json['pagination'])
            : null,
      );
}

class TransactionResponse extends SuccessResponse<TransactionModel> {
  const TransactionResponse({super.message, super.data});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      TransactionResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? TransactionModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
}

class PaginatedTransactionsResponse
    extends PaginatedSuccessResponse<TransactionModel> {
  const PaginatedTransactionsResponse({
    super.message,
    super.data,
    super.pagination,
  });

  factory PaginatedTransactionsResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedTransactionsResponse(
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        pagination: json['pagination'] != null
            ? PaginationMeta.fromJson(json['pagination'])
            : null,
      );
}

class PaginatedSessionLogsResponse
    extends PaginatedSuccessResponse<SessionLogModel> {
  const PaginatedSessionLogsResponse({
    super.message,
    super.data,
    super.pagination,
  });

  factory PaginatedSessionLogsResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedSessionLogsResponse(
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => SessionLogModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        pagination: json['pagination'] != null
            ? PaginationMeta.fromJson(json['pagination'])
            : null,
      );
}

// --- CREDIT BALANCE ---
class CreditBalanceResponse extends SuccessResponse<CreditBalanceModel> {
  const CreditBalanceResponse({super.message, super.data});

  factory CreditBalanceResponse.fromJson(Map<String, dynamic> json) =>
      CreditBalanceResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? CreditBalanceModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
}

// --- CREDIT LEDGER (transactions) ---
class PaginatedCreditLedgerResponse
    extends PaginatedSuccessResponse<CreditLedgerModel> {
  const PaginatedCreditLedgerResponse({
    super.message,
    super.data,
    super.pagination,
  });

  factory PaginatedCreditLedgerResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedCreditLedgerResponse(
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => CreditLedgerModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        pagination: json['pagination'] != null
            ? PaginationMeta.fromJson(json['pagination'])
            : null,
      );
}

// --- SYSTEMS (available systems list) ---
class SystemsListResponse extends SuccessResponse<List<SystemModel>> {
  const SystemsListResponse({super.message, super.data});

  factory SystemsListResponse.fromJson(Map<String, dynamic> json) {
    final rawSystems =
        json['systems'] as List<dynamic>? ?? json['data'] as List<dynamic>?;
    return SystemsListResponse(
      message: json['message'] as String?,
      data: rawSystems
          ?.map((e) => SystemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// --- BOOKING AVAILABILITY SLOTS ---
// Returns { slots: [{ startTime, endTime, status, systemCount }] }
class AvailabilitySlot {
  final String? startTime;
  final String? endTime;
  final String? status;
  final int? systemCount;

  const AvailabilitySlot({
    this.startTime,
    this.endTime,
    this.status,
    this.systemCount,
  });

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) =>
      AvailabilitySlot(
        startTime: json['startTime']?.toString(),
        endTime: json['endTime']?.toString(),
        status: json['status']?.toString(),
        systemCount: json['systemCount'] as int?,
      );
}

class AvailabilityResponse extends SuccessResponse<List<AvailabilitySlot>> {
  const AvailabilityResponse({super.message, super.data});

  factory AvailabilityResponse.fromJson(Map<String, dynamic> json) {
    final rawSlots =
        json['slots'] as List<dynamic>? ?? json['data'] as List<dynamic>?;
    return AvailabilityResponse(
      message: json['message'] as String?,
      data: rawSlots
          ?.map((e) => AvailabilitySlot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// --- CAMPAIGN REDEMPTION ---
class CampaignRedemptionResponse
    extends SuccessResponse<CampaignRedemptionModel> {
  const CampaignRedemptionResponse({super.message, super.data});

  factory CampaignRedemptionResponse.fromJson(Map<String, dynamic> json) =>
      CampaignRedemptionResponse(
        message: json['message'] as String?,
        data: json['redemption'] != null
            ? CampaignRedemptionModel.fromJson(
                json['redemption'] as Map<String, dynamic>,
              )
            : null,
      );
}

// --- NOTIFICATIONS ---
class NotificationListResponse
    extends SuccessResponse<List<NotificationModel>> {
  final int? unreadCount;

  const NotificationListResponse({super.message, super.data, this.unreadCount});

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    final rawNotifications =
        json['notifications'] as List<dynamic>? ??
        json['data'] as List<dynamic>?;
    return NotificationListResponse(
      message: json['message'] as String?,
      unreadCount: json['unreadCount'] as int?,
      data: rawNotifications
          ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class NotificationResponse extends SuccessResponse<NotificationModel> {
  const NotificationResponse({super.message, super.data});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) =>
      NotificationResponse(
        message: json['message'] as String?,
        data: json['notification'] != null
            ? NotificationModel.fromJson(
                json['notification'] as Map<String, dynamic>,
              )
            : null,
      );
}

class NotificationPreferencesResponse
    extends SuccessResponse<Map<String, bool>> {
  const NotificationPreferencesResponse({super.message, super.data});

  factory NotificationPreferencesResponse.fromJson(Map<String, dynamic> json) =>
      NotificationPreferencesResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? Map<String, bool>.from(json['data'] as Map)
            : null,
      );
}

// --- DISPUTES ---
class DisputeResponse extends SuccessResponse<BillingDisputeModel> {
  const DisputeResponse({super.message, super.data});

  factory DisputeResponse.fromJson(Map<String, dynamic> json) =>
      DisputeResponse(
        message: json['message'] as String?,
        data: json['dispute'] != null
            ? BillingDisputeModel.fromJson(
                json['dispute'] as Map<String, dynamic>,
              )
            : null,
      );
}

class DisputeListResponse extends SuccessResponse<List<BillingDisputeModel>> {
  const DisputeListResponse({super.message, super.data});

  factory DisputeListResponse.fromJson(Map<String, dynamic> json) {
    final rawDisputes =
        json['disputes'] as List<dynamic>? ?? json['data'] as List<dynamic>?;
    return DisputeListResponse(
      message: json['message'] as String?,
      data: rawDisputes
          ?.map((e) => BillingDisputeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
