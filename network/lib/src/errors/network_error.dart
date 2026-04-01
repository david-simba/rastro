/// Sealed hierarchy of all network-layer failures.
///
/// Every HTTP/transport error the app can encounter maps to one of
/// these subtypes. Callers exhaustively switch on them — no raw
/// [Exception] types leak out of the network package.
sealed class NetworkError {
  const NetworkError();
}

/// 401 — token missing, invalid, or expired.
final class UnauthorizedError extends NetworkError {
  const UnauthorizedError();

  @override
  String toString() => 'UnauthorizedError';
}

/// 404 — requested resource does not exist.
final class NotFoundError extends NetworkError {
  const NotFoundError();

  @override
  String toString() => 'NotFoundError';
}

/// 5xx — the server acknowledged the request but failed to fulfill it.
final class ServerError extends NetworkError {
  const ServerError(this.statusCode);
  final int statusCode;

  @override
  String toString() => 'ServerError($statusCode)';
}

/// No network connectivity at all.
final class NoConnectionError extends NetworkError {
  const NoConnectionError();

  @override
  String toString() => 'NoConnectionError';
}

/// The request or response timed out.
final class TimeoutError extends NetworkError {
  const TimeoutError();

  @override
  String toString() => 'TimeoutError';
}

/// Catch-all for any error that does not fit the cases above.
final class UnknownError extends NetworkError {
  const UnknownError(this.cause);
  final Object cause;

  @override
  String toString() => 'UnknownError($cause)';
}
