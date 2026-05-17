import 'package:intl/intl.dart';

import 'constants.dart';

/// Generates deterministic fake metadata from event id for display richness.
class EventMetadataGenerator {
  static const _locations = [
    'Austin Convention Center',
    'Brooklyn Warehouse',
    'Seattle Tech Hub',
    'Chicago Lakeside Pavilion',
    'Miami Beach Arena',
    'Denver Mountain Lodge',
    'Portland Creative Studio',
    'San Francisco Pier 39',
    'Boston Innovation Lab',
    'Nashville Sound Stage',
  ];

  static EventCategory categoryForId(int id) =>
      EventCategory.fromIndex(id % EventCategory.values.length);

  static String locationForId(int id) => _locations[id % _locations.length];

  static DateTime dateForId(int id) {
    final base = DateTime.now();
    final daysOffset = (id % 45) + 1;
    return DateTime(base.year, base.month, base.day + daysOffset, 18, 30);
  }

  static String formattedDate(DateTime date) =>
      DateFormat('EEE, MMM d · h:mm a').format(date);

  static String countdownLabel(DateTime date, {required bool completed}) {
    if (completed) return 'Event completed';
    final now = DateTime.now();
    final diff = date.difference(DateTime(now.year, now.month, now.day));
    final days = diff.inDays;
    if (days < 0) return 'Started recently';
    if (days == 0) return 'Starts today';
    if (days == 1) return 'Starts in 1 day';
    return 'Starts in $days days';
  }

  static String bannerAssetHint(EventCategory category) {
    switch (category) {
      case EventCategory.technology:
        return 'tech';
      case EventCategory.music:
        return 'music';
      case EventCategory.sports:
        return 'sports';
      case EventCategory.education:
        return 'edu';
      case EventCategory.business:
        return 'biz';
      case EventCategory.art:
        return 'art';
    }
  }
}