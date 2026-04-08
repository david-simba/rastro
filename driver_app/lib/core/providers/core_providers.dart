import 'package:driver_app/core/config/app_config.dart';
import 'package:driver_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:driver_app/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden at startup');
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return const AuthRepositoryImpl();
});
