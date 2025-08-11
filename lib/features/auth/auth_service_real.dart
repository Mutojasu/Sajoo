import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth;
  AuthService(this._auth);

  /// Firebase가 초기화되어 있고 네이티브 설정이 준비되었는지 가드
  bool get isReady {
    try {
      // 값은 안 써도 접근만 되면 초기화된 것
      _auth.app;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    if (!isReady) {
      throw StateError('Firebase 미설정: google-services.json / Info.plist 필요');
    }
    final google = GoogleSignIn(scopes: ['email']);
    final account = await google.signIn();
    if (account == null) {
      throw StateError('사용자가 Google 로그인을 취소했습니다.');
    }
    final auth = await account.authentication;
    final cred = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    return _auth.signInWithCredential(cred);
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    if (!isReady) {
      throw StateError('Firebase 미설정: 이메일/비밀번호 Auth 사용 불가');
    }
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // MVP 정책: 없으면 자동 가입
        return await _auth.createUserWithEmailAndPassword(email: email, password: password);
      }
      rethrow;
    }
  }

  Future<UserCredential> signInWithApple() async {
    if (!isReady) {
      throw StateError('Firebase 미설정: iOS 설정/Capability 필요');
    }
    if (!Platform.isIOS) {
      throw UnsupportedError('Apple 로그인은 iOS에서만 지원됩니다.');
    }
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );
    final oauth = OAuthProvider('apple.com').credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );
    return _auth.signInWithCredential(oauth);
  }

  Future<void> signOut() => _auth.signOut();
}
