import 'package:flutter_test/flutter_test.dart';
import 'package:gz_app/models/api_responses.dart';

void main() {
  group('PaginatedBillingResponse', () {
    test('parses billing rows from data payload', () {
      final response = PaginatedBillingResponse.fromJson({
        'message': 'ok',
        'data': [
          {
            'id': 'bill-1',
            'store_id': 'store-1',
            'session_id': 'sess-1',
            'store_name': 'Koramangala',
            'system_name': 'PC Station 03',
            'date': '2026-06-10T12:30:00.000Z',
            'duration_minutes': 127,
            'amount': 1740,
            'method': 'cash',
            'status': 'paid',
          },
        ],
        'pagination': {
          'currentPage': 1,
          'totalPages': 1,
          'totalItems': 1,
          'itemsPerPage': 20,
        },
      });

      expect(response.data, hasLength(1));
      expect(response.data!.first.id, 'bill-1');
      expect(response.data!.first.amount, 1740);
      expect(response.data!.first.status, 'paid');
      expect(response.pagination?.totalItems, 1);
    });
  });

  group('PaginatedSessionLogsResponse', () {
    test('parses session log rows from data payload', () {
      final response = PaginatedSessionLogsResponse.fromJson({
        'message': 'ok',
        'data': [
          {
            'id': 'log-1',
            'store_id': 'store-1',
            'session_id': 'sess-1',
            'event_type': 'session.started',
            'event_at': '2026-06-10T12:30:00.000Z',
            'local_time': '2026-06-10T18:00:00.000Z',
            'source': 'system',
            'old_status': 'scheduled',
            'new_status': 'in_progress',
            'duration_seconds': 0,
            'metadata': {'message': 'Session started'},
            'created_at': '2026-06-10T12:30:00.000Z',
          },
        ],
      });

      expect(response.data, hasLength(1));
      expect(response.data!.first.id, 'log-1');
      expect(response.data!.first.eventType, 'session.started');
      expect(response.data!.first.newStatus?.name, 'inProgress');
      expect(
        response.data!.first.metadata?['message'],
        'Session started',
      );
    });
  });
}
