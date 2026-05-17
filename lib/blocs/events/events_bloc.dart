import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/event_model.dart';
import '../../services/api_service.dart';
import '../../services/event_repository.dart';
import '../../utils/constants.dart';
import 'events_event.dart';
import 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc({EventRepository? repository})
      : _repository = repository ?? EventRepository(),
        super(const EventsState()) {
    on<EventsFetched>(_onFetched);
    on<EventsRefreshed>(_onRefreshed);
    on<EventSearchChanged>(_onSearchChanged);
    on<EventCategoryFilterChanged>(_onCategoryFilterChanged);
    on<EventAdded>(_onAdded);
    on<EventUpdated>(_onUpdated);
    on<EventDeleted>(_onDeleted);
    on<EventFavoriteToggled>(_onFavoriteToggled);
    on<EventsMessageCleared>(_onMessageCleared);
  }

  final EventRepository _repository;

  Future<void> _onFetched(
    EventsFetched event,
    Emitter<EventsState> emit,
  ) async {
    emit(state.copyWith(
      status: EventsStatus.loading,
      clearError: true,
      clearSuccess: true,
    ));
    await _loadEvents(emit);
  }

  Future<void> _onRefreshed(
    EventsRefreshed event,
    Emitter<EventsState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true, clearError: true));
    await _loadEvents(emit, isRefresh: true);
  }

  Future<void> _loadEvents(
    Emitter<EventsState> emit, {
    bool isRefresh = false,
  }) async {
    try {
      final events = await _repository.getEvents();
      if (events.isEmpty) {
        emit(state.copyWith(
          status: EventsStatus.empty,
          events: [],
          filteredEvents: [],
          isRefreshing: false,
        ));
        return;
      }
      final filtered = _applyFilters(
        events,
        state.searchQuery,
        state.selectedCategory,
      );
      emit(state.copyWith(
        status: EventsStatus.loaded,
        events: events,
        filteredEvents: filtered,
        isRefreshing: false,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: EventsStatus.error,
        errorMessage: e.message,
        isRefreshing: false,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: EventsStatus.error,
        errorMessage: 'Failed to load events. Please try again.',
        isRefreshing: false,
      ));
    }
  }

  void _onSearchChanged(
    EventSearchChanged event,
    Emitter<EventsState> emit,
  ) {
    final filtered = _applyFilters(
      state.events,
      event.query,
      state.selectedCategory,
    );
    emit(state.copyWith(
      searchQuery: event.query,
      filteredEvents: filtered,
      status: _resolveDisplayStatus(state.events, filtered, event.query),
    ));
  }

  void _onCategoryFilterChanged(
    EventCategoryFilterChanged event,
    Emitter<EventsState> emit,
  ) {
    final filtered = _applyFilters(
      state.events,
      state.searchQuery,
      event.category,
    );
    emit(state.copyWith(
      selectedCategory: event.category,
      clearCategory: event.category == null,
      filteredEvents: filtered,
      status: _resolveDisplayStatus(
        state.events,
        filtered,
        state.searchQuery,
      ),
    ));
  }
  Future<void> _onAdded(
    EventAdded event,
    Emitter<EventsState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final created = await _repository.addEvent(event.event);
      final updated = [created, ...state.events];
      final filtered = _applyFilters(
        updated,
        state.searchQuery,
        state.selectedCategory,
      );
      emit(state.copyWith(
        status: EventsStatus.loaded,
        events: updated,
        filteredEvents: filtered,
        isSubmitting: false,
        successMessage: 'Event "${created.title}" created successfully!',
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Could not create event.',
      ));
    }
  }

  Future<void> _onUpdated(
    EventUpdated event,
    Emitter<EventsState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final updatedEvent = await _repository.updateEvent(event.event);
      final updated = state.events
          .map((e) => e.id == updatedEvent.id ? updatedEvent : e)
          .toList();
      final filtered = _applyFilters(
        updated,
        state.searchQuery,
        state.selectedCategory,
      );
      emit(state.copyWith(
        status: EventsStatus.loaded,
        events: updated,
        filteredEvents: filtered,
        isSubmitting: false,
        successMessage: 'Event updated successfully!',
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Could not update event.',
      ));
    }
  }

  Future<void> _onDeleted(
    EventDeleted event,
    Emitter<EventsState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _repository.deleteEvent(event.id);
      final updated =
          state.events.where((e) => e.id != event.id).toList();
      if (updated.isEmpty) {
        emit(state.copyWith(
          status: EventsStatus.empty,
          events: [],
          filteredEvents: [],
          isSubmitting: false,
          successMessage: 'Event deleted.',
        ));
        return;
      }
      final filtered = _applyFilters(
        updated,
        state.searchQuery,
        state.selectedCategory,
      );
      emit(state.copyWith(
        status: EventsStatus.loaded,
        events: updated,
        filteredEvents: filtered,
        isSubmitting: false,
        successMessage: 'Event deleted successfully.',
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: e.message,
      ));
    } catch (_) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Could not delete event.',
      ));
    }
  }

  void _onFavoriteToggled(
    EventFavoriteToggled event,
    Emitter<EventsState> emit,
  ) {
    _repository.toggleFavorite(event.id);
    final updated = state.events
        .map(
          (e) => e.id == event.id
              ? e.copyWith(
                  isFavorite: _repository.isFavorite(event.id),
                )
              : e,
        )
        .toList();
    final filtered = _applyFilters(
      updated,
      state.searchQuery,
      state.selectedCategory,
    );
    emit(state.copyWith(events: updated, filteredEvents: filtered));
  }

  void _onMessageCleared(
    EventsMessageCleared event,
    Emitter<EventsState> emit,
  ) {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }
  List<EventModel> _applyFilters(
    List<EventModel> events,
    String query,
    EventCategory? category,
  ) {
    var result = events;
    if (category != null) {
      result = result.where((e) => e.category == category).toList();
    }
    if (query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      result = result
          .where(
            (e) =>
                e.title.toLowerCase().contains(q) ||
                e.location.toLowerCase().contains(q) ||
                e.organizerId.toString().contains(q) ||
                e.category.label.toLowerCase().contains(q),
          )
          .toList();
    }
    return result;
  }

  EventsStatus _resolveDisplayStatus(
    List<EventModel> all,
    List<EventModel> filtered,
    String query,
  ) {
    if (all.isEmpty) return EventsStatus.empty;
    if (filtered.isEmpty && (query.isNotEmpty || state.selectedCategory != null)) {
      return EventsStatus.loaded;
    }
    return EventsStatus.loaded;
  }
}