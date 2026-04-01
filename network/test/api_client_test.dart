import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:network/network.dart';

@GenerateNiceMocks([MockSpec<Dio>()])

void main() {
  late ApiClient _;

  setUp(() {
    // ApiClient uses its own Dio instance internally, but we can test the
    // public surface by wrapping a pre-built Dio mock via a test-only path.
    // For integration-style unit tests, we exercise NetworkExceptionMapper
    // directly and verify Result types.
  });

  group('NetworkExceptionMapper', () {
    test('maps connectionTimeout → TimeoutError', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionTimeout,
      );
      expect(NetworkExceptionMapper.map(error), isA<TimeoutError>());
    });

    test('maps receiveTimeout → TimeoutError', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.receiveTimeout,
      );
      expect(NetworkExceptionMapper.map(error), isA<TimeoutError>());
    });

    test('maps connectionError → NoConnectionError', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionError,
      );
      expect(NetworkExceptionMapper.map(error), isA<NoConnectionError>());
    });

    test('maps 401 → UnauthorizedError', () {
      final options = RequestOptions(path: '/');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: options, statusCode: 401),
      );
      expect(NetworkExceptionMapper.map(error), isA<UnauthorizedError>());
    });

    test('maps 404 → NotFoundError', () {
      final options = RequestOptions(path: '/');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: options, statusCode: 404),
      );
      expect(NetworkExceptionMapper.map(error), isA<NotFoundError>());
    });

    test('maps 500 → ServerError', () {
      final options = RequestOptions(path: '/');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: options, statusCode: 500),
      );
      final result = NetworkExceptionMapper.map(error);
      expect(result, isA<ServerError>());
      expect((result as ServerError).statusCode, 500);
    });

    test('maps 503 → ServerError', () {
      final options = RequestOptions(path: '/');
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: options, statusCode: 503),
      );
      expect(NetworkExceptionMapper.map(error), isA<ServerError>());
    });

    test('maps unknown DioException → UnknownError', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.unknown,
      );
      expect(NetworkExceptionMapper.map(error), isA<UnknownError>());
    });
  });
}
