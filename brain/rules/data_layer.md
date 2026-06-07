# RULE: DATA LAYER
> **Enforcement Level**: CRITICAL

1. **Repository Pattern:** Data flow is `Widget → Notifier → Repository → Dio → API`. No direct Dio calls from UI.
2. **Models:** All models MUST use `@freezed` and `@JsonSerializable`. All fields `final`. 
3. **Exception Mapping:** Repositories must catch `DioException` and rethrow as a custom sealed `AppException`. Swallowing errors is a violation.
