import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service_real.dart';

/// FirebaseAuth 인스턴스
final firebaseAuthProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

/// 실제 인증 서비스
final authServiceProvider = Provider<AuthService>((ref) {
  final auth = ref.read(firebaseAuthProvider);
  return AuthService(auth);
});

/// 로그인 상태 스트림(User? 변동)
final authUserStreamProvider = StreamProvider<User?>((ref) {
  final auth = ref.read(firebaseAuthProvider);
  return auth.authStateChanges();
});
