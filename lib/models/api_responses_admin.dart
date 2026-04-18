import 'core.dart';
import 'domain_admin.dart';
import 'domain_analytics.dart';

// ============================================================
// Admin Auth Responses
// ============================================================

class AdminLoginResponse extends SuccessResponse<AdminAuthTokenResponse> {
  const AdminLoginResponse({super.message, super.data});

  factory AdminLoginResponse.fromJson(Map<String, dynamic> json) =>
      AdminLoginResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? AdminAuthTokenResponse.fromJson(
                json['data'] as Map<String, dynamic>,
              )
            : null,
      );
}

class AdminProfileResponse extends SuccessResponse<AdminAuthModel> {
  const AdminProfileResponse({super.message, super.data});

  factory AdminProfileResponse.fromJson(Map<String, dynamic> json) =>
      AdminProfileResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? AdminAuthModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
}

// ============================================================
// Store Config Responses
// ============================================================

class StoreConfigResponse extends SuccessResponse<StoreConfigModel> {
  const StoreConfigResponse({super.message, super.data});

  factory StoreConfigResponse.fromJson(Map<String, dynamic> json) =>
      StoreConfigResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? StoreConfigModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
}

// ============================================================
// Analytics Responses
// ============================================================

class AnalyticsDashboardResponse
    extends SuccessResponse<AnalyticsDashboardModel> {
  const AnalyticsDashboardResponse({super.message, super.data});

  factory AnalyticsDashboardResponse.fromJson(Map<String, dynamic> json) =>
      AnalyticsDashboardResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? AnalyticsDashboardModel.fromJson(
                json['data'] as Map<String, dynamic>,
              )
            : null,
      );
}

class RevenueAnalyticsResponse extends SuccessResponse<RevenueAnalyticsModel> {
  const RevenueAnalyticsResponse({super.message, super.data});

  factory RevenueAnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      RevenueAnalyticsResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? RevenueAnalyticsModel.fromJson(
                json['data'] as Map<String, dynamic>,
              )
            : null,
      );
}

class UtilizationResponse extends SuccessResponse<UtilizationModel> {
  const UtilizationResponse({super.message, super.data});

  factory UtilizationResponse.fromJson(Map<String, dynamic> json) =>
      UtilizationResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? UtilizationModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
}

class SessionStatsResponse extends SuccessResponse<SessionStatsModel> {
  const SessionStatsResponse({super.message, super.data});

  factory SessionStatsResponse.fromJson(Map<String, dynamic> json) =>
      SessionStatsResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? SessionStatsModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
}

class PlayerAnalyticsResponse extends SuccessResponse<PlayerAnalyticsModel> {
  const PlayerAnalyticsResponse({super.message, super.data});

  factory PlayerAnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      PlayerAnalyticsResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? PlayerAnalyticsModel.fromJson(
                json['data'] as Map<String, dynamic>,
              )
            : null,
      );
}

class SystemPerformanceResponse
    extends SuccessResponse<SystemPerformanceModel> {
  const SystemPerformanceResponse({super.message, super.data});

  factory SystemPerformanceResponse.fromJson(Map<String, dynamic> json) =>
      SystemPerformanceResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? SystemPerformanceModel.fromJson(
                json['data'] as Map<String, dynamic>,
              )
            : null,
      );
}

// ============================================================
// Pricing Responses
// ============================================================

class PriceCalculationResponse extends SuccessResponse<PriceCalculationModel> {
  const PriceCalculationResponse({super.message, super.data});

  factory PriceCalculationResponse.fromJson(Map<String, dynamic> json) =>
      PriceCalculationResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? PriceCalculationModel.fromJson(
                json['data'] as Map<String, dynamic>,
              )
            : null,
      );
}

// ============================================================
// Billing Responses
// ============================================================

class RevenueSummaryResponse extends SuccessResponse<RevenueSummaryModel> {
  const RevenueSummaryResponse({super.message, super.data});

  factory RevenueSummaryResponse.fromJson(Map<String, dynamic> json) =>
      RevenueSummaryResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? RevenueSummaryModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
}

// ============================================================
// Payments Responses
// ============================================================

class ReconciliationResponse extends SuccessResponse<ReconciliationModel> {
  const ReconciliationResponse({super.message, super.data});

  factory ReconciliationResponse.fromJson(Map<String, dynamic> json) =>
      ReconciliationResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? ReconciliationModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
}

// ============================================================
// Live Systems Responses
// ============================================================

class LiveSystemsResponse extends SuccessResponse<List<LiveSystemStatusModel>> {
  const LiveSystemsResponse({super.message, super.data});

  factory LiveSystemsResponse.fromJson(Map<String, dynamic> json) =>
      LiveSystemsResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? (json['data'] as List)
                  .map(
                    (e) => LiveSystemStatusModel.fromJson(
                      e as Map<String, dynamic>,
                    ),
                  )
                  .toList()
            : null,
      );
}

// ============================================================
// Walk-In Booking Responses
// ============================================================

class WalkInBookingResponseWrapper
    extends SuccessResponse<WalkInBookingResponse> {
  const WalkInBookingResponseWrapper({super.message, super.data});

  factory WalkInBookingResponseWrapper.fromJson(Map<String, dynamic> json) =>
      WalkInBookingResponseWrapper(
        message: json['message'] as String?,
        data: json['data'] != null
            ? WalkInBookingResponse.fromJson(
                json['data'] as Map<String, dynamic>,
              )
            : null,
      );
}
