import 'package:dio/dio.dart';

/// Contract for providing a Bearer token to [AuthInterceptor].
///
/// Implement this with your auth source (Firebase, secure storage, etc.)
/// and inject it when constructing [AuthInterceptor]. The interceptor
/// itself has no dependency on Firebase or any specific auth library.
abstract interface class TokenProvider {
  /// Returns the current access token, or `null` if the user is not
  /// authenticated. The implementation is responsible for refreshing
  /// the token before returning it if necessary.
  Future<String?> getToken();
}

/// Injects a `Bearer` token into every outgoing request.
///
/// If [TokenProvider.getToken] returns `null`, the request is forwarded
/// without an `Authorization` header — unauthenticated endpoints still work.
class AuthInterceptor extends Interceptor {
  const AuthInterceptor(this._tokenProvider);

  final TokenProvider _tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenProvider.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
