class SystemTypeOption {
  const SystemTypeOption({required this.id, required this.label});

  final String? id;
  final String label;
}

List<int>? pricingDayFilter(String selection) {
  switch (selection) {
    case 'Weekdays':
      return const [1, 2, 3, 4, 5];
    case 'Weekends':
      return const [6, 7];
    default:
      return null;
  }
}

(String?, String?) pricingTimeWindowRange(String selection) {
  switch (selection) {
    case 'Morning 8AM-12PM':
      return ('08:00', '12:00');
    case 'Afternoon 12-6PM':
      return ('12:00', '18:00');
    case 'Evening 6-10PM':
      return ('18:00', '22:00');
    default:
      return (null, null);
  }
}

String pricingDaysSelection(List<int>? days) {
  if (days == null || days.isEmpty) {
    return 'All days';
  }
  final normalized = days.toSet();
  if (normalized.containsAll({1, 2, 3, 4, 5}) && normalized.length == 5) {
    return 'Weekdays';
  }
  if (normalized.containsAll({6, 7}) && normalized.length == 2) {
    return 'Weekends';
  }
  return 'All days';
}

String pricingWindowSelection(String? start, String? end) {
  switch ('$start|$end') {
    case '08:00|12:00':
      return 'Morning 8AM-12PM';
    case '12:00|18:00':
      return 'Afternoon 12-6PM';
    case '18:00|22:00':
      return 'Evening 6-10PM';
    default:
      return 'All hours';
  }
}
