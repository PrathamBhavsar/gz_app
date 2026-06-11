import '../../../../core/auth/token_storage.dart';
import '../../../../core/errors/app_exception.dart';

Future<String> adminStorePath(
  TokenStorage storage,
  String template, {
  String? id,
}) async {
  final storeId = await storage.getAdminStoreId();
  if (storeId == null || storeId.isEmpty) {
    throw const ValidationException('Missing admin store context');
  }

  var path = template.replaceAll('{storeId}', storeId).replaceAll('{id}', id ?? storeId);
  if (id != null) {
    path = path.replaceAll('{id}', id);
  }
  return path;
}

Map<String, dynamic> adminStoreAsMap(
  dynamic value, {
  required String responseName,
}) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map(
      (key, mapValue) => MapEntry(key.toString(), mapValue),
    );
  }
  throw ApiException(
    statusCode: 500,
    message: 'Expected object response from $responseName API',
  );
}

List<dynamic> adminStoreExtractList(
  Map<String, dynamic> raw, {
  List<String> dataKeys = const [],
}) {
  final data = raw['data'];
  if (data is List) {
    return data;
  }
  if (data is Map) {
    final map = adminStoreAsMap(data, responseName: 'admin store');
    for (final key in dataKeys) {
      final nested = map[key];
      if (nested is List) {
        return nested;
      }
    }
  }

  for (final key in dataKeys) {
    final nested = raw[key];
    if (nested is List) {
      return nested;
    }
  }

  return const [];
}
