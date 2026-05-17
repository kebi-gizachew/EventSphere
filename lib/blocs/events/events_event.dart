import 'package:equatable/equatable.dart';

import '../../models/event_model.dart';
import '../../utils/constants.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object?> get props => [];
}

class EventsFetched extends EventsEvent {
  const EventsFetched();
}

class EventsRefreshed extends EventsEvent {
  const EventsRefreshed();
}

class EventSearchChanged extends EventsEvent {
  const EventSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class EventCategoryFilterChanged extends EventsEvent {
  const EventCategoryFilterChanged(this.category);

  final EventCategory? category;

  @override
  List<Object?> get props => [category];
}

class EventAdded extends EventsEvent {
  const EventAdded(this.event);

  final EventModel event;

  @override
  List<Object?> get props => [event];
}

class EventUpdated extends EventsEvent {
  const EventUpdated(this.event);

  final EventModel event;

  @override
  List<Object?> get props => [event];
}

class EventDeleted extends EventsEvent {
  const EventDeleted(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class EventFavoriteToggled extends EventsEvent {
  const EventFavoriteToggled(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class EventsMessageCleared extends EventsEvent {
  const EventsMessageCleared();
}