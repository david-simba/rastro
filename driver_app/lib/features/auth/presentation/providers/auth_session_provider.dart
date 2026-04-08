import 'package:driver_app/features/auth/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authSessionProvider = StreamProvider<User?>((ref) {
  return fb.FirebaseAuth.instance.authStateChanges().asyncMap((fbUser) async {
    if (fbUser == null) return null;
    await fbUser.getIdToken(true);
    return User(
      userId: fbUser.uid,
      email: fbUser.email!,
      displayName: fbUser.displayName,
      photoUrl: fbUser.photoURL,
    );
  });
});
