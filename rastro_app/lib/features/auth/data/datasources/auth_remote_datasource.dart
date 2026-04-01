import 'package:network/network.dart';

import 'package:rastro/features/auth/data/dto/user_dto.dart';

class AuthRemoteDatasource {
  const AuthRemoteDatasource(this._client);

  final ApiClient _client;

  Future<Result<UserDto, NetworkError>> login(String idToken) =>
      _client.post(
        '/api/auth/login',
        data: {'idToken': idToken},
        fromJson: UserDto.fromJson,
      );

  Future<Result<UserDto, NetworkError>> register({
    required String email,
    required String password,
    String? displayName,
  }) =>
      _client.post(
        '/api/auth/register',
        data: {
          'email': email,
          'password': password,
          'displayName': ?displayName,
        },
        fromJson: UserDto.fromJson,
      );
}
