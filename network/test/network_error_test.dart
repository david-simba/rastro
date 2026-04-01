import 'package:flutter_test/flutter_test.dart';
import 'package:network/network.dart';

void main() {
  group('NetworkError', () {
    test('subtypes are distinct sealed variants', () {
      const errors = <NetworkError>[
        UnauthorizedError(),
        NotFoundError(),
        ServerError(503),
        NoConnectionError(),
        TimeoutError(),
        UnknownError('oops'),
      ];

      expect(errors[0], isA<UnauthorizedError>());
      expect(errors[1], isA<NotFoundError>());
      expect(errors[2], isA<ServerError>());
      expect(errors[3], isA<NoConnectionError>());
      expect(errors[4], isA<TimeoutError>());
      expect(errors[5], isA<UnknownError>());
    });

    test('ServerError stores the status code', () {
      const error = ServerError(502);
      expect(error.statusCode, 502);
    });

    test('UnknownError stores the cause', () {
      final cause = Exception('raw');
      final error = UnknownError(cause);
      expect(error.cause, cause);
    });

    test('switch exhaustively covers all cases', () {
      const NetworkError error = TimeoutError();
      final label = switch (error) {
        UnauthorizedError() => 'unauthorized',
        NotFoundError() => 'not_found',
        ServerError() => 'server',
        NoConnectionError() => 'no_connection',
        TimeoutError() => 'timeout',
        UnknownError() => 'unknown',
      };
      expect(label, 'timeout');
    });
  });

  group('Result', () {
    test('Success.isSuccess is true', () {
      const result = Success<int, NetworkError>(42);
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
    });

    test('Failure.isFailure is true', () {
      const result = Failure<int, NetworkError>(TimeoutError());
      expect(result.isFailure, isTrue);
      expect(result.isSuccess, isFalse);
    });

    test('when() routes to correct branch', () {
      const Result<int, NetworkError> ok = Success(1);
      const Result<int, NetworkError> err = Failure(NoConnectionError());

      expect(
        ok.when(success: (v) => 'ok:$v', failure: (_) => 'fail'),
        'ok:1',
      );
      expect(
        err.when(success: (_) => 'ok', failure: (e) => 'fail:${e.runtimeType}'),
        'fail:NoConnectionError',
      );
    });

    test('map() transforms Success, passes through Failure', () {
      const Result<int, NetworkError> ok = Success(2);
      const Result<int, NetworkError> err = Failure(NotFoundError());

      expect(ok.map((v) => v * 10).getOrNull(), 20);
      expect(err.map((v) => v * 10).getOrNull(), isNull);
    });

    test('flatMap() chains Results', () {
      const Result<int, NetworkError> ok = Success(5);
      final chained = ok.flatMap(
        (v) => v > 0 ? Success(v * 2) : const Failure(UnknownError('neg')),
      );
      expect(chained.getOrNull(), 10);
    });

    test('getOrNull() returns null for Failure', () {
      const Result<String, NetworkError> err = Failure(UnauthorizedError());
      expect(err.getOrNull(), isNull);
    });
  });
}
