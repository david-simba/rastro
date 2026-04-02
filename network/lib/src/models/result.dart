/// A discriminated union representing either a successful value [S]
/// or a failure value [F].
///
/// Use [when] to exhaustively handle both cases without try/catch at call sites.
sealed class Result<S, F> {
  const Result();

  /// Returns `true` if this is a [Success].
  bool get isSuccess => this is Success<S, F>;

  /// Returns `true` if this is a [Failure].
  bool get isFailure => this is Failure<S, F>;

  /// Exhaustively handles both outcomes.
  T when<T>({
    required T Function(S value) success,
    required T Function(F error) failure,
  }) =>
      switch (this) {
        Success(:final value) => success(value),
        Failure(:final error) => failure(error),
      };

  /// Maps the success value, leaving failure untouched.
  Result<T, F> map<T>(T Function(S value) transform) => switch (this) {
        Success(:final value) => Success(transform(value)),
        Failure(:final error) => Failure(error),
      };

  /// Flat-maps the success value, leaving failure untouched.
  Result<T, F> flatMap<T>(Result<T, F> Function(S value) transform) =>
      switch (this) {
        Success(:final value) => transform(value),
        Failure(:final error) => Failure(error),
      };

  /// Returns the success value or `null`.
  S? getOrNull() => switch (this) {
        Success(:final value) => value,
        Failure() => null,
      };
}

/// Represents a successful outcome carrying [value].
final class Success<S, F> extends Result<S, F> {
  const Success(this.value);
  final S value;

  @override
  String toString() => 'Success($value)';
}

/// Represents a failed outcome carrying [error].
final class Failure<S, F> extends Result<S, F> {
  const Failure(this.error);
  final F error;

  @override
  String toString() => 'Failure($error)';
}
