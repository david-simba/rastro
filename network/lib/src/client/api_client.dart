import 'package:dio/dio.dart';

import '../errors/network_error.dart';
import '../errors/network_exception_mapper.dart';
import '../models/result.dart';
import 'api_client_config.dart';

/// HTTP client for the Rastro backend.
///
/// All methods return `Result<T, NetworkError>` — callers never deal with
/// exceptions. The generic [fromJson] parameter keeps this class free of
/// any knowledge about specific response models.
///
/// ```dart
/// final client = ApiClient(ApiClientConfig(baseUrl: Env.apiUrl));
/// final result = await client.get('/users/me', fromJson: UserDto.fromJson);
/// ```
class ApiClient {
  ApiClient(ApiClientConfig config) {
    _dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        headers: const {'Content-Type': 'application/json'},
      ),
    )..interceptors.addAll(config.interceptors);
  }

  late final Dio _dio;

  /// Performs a GET request and deserializes the response with [fromJson].
  Future<Result<T, NetworkError>> get<T>(
    String path, {
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParams,
  }) =>
      _safeRequest(
        () => _dio.get<dynamic>(path, queryParameters: queryParams),
        fromJson,
      );

  /// Performs a POST request and deserializes the response with [fromJson].
  Future<Result<T, NetworkError>> post<T>(
    String path, {
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? data,
  }) =>
      _safeRequest(
        () => _dio.post<dynamic>(path, data: data),
        fromJson,
      );

  /// Performs a PUT request and deserializes the response with [fromJson].
  Future<Result<T, NetworkError>> put<T>(
    String path, {
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? data,
  }) =>
      _safeRequest(
        () => _dio.put<dynamic>(path, data: data),
        fromJson,
      );

  /// Performs a DELETE request. Returns [Success] with `null` on HTTP 2xx.
  Future<Result<void, NetworkError>> delete(String path) async {
    try {
      await _dio.delete<dynamic>(path);
      return const Success(null);
    } on DioException catch (e) {
      return Failure(NetworkExceptionMapper.map(e));
    }
  }

  // ── internal ───────────────────────────────────────────────────────────────

  Future<Result<T, NetworkError>> _safeRequest<T>(
    Future<Response<dynamic>> Function() request,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await request();
      return Success(fromJson(response.data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Failure(NetworkExceptionMapper.map(e));
    }
  }
}
