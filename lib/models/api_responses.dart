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
  factory SystemResponse.fromJson(Map<String, dynamic> json) {
    // The backend nests the system one level deeper: `data: { system: {...} }`.
    final data = json['data'];
    final systemJson = data is Map<String, dynamic>
        ? (data['system'] as Map<String, dynamic>? ?? data)
        : null;
    return SystemResponse(
      message: json['message'] as String?,
      data: systemJson != null ? SystemModel.fromJson(systemJson) : null,
    );
  }
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
  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    // The backend nests the booking one level deeper: `data: { booking: {...} }`.
    final data = json['data'];
    final bookingJson = data is Map<String, dynamic>
        ? (data['booking'] as Map<String, dynamic>? ?? data)
        : null;
    return BookingResponse(
      message: json['message'] as String?,
      data: bookingJson != null ? BookingModel.fromJson(bookingJson) : null,
    );
  }
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
        data: () {
          final payload = json['data'];
          if (payload is Map<String, dynamic>) {
            final session = payload['session'];
            if (session is Map<String, dynamic>) {
              return SessionModel.fromJson(session);
            }
            return SessionModel.fromJson(payload);
          }
          return null;
        }(),
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
  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    // The backend nests the payment one level deeper: `data: { payment: {...} }`.
    final data = json['data'];
    final paymentJson = data is Map<String, dynamic>
        ? (data['payment'] as Map<String, dynamic>? ?? data)
        : null;
    return PaymentResponse(
      message: json['message'] as String?,
      data: paymentJson != null ? PaymentModel.fromJson(paymentJson) : null,
    );
  }
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
  factory CampaignResponse.fromJson(Map<String, dynamic> json) {
    // The backend nests the campaign one level deeper: `data: { campaign: {...} }`.
    final data = json['data'];
    final campaignJson = data is Map<String, dynamic>
        ? (data['campaign'] as Map<String, dynamic>? ?? data)
        : null;
    return CampaignResponse(
      message: json['message'] as String?,
      data: campaignJson != null ? CampaignModel.fromJson(campaignJson) : null,
    );
  }
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

// --- BOOKING TIME WINDOW ---
// Client-picked start/end for a booking. The backend has no endpoint that
// buckets a day into hourly slots, so this is built locally from a chosen
// start time rather than parsed from an API response.
class AvailabilitySlot {
  final String? startTime;
  final String? endTime;

  const AvailabilitySlot({this.startTime, this.endTime});
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
    final data = json['data'];
    final dataMap = data is Map<String, dynamic> ? data : null;
    final meta = dataMap?['meta'] is Map<String, dynamic>
        ? dataMap!['meta'] as Map<String, dynamic>
        : null;
    final rawNotifications = json['notifications'] is List<dynamic>
        ? json['notifications'] as List<dynamic>
        : dataMap?['notifications'] is List<dynamic>
        ? dataMap!['notifications'] as List<dynamic>
        : data is List<dynamic>
        ? data
        : null;
    return NotificationListResponse(
      message: json['message'] as String?,
      unreadCount: (json['unreadCount'] ?? meta?['unreadCount']) as int?,
      data: rawNotifications
          ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class NotificationResponse extends SuccessResponse<NotificationModel> {
  const NotificationResponse({super.message, super.data});

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    // The backend nests the notification one level deeper:
    // `data: { notification: {...} }`.
    final data = json['data'];
    final notificationJson = data is Map<String, dynamic>
        ? (data['notification'] as Map<String, dynamic>? ?? data)
        : null;
    return NotificationResponse(
      message: json['message'] as String?,
      data: notificationJson != null
          ? NotificationModel.fromJson(notificationJson)
          : null,
    );
  }
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

  factory DisputeResponse.fromJson(Map<String, dynamic> json) {
    final payload = _extractDisputeObject(json);
    return DisputeResponse(
      message: json['message'] as String?,
      data: payload == null ? null : BillingDisputeModel.fromJson(payload),
    );
  }
}

class DisputeListResponse extends SuccessResponse<List<BillingDisputeModel>> {
  const DisputeListResponse({super.message, super.data});

  factory DisputeListResponse.fromJson(Map<String, dynamic> json) {
    final rawDisputes = _extractDisputeList(json);
    return DisputeListResponse(
      message: json['message'] as String?,
      data: rawDisputes
          ?.map((e) => BillingDisputeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

Map<String, dynamic>? _extractDisputeObject(Map<String, dynamic> json) {
  final dispute = json['dispute'];
  if (dispute is Map<String, dynamic>) {
    return dispute;
  }
  if (dispute is Map) {
    return dispute.map((key, value) => MapEntry(key.toString(), value));
  }

  final data = json['data'];
  if (data is Map<String, dynamic>) {
    final nested = data['dispute'];
    if (nested is Map<String, dynamic>) {
      return nested;
    }
    if (nested is Map) {
      return nested.map((key, value) => MapEntry(key.toString(), value));
    }
    return data;
  }
  if (data is Map) {
    return data.map((key, value) => MapEntry(key.toString(), value));
  }

  return null;
}

List<dynamic>? _extractDisputeList(Map<String, dynamic> json) {
  final disputes = json['disputes'];
  if (disputes is List<dynamic>) {
    return disputes;
  }

  final data = json['data'];
  if (data is List<dynamic>) {
    return data;
  }
  if (data is Map<String, dynamic>) {
    final nested = data['disputes'];
    if (nested is List<dynamic>) {
      return nested;
    }
  }
  if (data is Map) {
    final map = data.map((key, value) => MapEntry(key.toString(), value));
    final nested = map['disputes'];
    if (nested is List<dynamic>) {
      return nested;
    }
  }

  return null;
}

// --- BILLING ROW (player billing history) ---
class BillingRow {
  final String id;
  final String storeId;
  final String? sessionId;
  final String? storeName;
  final String? systemName;
  final DateTime? date;
  final int? durationMinutes;
  final double amount;
  final String? method;
  final String? status;

  const BillingRow({
    required this.id,
    required this.storeId,
    this.sessionId,
    this.storeName,
    this.systemName,
    this.date,
    this.durationMinutes,
    required this.amount,
    this.method,
    this.status,
  });

  factory BillingRow.fromJson(Map<String, dynamic> json) => BillingRow(
    id: json['id']?.toString() ?? '',
    storeId: (json['store_id'] ?? json['storeId'])?.toString() ?? '',
    sessionId: (json['session_id'] ?? json['sessionId'])?.toString(),
    storeName: json['store_name']?.toString() ?? json['storeName']?.toString(),
    systemName:
        json['system_name']?.toString() ?? json['systemName']?.toString(),
    // Billing ledger rows carry no bare `date`/`duration_minutes`/`amount` —
    // the sanitized shape uses `billedFrom`/`billedMinutes`/`netAmount`.
    date: (json['date'] ?? json['billed_from'] ?? json['billedFrom']) != null
        ? DateTime.tryParse(
            (json['date'] ?? json['billed_from'] ?? json['billedFrom'])
                .toString(),
          )
        : null,
    durationMinutes:
        (json['duration_minutes'] ??
                json['durationMinutes'] ??
                json['billedMinutes'])
            as int?,
    amount:
        double.tryParse(
          (json['amount'] ?? json['net_amount'] ?? json['netAmount'])
                  ?.toString() ??
              '',
        ) ??
        0.0,
    // Billing ledger rows have no `method`/`status` of their own — those
    // live on the joined payment record, exposed as `paymentMethod`/`paymentStatus`.
    method: json['method']?.toString() ?? json['paymentMethod']?.toString(),
    status: json['status']?.toString() ?? json['paymentStatus']?.toString(),
  );
}

class PaginatedBillingResponse extends PaginatedSuccessResponse<BillingRow> {
  const PaginatedBillingResponse({super.message, super.data, super.pagination});

  factory PaginatedBillingResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedBillingResponse(
        message: json['message'] as String?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => BillingRow.fromJson(e as Map<String, dynamic>))
            .toList(),
        pagination: json['pagination'] != null
            ? PaginationMeta.fromJson(json['pagination'])
            : null,
      );
}
