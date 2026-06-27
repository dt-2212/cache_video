import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_options.dart';
import '../models/app_user.dart';

/// App-wide authentication state.
///
/// Supports two ways in:
///  * Google sign-in (via Firebase Auth) — a real account.
///  * Guest mode — the user skips login and just browses.
///
/// Both choices are remembered across restarts: Firebase persists the signed-in
/// session itself, and the guest choice is stored in [SharedPreferences].
///
/// Firebase init is guarded: if the platform config files are missing (see
/// `SETUP_FIREBASE.md`), the app still runs in guest mode and the Google button
/// stays disabled instead of crashing.
class AuthService extends GetxService {
  static AuthService get to => Get.find();

  static const String _guestKey = 'auth_is_guest';

  /// The signed-in user, or null when not signed in.
  final Rxn<AppUser> user = Rxn<AppUser>();

  /// True when the user chose to browse as a guest.
  final RxBool isGuest = false.obs;

  /// True while a sign-in/out request is in flight (drives button spinners).
  final RxBool isBusy = false.obs;

  /// False when Firebase couldn't initialise (config not added yet).
  final RxBool firebaseReady = false.obs;

  late final SharedPreferences _prefs;
  StreamSubscription<User?>? _authSub;

  bool get isLoggedIn => user.value != null;

  /// True once the user has either signed in or explicitly chosen guest mode —
  /// the splash screen uses this to skip the login page on later launches.
  bool get hasEntered => isLoggedIn || isGuest.value;

  /// Called from `main()` before `runApp`.
  Future<AuthService> init() async {
    _prefs = await SharedPreferences.getInstance();
    isGuest.value = _prefs.getBool(_guestKey) ?? false;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      firebaseReady.value = true;
      // Restores the session on cold start and reacts to sign-in/out.
      _authSub = FirebaseAuth.instance.authStateChanges().listen((u) {
        user.value = u == null ? null : AppUser.fromFirebase(u);
        if (u != null) _setGuest(false);
      });
    } catch (e) {
      debugPrint('⚠️ Firebase chưa cấu hình → chạy chế độ khách. ($e)');
      firebaseReady.value = false;
    }
    return this;
  }

  /// Runs the Google → Firebase sign-in flow.
  /// Returns true on success, false on cancel/error.
  Future<bool> signInWithGoogle() async {
    if (!firebaseReady.value) {
      Get.snackbar(
        'Chưa cấu hình',
        'Firebase chưa được thiết lập. Xem SETUP_FIREBASE.md.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    try {
      isBusy.value = true;
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return false; // user dismissed the picker

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      // The authStateChanges listener fills `user`.
      return true;
    } catch (e) {
      Get.snackbar(
        'Đăng nhập thất bại',
        '$e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isBusy.value = false;
    }
  }

  /// Enter the app without an account.
  void continueAsGuest() => _setGuest(true);

  /// Sign out of Google + Firebase and clear the guest flag.
  Future<void> signOut() async {
    if (firebaseReady.value) {
      try {
        await GoogleSignIn().signOut();
      } catch (_) {}
      await FirebaseAuth.instance.signOut();
    }
    user.value = null;
    _setGuest(false);
  }

  void _setGuest(bool value) {
    isGuest.value = value;
    _prefs.setBool(_guestKey, value);
  }

  @override
  void onClose() {
    _authSub?.cancel();
    super.onClose();
  }
}
