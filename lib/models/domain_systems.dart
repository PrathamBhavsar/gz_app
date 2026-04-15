import 'enums.dart';

class StoreAdminModel {
  final String? id;
  final String? storeId;
  final String? email;
  final String? name;
  final AdminRole? role;
  final String? passwordHash;
  final Map<String, dynamic>? permissions;
  final bool? isActive;
  final String? createdBy;
  final DateTime? lastLoginAt;
  final DateTime? lastPasswordChangeAt;
  final String? passwordResetToken;
  final DateTime? passwordResetExpiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StoreAdminModel({this.id, this.storeId, this.email, this.name, this.role, this.passwordHash, this.permissions, this.isActive, this.createdBy, this.lastLoginAt, this.lastPasswordChangeAt, this.passwordResetToken, this.passwordResetExpiresAt, this.createdAt, this.updatedAt});

  factory StoreAdminModel.fromJson(Map<String, dynamic> json) => StoreAdminModel(
    id: json['id']?.toString(),
    storeId: json['store_id']?.toString(),
    email: json['email']?.toString(),
    name: json['name']?.toString(),
    role: json['role']?.toString().toAdminRole(),
    passwordHash: json['password_hash']?.toString(),
    permissions: json['permissions'] as Map<String, dynamic>?,
    isActive: json['is_active'] as bool?,
    createdBy: json['created_by']?.toString(),
    lastLoginAt: json['last_login_at'] != null ? DateTime.tryParse(json['last_login_at'].toString()) : null,
    lastPasswordChangeAt: json['last_password_change_at'] != null ? DateTime.tryParse(json['last_password_change_at'].toString()) : null,
    passwordResetToken: json['password_reset_token']?.toString(),
    passwordResetExpiresAt: json['password_reset_expires_at'] != null ? DateTime.tryParse(json['password_reset_expires_at'].toString()) : null,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'store_id': storeId, 'email': email, 'name': name, 'role': role?.name, 'password_hash': passwordHash,
    'permissions': permissions, 'is_active': isActive, 'created_by': createdBy,
    'last_login_at': lastLoginAt?.toIso8601String(), 'last_password_change_at': lastPasswordChangeAt?.toIso8601String(),
    'password_reset_token': passwordResetToken, 'password_reset_expires_at': passwordResetExpiresAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(), 'updated_at': updatedAt?.toIso8601String(),
  };
}

class SystemTypeModel {
  final String? id;
  final String? storeId;
  final String? name;
  final String? description;
  final double? hourlyBaseRate;
  final Map<String, dynamic>? specs;
  final int? sortOrder;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SystemTypeModel({this.id, this.storeId, this.name, this.description, this.hourlyBaseRate, this.specs, this.sortOrder, this.isActive, this.createdAt, this.updatedAt});

  factory SystemTypeModel.fromJson(Map<String, dynamic> json) => SystemTypeModel(
    id: json['id']?.toString(),
    storeId: json['store_id']?.toString(),
    name: json['name']?.toString(),
    description: json['description']?.toString(),
    hourlyBaseRate: double.tryParse(json['hourly_base_rate']?.toString() ?? ''),
    specs: json['specs'] as Map<String, dynamic>?,
    sortOrder: json['sort_order'] as int?,
    isActive: json['is_active'] as bool?,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'store_id': storeId, 'name': name, 'description': description, 'hourly_base_rate': hourlyBaseRate,
    'specs': specs, 'sort_order': sortOrder, 'is_active': isActive,
    'created_at': createdAt?.toIso8601String(), 'updated_at': updatedAt?.toIso8601String(),
  };
}

class SystemModel {
  final String? id;
  final String? storeId;
  final String? systemTypeId;
  final String? name;
  final int? stationNumber;
  final SystemPlatform? platform;
  final SystemStatus? status;
  final String? ipAddress;
  final String? macAddress;
  final Map<String, dynamic>? specs;
  final DateTime? lastHeartbeatAt;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SystemModel({this.id, this.storeId, this.systemTypeId, this.name, this.stationNumber, this.platform, this.status, this.ipAddress, this.macAddress, this.specs, this.lastHeartbeatAt, this.isActive, this.createdAt, this.updatedAt});

  factory SystemModel.fromJson(Map<String, dynamic> json) => SystemModel(
    id: json['id']?.toString(),
    storeId: json['store_id']?.toString(),
    systemTypeId: json['system_type_id']?.toString(),
    name: json['name']?.toString(),
    stationNumber: json['station_number'] as int?,
    platform: json['platform']?.toString().toSystemPlatform(),
    status: json['status']?.toString().toSystemStatus(),
    ipAddress: json['ip_address']?.toString(),
    macAddress: json['mac_address']?.toString(),
    specs: json['specs'] as Map<String, dynamic>?,
    lastHeartbeatAt: json['last_heartbeat_at'] != null ? DateTime.tryParse(json['last_heartbeat_at'].toString()) : null,
    isActive: json['is_active'] as bool?,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'store_id': storeId, 'system_type_id': systemTypeId, 'name': name, 'station_number': stationNumber,
    'platform': platform?.name, 'status': status?.name, 'ip_address': ipAddress, 'mac_address': macAddress,
    'specs': specs, 'last_heartbeat_at': lastHeartbeatAt?.toIso8601String(), 'is_active': isActive,
    'created_at': createdAt?.toIso8601String(), 'updated_at': updatedAt?.toIso8601String(),
  };
}

class BookingModel {
  final String? id;
  final String? storeId;
  final String? userId;
  final String? systemId;
  final BookingType? bookingType;
  final BookingStatus? status;
  final DateTime? scheduledStart;
  final DateTime? scheduledEnd;
  final DateTime? actualStart;
  final DateTime? actualEnd;
  final double? amount;
  final bool? isPaid;
  final DateTime? expiresAt;
  final String? cancelledReason;
  final String? cancelledBy;
  final String? walkInPhone;
  final String? notes;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BookingModel({this.id, this.storeId, this.userId, this.systemId, this.bookingType, this.status, this.scheduledStart, this.scheduledEnd, this.actualStart, this.actualEnd, this.amount, this.isPaid, this.expiresAt, this.cancelledReason, this.cancelledBy, this.walkInPhone, this.notes, this.metadata, this.createdAt, this.updatedAt});

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
    id: json['id']?.toString(),
    storeId: json['store_id']?.toString(),
    userId: json['user_id']?.toString(),
    systemId: json['system_id']?.toString(),
    bookingType: json['booking_type']?.toString().toBookingType(),
    status: json['status']?.toString().toBookingStatus(),
    scheduledStart: json['scheduled_start'] != null ? DateTime.tryParse(json['scheduled_start'].toString()) : null,
    scheduledEnd: json['scheduled_end'] != null ? DateTime.tryParse(json['scheduled_end'].toString()) : null,
    actualStart: json['actual_start'] != null ? DateTime.tryParse(json['actual_start'].toString()) : null,
    actualEnd: json['actual_end'] != null ? DateTime.tryParse(json['actual_end'].toString()) : null,
    amount: double.tryParse(json['amount']?.toString() ?? ''),
    isPaid: json['is_paid'] as bool?,
    expiresAt: json['expires_at'] != null ? DateTime.tryParse(json['expires_at'].toString()) : null,
    cancelledReason: json['cancelled_reason']?.toString(),
    cancelledBy: json['cancelled_by']?.toString(),
    walkInPhone: json['walk_in_phone']?.toString(),
    notes: json['notes']?.toString(),
    metadata: json['metadata'] as Map<String, dynamic>?,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'store_id': storeId, 'user_id': userId, 'system_id': systemId, 'booking_type': bookingType?.name,
    'status': status?.name, 'scheduled_start': scheduledStart?.toIso8601String(), 'scheduled_end': scheduledEnd?.toIso8601String(),
    'actual_start': actualStart?.toIso8601String(), 'actual_end': actualEnd?.toIso8601String(), 'amount': amount,
    'is_paid': isPaid, 'expires_at': expiresAt?.toIso8601String(), 'cancelled_reason': cancelledReason,
    'cancelled_by': cancelledBy, 'walk_in_phone': walkInPhone, 'notes': notes, 'metadata': metadata,
    'created_at': createdAt?.toIso8601String(), 'updated_at': updatedAt?.toIso8601String(),
  };
}

class SessionModel {
  final String? id;
  final String? storeId;
  final String? bookingId;
  final String? userId;
  final String? systemId;
  final SessionStatus? status;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int? durationMinutes;
  final bool? isBilled;
  final String? walkInPhone;
  final String? notes;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SessionModel({this.id, this.storeId, this.bookingId, this.userId, this.systemId, this.status, this.startedAt, this.endedAt, this.durationMinutes, this.isBilled, this.walkInPhone, this.notes, this.metadata, this.createdAt, this.updatedAt});

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
    id: json['id']?.toString(),
    storeId: json['store_id']?.toString(),
    bookingId: json['booking_id']?.toString(),
    userId: json['user_id']?.toString(),
    systemId: json['system_id']?.toString(),
    status: json['status']?.toString().toSessionStatus(),
    startedAt: json['started_at'] != null ? DateTime.tryParse(json['started_at'].toString()) : null,
    endedAt: json['ended_at'] != null ? DateTime.tryParse(json['ended_at'].toString()) : null,
    durationMinutes: json['duration_minutes'] as int?,
    isBilled: json['is_billed'] as bool?,
    walkInPhone: json['walk_in_phone']?.toString(),
    notes: json['notes']?.toString(),
    metadata: json['metadata'] as Map<String, dynamic>?,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'store_id': storeId, 'booking_id': bookingId, 'user_id': userId, 'system_id': systemId,
    'status': status?.name, 'started_at': startedAt?.toIso8601String(), 'ended_at': endedAt?.toIso8601String(),
    'duration_minutes': durationMinutes, 'is_billed': isBilled, 'walk_in_phone': walkInPhone, 'notes': notes,
    'metadata': metadata, 'created_at': createdAt?.toIso8601String(), 'updated_at': updatedAt?.toIso8601String(),
  };
}

class SessionLogModel {
  final String? id;
  final String? storeId;
  final String? sessionId;
  final String? eventType;
  final DateTime? eventAt;
  final DateTime? localTime;
  final String? source;
  final SessionStatus? oldStatus;
  final SessionStatus? newStatus;
  final int? durationSeconds;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;

  const SessionLogModel({this.id, this.storeId, this.sessionId, this.eventType, this.eventAt, this.localTime, this.source, this.oldStatus, this.newStatus, this.durationSeconds, this.metadata, this.createdAt});

  factory SessionLogModel.fromJson(Map<String, dynamic> json) => SessionLogModel(
    id: json['id']?.toString(),
    storeId: json['store_id']?.toString(),
    sessionId: json['session_id']?.toString(),
    eventType: json['event_type']?.toString(),
    eventAt: json['event_at'] != null ? DateTime.tryParse(json['event_at'].toString()) : null,
    localTime: json['local_time'] != null ? DateTime.tryParse(json['local_time'].toString()) : null,
    source: json['source']?.toString(),
    oldStatus: json['old_status']?.toString().toSessionStatus(),
    newStatus: json['new_status']?.toString().toSessionStatus(),
    durationSeconds: json['duration_seconds'] as int?,
    metadata: json['metadata'] as Map<String, dynamic>?,
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'store_id': storeId, 'session_id': sessionId, 'event_type': eventType,
    'event_at': eventAt?.toIso8601String(), 'local_time': localTime?.toIso8601String(), 'source': source,
    'old_status': oldStatus?.name, 'new_status': newStatus?.name, 'duration_seconds': durationSeconds,
    'metadata': metadata, 'created_at': createdAt?.toIso8601String(),
  };
}
