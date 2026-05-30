import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class AuthRepository {
  AuthRepository._privateConstructor();
  static final AuthRepository instance = AuthRepository._privateConstructor();

  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<User?> signInWithEmail(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user;
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: 'coachworkout://login-callback/',
    );
    return response.user;
  }

  /// 🔐 Google Sign-in + Deep link callback (no console log)
  Future<bool> signInWithGoogle() async {
    final auth = _supabase.auth;
    final completer = Completer<bool>();

    late final StreamSubscription<AuthState> sub;

    sub = auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (data.event == AuthChangeEvent.signedIn && session != null) {
        completer.complete(true);
        sub.cancel();
      } else if (data.event == AuthChangeEvent.signedOut) {
        sub.cancel();
        completer.complete(false);
      }
    });

    try {
      await auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'coachworkout://login-callback/',
      );
    } catch (_) {
      sub.cancel();
      completer.complete(false);
    }

    return completer.future;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}


