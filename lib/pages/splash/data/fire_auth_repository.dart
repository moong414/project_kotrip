import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  /// 현재 로그인
  User? get currentUser => auth.currentUser;
  bool get isSignedIn => currentUser != null;

  /// 구글 로그인
  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // 로그인 취소한 경우

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('구글 로그인 에러: $e');
      return null;
    }
  }

  /// 애플 로그인
  Future<User?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await auth.signInWithCredential(oauthCredential);
      return userCredential.user;
    } catch (e) {
      print('애플 로그인 에러: $e');
      return null;
    }
  }

  /// 익명 로그인
  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print('익명 로그인 에러: $e');
      return null;
    }
  }

  /// 로그아웃 (구글 계정 포함)
  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {
      print('로그아웃 에러: $e');
    }
  }
}
