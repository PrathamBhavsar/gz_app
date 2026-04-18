import 'enums.dart';

class UserModel {
  final String? id;
  final String? phone;
  final String? email;
  final String? name;
  final bool? isVerified;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    this.id,
    this.phone,
    this.email,
    this.name,
    this.isVerified,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id']?.toString(),
    phone: json['phone']?.toString(),
    email: json['email']?.toString(),
    name: json['name']?.toString(),
    isVerified: (json['isVerified'] ?? json['is_verified']) as bool?,
    metadata: json['metadata'] as Map<String, dynamic>?,
    createdAt: (json['createdAt'] ?? json['created_at']) != null
        ? DateTime.tryParse(
            (json['createdAt'] ?? json['created_at']).toString(),
          )
        : null,
    updatedAt: (json['updatedAt'] ?? json['updated_at']) != null
        ? DateTime.tryParse(
            (json['updatedAt'] ?? json['updated_at']).toString(),
          )
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'phone': phone,
    'email': email,
    'name': name,
    'is_verified': isVerified,
    'metadata': metadata,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

class StoreModel {
  final String? id;
  final String? name;
  final String? slug;
  final String? address;
  final String? city;
  final String? country;
  final String? timezone;
  final String? currency;
  final bool? isActive;
  final Map<String, dynamic>? settings;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StoreModel({
    this.id,
    this.name,
    this.slug,
    this.address,
    this.city,
    this.country,
    this.timezone,
    this.currency,
    this.isActive,
    this.settings,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
    id: json['id']?.toString(),
    name: json['name']?.toString(),
    slug: json['slug']?.toString(),
    address: json['address']?.toString(),
    city: json['city']?.toString(),
    country: json['country']?.toString(),
    timezone: json['timezone']?.toString(),
    currency: json['currency']?.toString(),
    isActive: (json['isActive'] ?? json['is_active']) as bool?,
    settings: json['settings'] as Map<String, dynamic>?,
    createdAt: (json['createdAt'] ?? json['created_at']) != null
        ? DateTime.tryParse(
            (json['createdAt'] ?? json['created_at']).toString(),
          )
        : null,
    updatedAt: (json['updatedAt'] ?? json['updated_at']) != null
        ? DateTime.tryParse(
            (json['updatedAt'] ?? json['updated_at']).toString(),
          )
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'address': address,
    'city': city,
    'country': country,
    'timezone': timezone,
    'currency': currency,
    'is_active': isActive,
    'settings': settings,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

class UserCredentialModel {
  final String? id;
  final String? userId;
  final AuthMethod? authMethod;
  final String? identifier;
  final String? secretHash;
  final bool? isVerified;
  final DateTime? verifiedAt;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserCredentialModel({
    this.id,
    this.userId,
    this.authMethod,
    this.identifier,
    this.secretHash,
    this.isVerified,
    this.verifiedAt,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory UserCredentialModel.fromJson(Map<String, dynamic> json) =>
      UserCredentialModel(
        id: json['id']?.toString(),
        userId: json['user_id']?.toString(),
        authMethod: json['auth_method']?.toString().toAuthMethod(),
        identifier: json['identifier']?.toString(),
        secretHash: json['secret_hash']?.toString(),
        isVerified: json['is_verified'] as bool?,
        verifiedAt: json['verified_at'] != null
            ? DateTime.tryParse(json['verified_at'].toString())
            : null,
        metadata: json['metadata'] as Map<String, dynamic>?,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'].toString())
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'auth_method': authMethod?.name,
    'identifier': identifier,
    'secret_hash': secretHash,
    'is_verified': isVerified,
    'verified_at': verifiedAt?.toIso8601String(),
    'metadata': metadata,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

class UserSessionModel {
  final String? id;
  final String? userId;
  final String? refreshTokenHash;
  final Map<String, dynamic>? deviceInfo;
  final String? ipAddress;
  final DateTime? expiresAt;
  final DateTime? revokedAt;
  final DateTime? createdAt;

  const UserSessionModel({
    this.id,
    this.userId,
    this.refreshTokenHash,
    this.deviceInfo,
    this.ipAddress,
    this.expiresAt,
    this.revokedAt,
    this.createdAt,
  });

  factory UserSessionModel.fromJson(Map<String, dynamic> json) =>
      UserSessionModel(
        id: json['id']?.toString(),
        userId: json['user_id']?.toString(),
        refreshTokenHash: json['refresh_token_hash']?.toString(),
        deviceInfo: json['device_info'] as Map<String, dynamic>?,
        ipAddress: json['ip_address']?.toString(),
        expiresAt: json['expires_at'] != null
            ? DateTime.tryParse(json['expires_at'].toString())
            : null,
        revokedAt: json['revoked_at'] != null
            ? DateTime.tryParse(json['revoked_at'].toString())
            : null,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'refresh_token_hash': refreshTokenHash,
    'device_info': deviceInfo,
    'ip_address': ipAddress,
    'expires_at': expiresAt?.toIso8601String(),
    'revoked_at': revokedAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
  };
}

class VerificationTokenModel {
  final String? id;
  final String? userId;
  final VerificationPurpose? purpose;
  final String? tokenHash;
  final String? identifier;
  final DateTime? expiresAt;
  final DateTime? verifiedAt;
  final int? attemptCount;
  final int? maxAttempts;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;

  const VerificationTokenModel({
    this.id,
    this.userId,
    this.purpose,
    this.tokenHash,
    this.identifier,
    this.expiresAt,
    this.verifiedAt,
    this.attemptCount,
    this.maxAttempts,
    this.metadata,
    this.createdAt,
  });

  factory VerificationTokenModel.fromJson(Map<String, dynamic> json) =>
      VerificationTokenModel(
        id: json['id']?.toString(),
        userId: json['user_id']?.toString(),
        purpose: json['purpose']?.toString().toVerificationPurpose(),
        tokenHash: json['token_hash']?.toString(),
        identifier: json['identifier']?.toString(),
        expiresAt: json['expires_at'] != null
            ? DateTime.tryParse(json['expires_at'].toString())
            : null,
        verifiedAt: json['verified_at'] != null
            ? DateTime.tryParse(json['verified_at'].toString())
            : null,
        attemptCount: json['attempt_count'] as int?,
        maxAttempts: json['max_attempts'] as int?,
        metadata: json['metadata'] as Map<String, dynamic>?,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'purpose': purpose?.name,
    'token_hash': tokenHash,
    'identifier': identifier,
    'expires_at': expiresAt?.toIso8601String(),
    'verified_at': verifiedAt?.toIso8601String(),
    'attempt_count': attemptCount,
    'max_attempts': maxAttempts,
    'metadata': metadata,
    'created_at': createdAt?.toIso8601String(),
  };
}

class UserIdentifierModel {
  final String? id;
  final String? userId;
  final String? storeId;
  final String? identifierType;
  final String? identifierValue;
  final DateTime? linkedAt;
  final Map<String, dynamic>? metadata;

  const UserIdentifierModel({
    this.id,
    this.userId,
    this.storeId,
    this.identifierType,
    this.identifierValue,
    this.linkedAt,
    this.metadata,
  });

  factory UserIdentifierModel.fromJson(Map<String, dynamic> json) =>
      UserIdentifierModel(
        id: json['id']?.toString(),
        userId: json['user_id']?.toString(),
        storeId: json['store_id']?.toString(),
        identifierType: json['identifier_type']?.toString(),
        identifierValue: json['identifier_value']?.toString(),
        linkedAt: json['linked_at'] != null
            ? DateTime.tryParse(json['linked_at'].toString())
            : null,
        metadata: json['metadata'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'store_id': storeId,
    'identifier_type': identifierType,
    'identifier_value': identifierValue,
    'linked_at': linkedAt?.toIso8601String(),
    'metadata': metadata,
  };
}
