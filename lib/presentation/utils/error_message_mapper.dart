import 'package:dio/dio.dart';

class ErrorMessageMapper {
  const ErrorMessageMapper._();

  static String map(Object error) {
    if (error is DioException) {
      return _mapDioException(error);
    }

    final message = error.toString().toLowerCase();
    if (message.contains('no internet') ||
        message.contains('offline') ||
        message.contains('connection')) {
      return 'You\'re offline. Check your connection and try again.';
    }
    if (message.contains('timeout') || message.contains('timed out')) {
      return 'The server took too long to respond. Please try again.';
    }
    if (message.contains('401') || message.contains('unauthorized')) {
      return 'Email or password is incorrect.';
    }
    if (message.contains('409') ||
        message.contains('conflict') ||
        message.contains('already booked')) {
      return 'That slot was just booked. Pick another available time.';
    }
    return 'Something went wrong. Please try again.';
  }

  static String _mapDioException(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown) {
      return 'You\'re offline. Check your connection and try again.';
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'The server took too long to respond. Please try again.';
    }
    if (error.response?.statusCode == 401) {
      return 'Email or password is incorrect.';
    }
    if (error.response?.statusCode == 409) {
      return 'That slot was just booked. Pick another available time.';
    }
    return 'Something went wrong. Please try again.';
  }
}
