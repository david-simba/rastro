import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rastro/features/auth/domain/entities/user.dart' as domain;

final authSessionProvider = StreamProvider<domain.User?>((ref) {
  return fb.FirebaseAuth.instance.authStateChanges().asyncMap((fbUser) async {
    if (fbUser == null) return null;
    await fbUser.getIdToken(true);
    return domain.User(
      userId: fbUser.uid,
      email: fbUser.email!,
      displayName: fbUser.displayName,
      photoUrl: fbUser.photoURL,
    );
  });
});