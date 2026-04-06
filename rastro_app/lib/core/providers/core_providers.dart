import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rastro/core/config/app_config.dart';

import 'package:rastro/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:rastro/features/auth/domain/repositories/i_auth_repository.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden at startup');
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return const AuthRepositoryImpl();
});
