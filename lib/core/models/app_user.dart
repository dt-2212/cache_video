import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    String? name,
    String? email,
    String? photoUrl,
  }) = _AppUser;

  const AppUser._();

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
