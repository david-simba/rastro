import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logs every request and response to the debug console.
///
/// No-op in release builds — [kDebugMode] gates every print call.
class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('→ ${options.method} ${options.uri}');
      if (options.data != null) debugPrint('  body: ${options.data}');
      if (options.queryParameters.isNotEmpty) {
        debugPrint('  query: ${options.queryParameters}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '← ${response.statusCode} ${response.requestOptions.uri}',
      );
      debugPrint('  data: ${response.data}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint(
        '✗ ${err.type.name} ${err.requestOptions.uri} — ${err.message}',
      );
    }
    super.onError(err, handler);
  }
}
