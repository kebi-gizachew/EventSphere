class ApiConstants {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String todosEndpoint = '/todos';
}

class AppStrings {
  static const String appName = 'EventSphere';
  static const String appTagline = 'Smart Event Organizer';
  static const String searchHint = 'Search events, venues, organizers…';
  static const String noEventsTitle = 'No events on the horizon';
  static const String noEventsSubtitle =
      'Pull down to refresh or tap + to schedule your first event.';
  static const String noResultsTitle = 'Nothing matched your search';
  static const String noResultsSubtitle =
      'Try a different keyword or clear the filter.';
  static const String deleteTitle = 'Remove this event?';
  static const String deleteMessage =
      'This action cannot be undone. The event will be removed from your list.';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String save = 'Save Event';
  static const String update = 'Update Event';
  static const String addEvent = 'New Event';
  static const String editEvent = 'Edit Event';
}

enum EventCategory {
  technology,
  music,
  sports,
  education,
  business,
  art;

  String get label {
    switch (this) {
      case EventCategory.technology:
        return 'Technology';
      case EventCategory.music:
        return 'Music';
      case EventCategory.sports:
        return 'Sports';
      case EventCategory.education:
        return 'Education';
      case EventCategory.business:
        return 'Business';
      case EventCategory.art:
        return 'Art';
    }
  }

  static EventCategory fromIndex(int index) {
    return EventCategory.values[index % EventCategory.values.length];
  }
}