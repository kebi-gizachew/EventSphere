import '../models/event_model.dart';
import 'api_service.dart';

class EventRepository {
  EventRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;
  final Set<int> _favoriteIds = {};
  int _localIdCounter = 10000;

  Future<List<EventModel>> getEvents() async {
    final events = await _apiService.fetchEvents();
    return events
        .map((e) => e.copyWith(isFavorite: _favoriteIds.contains(e.id)))
        .toList();
  }

  Future<EventModel> addEvent(EventModel event) async {
    try {
      final created = await _apiService.createEvent(event);
      return created.copyWith(isFavorite: false);
    } on ApiException {
      final local = event.copyWith(id: _localIdCounter++);
      return local;
    }
  }

  Future<EventModel> updateEvent(EventModel event) async {
    try {
      return await _apiService.updateEvent(event);
    } on ApiException {
      return event;
    }
  }

  Future<void> deleteEvent(int id) async {
    try {
      await _apiService.deleteEvent(id);
    } on ApiException {
      // JSONPlaceholder simulates delete; remove locally regardless.
    }
    _favoriteIds.remove(id);
  }

  void toggleFavorite(int id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
  }

  bool isFavorite(int id) => _favoriteIds.contains(id);
}