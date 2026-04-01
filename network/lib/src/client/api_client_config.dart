import 'package:dio/dio.dart';

/// Configuration bag for [ApiClient].
///
/// Pass an instance to [ApiClient]'s constructor. Interceptors are
/// registered in the order provided — put logging first so you see
/// the raw request before auth or retry mutate it.
class ApiClientConfig {
  const ApiClientConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 30),
    this.interceptors = const [],
  });

  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  /// Interceptors applied in order. Recommended order:
  ///   1. [LoggingInterceptor]  — observe the raw request
  ///   2. [AuthInterceptor]     — inject token
  ///   3. [RetryInterceptor]    — retry on transient failures
  final List<Interceptor> interceptors;
}
