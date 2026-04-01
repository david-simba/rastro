class User {
  const User({
    required this.userId,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  final String userId;
  final String email;
  final String? displayName;
  final String? photoUrl;
}
