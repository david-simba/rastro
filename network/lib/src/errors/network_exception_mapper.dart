import 'package:dio/dio.dart';

import 'network_error.dart';

/// Maps a [DioException] to the appropriate [NetworkError] subtype.
///
/// This is the single place where Dio's error model is translated into
/// the app's domain errors. No other class should inspect [DioException].
abstract final class NetworkExceptionMapper {
  NetworkExceptionMapper._();

  static NetworkError map(DioException exception) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        const TimeoutError(),
      DioExceptionType.connectionError => const NoConnectionError(),
      DioExceptionType.badResponse => _mapStatusCode(
          exception.response?.statusCode,
        ),
      _ => UnknownError(exception),
    };
  }

  static NetworkError _mapStatusCode(int? statusCode) {
    if (statusCode == null) return const UnknownError('No status code');
    return switch (statusCode) {
      401 => const UnauthorizedError(),
      404 => const NotFoundError(),
      >= 500 && < 600 => ServerError(statusCode),
      _ => UnknownError('Unexpected status code: $statusCode'),
    };
  }
}
