/// Thin wrapper around a decoded HTTP response.
///
/// Gives callers access to the raw [statusCode] alongside the
/// deserialized [data] when they need to inspect HTTP semantics
/// beyond success/failure.
class NetworkResponse<T> {
  const NetworkResponse({
    required this.statusCode,
    required this.data,
  });

  final int statusCode;
  final T data;

  @override
  String toString() => 'NetworkResponse(statusCode: $statusCode, data: $data)';
}
