import 'package:equatable/equatable.dart';

import '../../models/event_model.dart';
import '../../utils/constants.dart';

enum EventsStatus { initial, loading, loaded, empty, error }

class EventsState extends Equatable {
  const EventsState({
    this.status = EventsStatus.initial,
    this.events = const [],
    this.filteredEvents = const [],
    this.searchQuery = '',
    this.selectedCategory,
    this.errorMessage,
    this.successMessage,
    this.isRefreshing = false,
    this.isSubmitting = false,
  });

  final EventsStatus status;
  final List<EventModel> events;
  final List<EventModel> filteredEvents;
  final String searchQuery;
  final EventCategory? selectedCategory;
  final String? errorMessage;
  final String? successMessage;
  final bool isRefreshing;
  final bool isSubmitting;

  bool get hasFilter =>
      searchQuery.isNotEmpty || selectedCategory != null;

  List<EventModel> get displayEvents =>
      hasFilter ? filteredEvents : events;

  EventsState copyWith({
    EventsStatus? status,
    List<EventModel>? events,
    List<EventModel>? filteredEvents,
    String? searchQuery,
    EventCategory? selectedCategory,
    bool clearCategory = false,
    String? errorMessage,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
    bool? isRefreshing,
    bool? isSubmitting,
  }) {
    return EventsState(
      status: status ?? this.status,
      events: events ?? this.events,
      filteredEvents: filteredEvents ?? this.filteredEvents,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
        status,
        events,
        filteredEvents,
        searchQuery,
        selectedCategory,
        errorMessage,
        successMessage,
        isRefreshing,
        isSubmitting,
      ];
}