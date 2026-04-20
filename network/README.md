# network

HTTP client package for the Rastro backend. Wraps Dio and exposes a clean, exception-free API using a `Result` type.

## What it does

- Provides `ApiClient` with `get`, `post`, `put`, and `delete` methods.
- Every method returns `Result<T, NetworkError>` — no try/catch needed at call sites.
- Includes three built-in interceptors: auth token injection, request logging, and automatic retry with exponential back-off.
- Maps all HTTP and transport errors to a typed `NetworkError` hierarchy.

## How to use it

```dart
// 1. Build the client (usually in a Riverpod provider)
final client = ApiClient(
  ApiClientConfig(
    baseUrl: 'https://api.rastro.app',
    interceptors: [
      LoggingInterceptor(),
      AuthInterceptor(myTokenProvider),
      RetryInterceptor(dio: dio),
    ],
  ),
);

// 2. Make a request
final result = await client.get('/routes', fromJson: RouteDto.fromJson);

// 3. Handle the result
result.when(
  success: (route) => print(route),
  failure: (error) => switch (error) {
    UnauthorizedError() => redirectToLogin(),
    NoConnectionError() => showOfflineBanner(),
    _ => showGenericError(),
  },
);
```

## Error types

| Type | When |
|---|---|
| `UnauthorizedError` | HTTP 401 |
| `NotFoundError` | HTTP 404 |
| `ServerError` | HTTP 5xx |
| `NoConnectionError` | No internet |
| `TimeoutError` | Request or connection timed out |
| `UnknownError` | Any other failure |

## Importing

```dart
import 'package:network/network.dart';
```
