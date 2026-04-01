/// Public API of the `network` package.
///
/// Import only this file in other packages:
/// ```dart
/// import 'package:network/network.dart';
/// ```
library network;

export 'src/models/result.dart';
export 'src/models/network_response.dart';
export 'src/errors/network_error.dart';
export 'src/errors/network_exception_mapper.dart';
export 'src/client/api_client.dart';
export 'src/client/api_client_config.dart';
export 'src/client/interceptors/auth_interceptor.dart';
export 'src/client/interceptors/logging_interceptor.dart';
export 'src/client/interceptors/retry_interceptor.dart';
