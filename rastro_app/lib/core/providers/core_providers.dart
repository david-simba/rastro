import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network/network.dart';

import 'package:rastro/core/config/app_config.dart';
import 'package:rastro/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:rastro/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:rastro/features/auth/domain/repositories/i_auth_repository.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden at startup');
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  return ApiClient(
    ApiClientConfig(
      baseUrl: config.baseUrl,
      interceptors: [
        LoggingInterceptor(),
      ],
    ),
  );
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return AuthRepositoryImpl(AuthRemoteDatasource(client));
});
