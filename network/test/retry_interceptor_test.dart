import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network/network.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
import 'retry_interceptor_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late RetryInterceptor interceptor;

  setUp(() {
    mockDio = MockDio();
    interceptor = RetryInterceptor(
      dio: mockDio,
      maxAttempts: 3,
      initialDelay: Duration.zero, // no delay in tests
    );
  });

  DioException _timeoutError(RequestOptions options) => DioException(
        requestOptions: options,
        type: DioExceptionType.connectionTimeout,
      );

  DioException _serverError(RequestOptions options, int statusCode) =>
      DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: statusCode,
        ),
      );

  DioException _clientError(RequestOptions options) => DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: 400,
        ),
      );

  test('retries on connection timeout and resolves on success', () async {
    final options = RequestOptions(path: '/test');
    final error = _timeoutError(options);

    final successResponse = Response<dynamic>(
      requestOptions: options,
      statusCode: 200,
      data: <String, dynamic>{},
    );

    when(mockDio.fetch<dynamic>(any)).thenAnswer((_) async => successResponse);

    final _ = RequestInterceptorHandler();
    // We test onError directly via a simple harness
    var handlerCalled = false;
    final errorHandler = _TestErrorHandler(
      onResolve: (r) {
        handlerCalled = true;
      },
      onReject: (_) => fail('Should have resolved'),
    );

    await interceptor.onError(error, errorHandler);
    expect(handlerCalled, isTrue);
    verify(mockDio.fetch<dynamic>(any)).called(1);
  });

  test('does not retry on 4xx client errors', () async {
    final options = RequestOptions(path: '/test');
    final error = _clientError(options);

    var rejected = false;
    final errorHandler = _TestErrorHandler(
      onResolve: (_) => fail('Should not resolve'),
      onReject: (_) => rejected = true,
    );

    await interceptor.onError(error, errorHandler);
    expect(rejected, isTrue);
    verifyNever(mockDio.fetch<dynamic>(any));
  });

  test('stops after maxAttempts and rejects', () async {
    final options = RequestOptions(path: '/test');
    // Simulate already at max attempts
    options.extra['_retry_attempt'] = 3;
    final error = _serverError(options, 503);

    var rejected = false;
    final errorHandler = _TestErrorHandler(
      onResolve: (_) => fail('Should not resolve'),
      onReject: (_) => rejected = true,
    );

    await interceptor.onError(error, errorHandler);
    expect(rejected, isTrue);
    verifyNever(mockDio.fetch<dynamic>(any));
  });
}

/// Minimal [ErrorInterceptorHandler] stand-in for unit tests.
class _TestErrorHandler extends ErrorInterceptorHandler {
  _TestErrorHandler({
    required this.onResolve,
    required this.onReject,
  });

  final void Function(Response<dynamic>) onResolve;
  final void Function(DioException) onReject;

  @override
  void resolve(Response<dynamic> response) => onResolve(response);

  @override
  void reject(DioException err, [bool callFollowingErrorInterceptor = false]) =>
      onReject(err);

  @override
  void next(DioException err) => onReject(err);
}
