abstract class BaseApiResponse {
  final bool? success;
  final String? message;

  const BaseApiResponse({this.success, this.message});
}

class FailureResponse extends BaseApiResponse {
  final String? error;
  final int? statusCode;

  const FailureResponse({
    bool? success = false,
    String? message,
    this.error,
    this.statusCode,
  }) : super(success: success, message: message);

  factory FailureResponse.fromJson(Map<String, dynamic> json) {
    return FailureResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      error: json['error'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'error': error,
      'statusCode': statusCode,
    };
  }
}

class PaginationMeta {
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;
  final int? itemsPerPage;

  const PaginationMeta({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.itemsPerPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['currentPage'] as int?,
      totalPages: json['totalPages'] as int?,
      totalItems: json['totalItems'] as int?,
      itemsPerPage: json['itemsPerPage'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
    };
  }
}

abstract class SuccessResponse<T> extends BaseApiResponse {
  final T? data;

  const SuccessResponse({
    bool? success = true,
    String? message,
    this.data,
  }) : super(success: success, message: message);
}

abstract class PaginatedSuccessResponse<T> extends SuccessResponse<List<T>> {
  final PaginationMeta? pagination;

  const PaginatedSuccessResponse({
    bool? success = true,
    String? message,
    List<T>? data,
    this.pagination,
  }) : super(success: success, message: message, data: data);
}
