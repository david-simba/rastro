import 'package:rastro/features/auth/domain/entities/user.dart';

class UserDto {
  const UserDto({
    required this.userId,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  final String userId;
  final String email;
  final String? displayName;
  final String? photoUrl;

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        userId: json['userId'] as String,
        email: json['email'] as String,
        displayName: json['displayName'] as String?,
        photoUrl: json['photoUrl'] as String?,
      );

  User toDomain() => User(
        userId: userId,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
      );
}
