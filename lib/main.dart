import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

// ✅ Firebase 초기화: 설정 파일이 없어도 크래시 없이 넘어가도록 가드 처리
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // 이후 라운드에서 google-services.json / GoogleService-Info.plist 연결 후 정상 초기화 예정
    await Firebase.initializeApp();
  } catch (e) {
    // 설정이 없거나 환경이 준비되지 않으면 여기로 들어옴
    // 앱 실행은 계속되도록 하고, 콘솔 경고만 남김
    // ignore: avoid_print
    print('⚠️ Firebase init skipped or deferred: $e');
  }
  runApp(const ProviderScope(child: App()));
}
