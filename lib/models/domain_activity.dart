// ============================================================
// AdminActivityItem — Unified session/booking feed entry
// GET /stores/:storeId/sessions/feed
// ============================================================

enum ActivityKind { session, booking }

enum ActivityBucket { current, incoming, past }

ActivityKind? _toActivityKind(String? value) => switch (value) {
  'session' => ActivityKind.session,
  'booking' => ActivityKind.booking,
  _ => null,
};

ActivityBucket? _toActivityBucket(String? value) => switch (value) {
  'current' => ActivityBucket.current,
  'incoming' => ActivityBucket.incoming,
  'past' => ActivityBucket.past,
  _ => null,
};

class AdminActivityItem {
  final ActivityKind? kind;
  final String? id;
  final ActivityBucket? bucket;
  final String? rawStatus;
  final String? systemId;
  final String? systemName;
  final int? stationNumber;
  final String? platform;
  final String? userId;
  final String? userName;
  final String? userPhone;
  final String? walkInPhone;
  final DateTime? startAt;
  final DateTime? endAt;
  final int? durationMinutes;
  final DateTime? bookedAt;
  final double? amount;
  final bool? isPaid;
  final double? billedAmount;
  final bool? isBilled;
  final String? bookingId;

  const AdminActivityItem({
    this.kind,
    this.id,
    this.bucket,
    this.rawStatus,
    this.systemId,
    this.systemName,
    this.stationNumber,
    this.platform,
    this.userId,
    this.userName,
    this.userPhone,
    this.walkInPhone,
    this.startAt,
    this.endAt,
    this.durationMinutes,
    this.bookedAt,
    this.amount,
    this.isPaid,
    this.billedAmount,
    this.isBilled,
    this.bookingId,
  });

  factory AdminActivityItem.fromJson(Map<String, dynamic> json) =>
      AdminActivityItem(
        kind: _toActivityKind(json['kind']?.toString()),
        id: json['id']?.toString(),
        bucket: _toActivityBucket(json['bucket']?.toString()),
        rawStatus:
            json['raw_status']?.toString() ?? json['rawStatus']?.toString(),
        systemId: (json['system_id'] ?? json['systemId'])?.toString(),
        systemName:
            json['system_name']?.toString() ?? json['systemName']?.toString(),
        stationNumber:
            (json['station_number'] ?? json['stationNumber']) as int?,
        platform: json['platform']?.toString(),
        userId: (json['user_id'] ?? json['userId'])?.toString(),
        userName:
            json['user_name']?.toString() ?? json['userName']?.toString(),
        userPhone:
            json['user_phone']?.toString() ?? json['userPhone']?.toString(),
        walkInPhone:
            json['walk_in_phone']?.toString() ??
            json['walkInPhone']?.toString(),
        startAt: (json['start_at'] ?? json['startAt']) != null
            ? DateTime.tryParse((json['start_at'] ?? json['startAt']).toString())
            : null,
        endAt: (json['end_at'] ?? json['endAt']) != null
            ? DateTime.tryParse((json['end_at'] ?? json['endAt']).toString())
            : null,
        durationMinutes:
            (json['duration_minutes'] ?? json['durationMinutes']) as int?,
        bookedAt: (json['booked_at'] ?? json['bookedAt']) != null
            ? DateTime.tryParse(
                (json['booked_at'] ?? json['bookedAt']).toString(),
              )
            : null,
        amount: json['amount'] != null
            ? double.tryParse(json['amount'].toString())
            : null,
        isPaid: (json['is_paid'] ?? json['isPaid']) as bool?,
        billedAmount:
            (json['billed_amount'] ?? json['billedAmount']) != null
            ? double.tryParse(
                (json['billed_amount'] ?? json['billedAmount']).toString(),
              )
            : null,
        isBilled: (json['is_billed'] ?? json['isBilled']) as bool?,
        bookingId: (json['booking_id'] ?? json['bookingId'])?.toString(),
      );

  Map<String, dynamic> toJson() => {
    'kind': kind?.name,
    'id': id,
    'bucket': bucket?.name,
    'raw_status': rawStatus,
    'system_id': systemId,
    'system_name': systemName,
    'station_number': stationNumber,
    'platform': platform,
    'user_id': userId,
    'user_name': userName,
    'user_phone': userPhone,
    'walk_in_phone': walkInPhone,
    'start_at': startAt?.toIso8601String(),
    'end_at': endAt?.toIso8601String(),
    'duration_minutes': durationMinutes,
    'booked_at': bookedAt?.toIso8601String(),
    'amount': amount,
    'is_paid': isPaid,
    'billed_amount': billedAmount,
    'is_billed': isBilled,
    'booking_id': bookingId,
  };
}
