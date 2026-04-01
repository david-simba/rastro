import 'package:dio/dio.dart';

/// Automatically retries requests that fail due to timeout or 5xx errors.
///
/// Uses exponential back-off between attempts. Requests that fail with
/// client errors (4xx) are never retried — they represent a permanent
/// problem with the request itself.
class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.maxAttempts = 3,
    this.initialDelay = const Duration(milliseconds: 500),
  });

  final Dio dio;
  final int maxAttempts;

  /// Delay before the first retry. Doubles on each subsequent attempt.
  final Duration initialDelay;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final attempt = _attemptCount(err.requestOptions);

    if (!_shouldRetry(err) || attempt >= maxAttempts) {
      return super.onError(err, handler);
    }

    final delay = initialDelay * (1 << attempt); // 500 ms, 1 s, 2 s …
    await Future<void>.delayed(delay);

    final options = err.requestOptions
      ..extra[_kAttemptKey] = attempt + 1;

    try {
      final response = await dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.reject(retryError);
    }
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  static const _kAttemptKey = '_retry_attempt';

  int _attemptCount(RequestOptions options) =>
      (options.extra[_kAttemptKey] as int?) ?? 0;

  bool _shouldRetry(DioException err) {
    final isTimeout = err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout;

    final isServerError = err.type == DioExceptionType.badResponse &&
        (err.response?.statusCode ?? 0) >= 500;

    return isTimeout || isServerError;
  }
}
