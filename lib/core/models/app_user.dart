import 'package:firebase_auth/firebase_auth.dart';

/// The signed-in user, decoupled from Firebase so the UI only depends on this.
class AppUser {
  final String uid;
  final String? name;
  final String? email;
  final String? photoUrl;

  const AppUser({
    required this.uid,
    this.name,
    this.email,
    this.photoUrl,
  });

  /// Build from a Firebase [User] (Google sign-in fills name/email/photo).
  factory AppUser.fromFirebase(User u) => AppUser(
        uid: u.uid,
        name: u.displayName,
        email: u.email,
        photoUrl: u.photoURL,
      );

  /// A friendly display name, falling back to the email handle or "User".
  String get displayName =>
      (name?.trim().isNotEmpty ?? false)
          ? name!
          : (email?.split('@').first ?? 'User');
}
