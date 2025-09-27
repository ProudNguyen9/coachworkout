import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  // Singleton
  AuthRepository._privateConstructor();
  static final AuthRepository instance = AuthRepository._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Current user
  User? get currentUser => _auth.currentUser;

  // User stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Email sign-in
  Future<User?> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  /// Email sign-up
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception("Email đã được sử dụng");
      } else if (e.code == 'invalid-email') {
        throw Exception("Email không hợp lệ");
      } else if (e.code == 'weak-password') {
        throw Exception("Mật khẩu quá yếu");
      } else {
        throw Exception("Lỗi: ${e.message}");
      }
    }
  }

  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        // Create a new credential
        final credential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );

        // Once signed in, return the UserCredential
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);
        return userCredential.user;
      } else {
        return null;
      }
    } catch (error) {
      print('Facebook login error: $error');
      return null;
    }
  }

  /// Google sign-in
  Future<User?> signInWithGoogle() async {
    await _googleSignIn.initialize();

    final googleUser = await _googleSignIn.authenticate(); // User canceled

    final googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  /// GitHub sign-in
  Future<User?> signInWithGithubFirebase() async {
  try {
    final githubProvider = GithubAuthProvider();
    githubProvider.addScope('read:user');
    githubProvider.addScope('user:email');

    final userCredential =
        await FirebaseAuth.instance.signInWithProvider(githubProvider);

    return userCredential.user;
  } catch (e) {
    print('GitHub login error: $e');
    return null;
  }
}


  /// Google sign-out
  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Global sign-out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
