import 'package:dio/dio.dart';

import '../models/event_model.dart';
import '../utils/constants.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.baseUrl,
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            );

  final Dio _dio;

  Future<List<EventModel>> fetchEvents() async {
    try {
      final response = await _dio.get(ApiConstants.todosEndpoint);
      final data = response.data as List<dynamic>;
      return data
          .map((e) => EventModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<EventModel> fetchEvent(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.todosEndpoint}/$id');
      return EventModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<EventModel> createEvent(EventModel event) async {
    try {
      final response = await _dio.post(
        ApiConstants.todosEndpoint,
        data: event.toCreateJson(),
      );
      final created = EventModel.fromJson(response.data as Map<String, dynamic>);
      return event.copyWith(
        id: created.id,
        title: created.title,
        organizerId: created.organizerId,
        completed: created.completed,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<EventModel> updateEvent(EventModel event) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.todosEndpoint}/${event.id}',
        data: event.toJson(),
      );
      final updated = EventModel.fromJson(response.data as Map<String, dynamic>);
      return event.copyWith(
        title: updated.title,
        organizerId: updated.organizerId,
        completed: updated.completed,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<void> deleteEvent(int id) async {
    try {
      await _dio.delete('${ApiConstants.todosEndpoint}/$id');
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  ApiException _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return ApiException(
          'No internet connection. Check your network and retry.',
        );
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        final msg = e.response?.statusMessage ?? 'Server error occurred.';
        return ApiException('Error $code: $msg', statusCode: code);
      case DioExceptionType.cancel:
        return ApiException('Request was cancelled.');
      default:
        return ApiException(
          e.message ?? 'An unexpected network error occurred.',
        );
    }
  }
}