import 'package:flutter_test/flutter_test.dart';
import 'package:gz_app/models/api_responses.dart';

void main() {
  test('parses nested notifications response from API', () {
    final response = NotificationListResponse.fromJson({
      'success': true,
      'message': 'Notifications fetched',
      'data': {
        'notifications': [
          {
            'id': 'notif-1',
            'title': 'Session started',
            'body': 'Your session is live',
            'status': 'sent',
            'channel': 'push',
          },
        ],
        'meta': {
          'total': 1,
          'page': 1,
          'limit': 30,
          'totalPages': 1,
          'unreadCount': 1,
        },
      },
    });

    expect(response.data, hasLength(1));
    expect(response.data!.single.id, 'notif-1');
    expect(response.unreadCount, 1);
  });
}
