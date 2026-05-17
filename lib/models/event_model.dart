import 'package:equatable/equatable.dart';

import '../utils/constants.dart';
import '../utils/event_metadata_generator.dart';

class EventModel extends Equatable {
  const EventModel({
    required this.id,
    required this.title,
    required this.organizerId,
    required this.completed,
    required this.category,
    required this.eventDate,
    required this.location,
    this.isFavorite = false,
  });

  final int id;
  final String title;
  final int organizerId;
  final bool completed;
  final EventCategory category;
  final DateTime eventDate;
  final String location;
  final bool isFavorite;

  bool get isUpcoming => !completed;

  String get statusLabel => completed ? 'Completed' : 'Upcoming';

  String get formattedDate =>
      EventMetadataGenerator.formattedDate(eventDate);

  String get countdownLabel => EventMetadataGenerator.countdownLabel(
        eventDate,
        completed: completed,
      );

  String get bannerHint =>
      EventMetadataGenerator.bannerAssetHint(category);

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    return EventModel(
      id: id,
      title: json['title'] as String,
      organizerId: json['userId'] as int,
      completed: json['completed'] as bool,
      category: EventCategory.fromIndex(id),
      eventDate: EventMetadataGenerator.dateForId(id),
      location: EventMetadataGenerator.locationForId(id),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'userId': organizerId,
        'completed': completed,
      };

  Map<String, dynamic> toCreateJson() => {
        'title': title,
        'userId': organizerId,
        'completed': completed,
      };

  EventModel copyWith({
    int? id,
    String? title,
    int? organizerId,
    bool? completed,
    EventCategory? category,
    DateTime? eventDate,
    String? location,
    bool? isFavorite,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      organizerId: organizerId ?? this.organizerId,
      completed: completed ?? this.completed,
      category: category ?? this.category,
      eventDate: eventDate ?? this.eventDate,
      location: location ?? this.location,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        organizerId,
        completed,
        category,
        eventDate,
        location,
        isFavorite,
      ];
}