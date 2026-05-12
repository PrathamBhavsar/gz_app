# RULE: DATA LAYER
> **Enforcement Level**: CRITICAL — Raw API calls from UI or Notifiers = catastrophic violation.

## THE LAW: SERVICE → REPOSITORY CHAIN

Data flow: `Widget → Notifier → Repository → Service → ApiClient → API`

No widget, notifier, or provider calls `ApiClient` or `http` directly.

---

## API CLIENT (`lib/core/api/api_client.dart`)

`ApiClient` uses the `http` package (NOT Dio). It is provided via `apiClientProvider`:

```dart
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: ApiConstants.baseUrl,
    getAccessToken: () => ref.read(accessTokenProvider),
    onRefreshToken: () async { ... }, // silent refresh logic
    onLogout: () async { ... },       // clear tokens
  );
});
```

Methods: `get(endpoint)`, `post(endpoint, {body})`, `patch(endpoint, {body})`, `delete(endpoint, {body})`.
All return `dynamic` (parsed JSON). All throw typed `AppException` subclasses on error.

---

## API CONSTANTS (`lib/core/api/api_constants.dart`)

All endpoint paths are constants in `ApiConstants`. Endpoints use `{storeId}`, `{id}` placeholder strings — **services interpolate these** before calling the client:

```dart
// ✅ Correct — interpolate in service
final endpoint = ApiConstants.sessionDetail
    .replaceAll('{storeId}', storeId)
    .replaceAll('{id}', sessionId);
final data = await _apiClient.get(endpoint);

// ❌ Wrong — hardcoded path
final data = await _apiClient.get('/stores/$storeId/sessions/$id');
```

---

## MODELS — HAND-WRITTEN ONLY

**No `@freezed`. No `@JsonSerializable`. No `build_runner`.**

All models live in `lib/models/`:
- `core.dart` — `BaseApiResponse`, `SuccessResponse<T>`, `PaginatedSuccessResponse<T>`, `PaginationMeta`
- `domain_global.dart` — `UserModel`, `StoreModel`
- `domain_systems.dart`, `domain_billing.dart`, `domain_loyalty.dart`, `domain_misc.dart`, `domain_analytics.dart`, `domain_admin.dart`
- `api_responses.dart` — typed response wrappers for player endpoints
- `api_responses_admin.dart` — typed response wrappers for admin endpoints
- `enums.dart` — shared enums

Model structure:
```dart
class BookingModel {
  final String id;
  final String status;
  final String systemId;
  final DateTime startTime;
  final DateTime endTime;

  const BookingModel({
    required this.id,
    required this.status,
    required this.systemId,
    required this.startTime,
    required this.endTime,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
    id: json['id'] as String,
    status: json['status'] as String,
    systemId: (json['systemId'] ?? json['system_id']) as String,
    startTime: DateTime.parse(json['startTime'] ?? json['start_time']),
    endTime: DateTime.parse(json['endTime'] ?? json['end_time']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'system_id': systemId,
    'start_time': startTime.toIso8601String(),
    'end_time': endTime.toIso8601String(),
  };
}
```

**Rules**: Handle both camelCase and snake_case keys (`json['startTime'] ?? json['start_time']`). Dates as `DateTime`. Nullable fields use `?`. No business logic in models.

---

## RESPONSE WRAPPERS

Use `SuccessResponse<T>` for single-item responses, `PaginatedSuccessResponse<T>` for lists:

```dart
class BookingResponse extends SuccessResponse<BookingModel> {
  const BookingResponse({super.message, super.data});
  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      BookingResponse(
        message: json['message'] as String?,
        data: json['data'] != null
            ? BookingModel.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
}
```

---

## SERVICE STRUCTURE

```dart
class BookingService {
  final ApiClient _apiClient;
  BookingService(this._apiClient);

  Future<BookingResponse> getBooking(String storeId, String id) async {
    final endpoint = ApiConstants.bookingsList  // use the closest constant
        .replaceAll('{storeId}', storeId);
    final data = await _apiClient.get('$endpoint/$id');
    return BookingResponse.fromJson(data as Map<String, dynamic>);
  }

  Future<BookingResponse> createBooking(String storeId, Map<String, dynamic> body) async {
    final endpoint = ApiConstants.bookingsList
        .replaceAll('{storeId}', storeId);
    final data = await _apiClient.post(endpoint, body: body);
    return BookingResponse.fromJson(data as Map<String, dynamic>);
  }
}

final bookingServiceProvider = Provider<BookingService>((ref) {
  return BookingService(ref.watch(apiClientProvider));
});
```

---

## REPOSITORY STRUCTURE

Repositories:
1. Call `NetworkChecker.assertConnection()` before every API call
2. Delegate to Service
3. May transform data (combine calls, filter, etc.)
4. Never catch or re-map exceptions — let `AppException` propagate

```dart
class BookingRepository {
  final BookingService _service;
  final NetworkChecker _networkChecker;

  BookingRepository(this._service, this._networkChecker);

  Future<BookingResponse> getBooking(String storeId, String id) async {
    await _networkChecker.assertConnection();
    return _service.getBooking(storeId, id);
  }

  Future<BookingModel> createBooking(String storeId, CreateBookingParams params) async {
    await _networkChecker.assertConnection();
    final res = await _service.createBooking(storeId, params.toJson());
    if (res.data == null) throw Exception('No booking data returned');
    return res.data!;
  }
}

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository(
    ref.watch(bookingServiceProvider),
    ref.watch(networkCheckerProvider),
  );
});
```

---

## REQUEST PARAMS

Use plain Dart classes with `toJson()` for request bodies:

```dart
class CreateBookingParams {
  final String systemId;
  final DateTime startTime;
  final DateTime endTime;
  final String paymentMethod;
  final String? campaignId;
  final int? creditsToRedeem;

  const CreateBookingParams({
    required this.systemId,
    required this.startTime,
    required this.endTime,
    required this.paymentMethod,
    this.campaignId,
    this.creditsToRedeem,
  });

  Map<String, dynamic> toJson() => {
    'systemId': systemId,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
    'paymentMethod': paymentMethod,
    if (campaignId != null) 'campaignId': campaignId,
    if (creditsToRedeem != null) 'creditsToRedeem': creditsToRedeem,
  };
}
```

---

## FORBIDDEN

| Violation | Why |
|---|---|
| `http.get/post` inside Notifier or Widget | Bypasses error handling layer |
| `Map<String, dynamic>` as return type from Repository | Use typed models |
| Swallowed exceptions | Always propagate `AppException` |
| `freezed`/`json_serializable` | Not in this project |
| Business logic in Service methods | Services fetch/parse only |
| Hardcoded URLs | Use `ApiConstants.*` |
