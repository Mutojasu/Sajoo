import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 기존 더미 상태(흐름 유지용)
import '../../core/constants/auth_state.dart';

// ✅ 실연동 Auth 프로바이더/서비스
import '../auth/auth_providers.dart';
import '../auth/auth_service_real.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  Future<void> _handle(
    WidgetRef ref,
    BuildContext c,
    Future<void> Function(AuthService) action,
  ) async {
    final svc = ref.read(authServiceProvider);
    try {
      await action(svc);
      // 로그인 성공 시 기존 더미 상태도 true로 동기화(기존 흐름 유지)
      ref.read(authStateProvider.notifier).state = true;
      if (c.mounted) GoRouter.of(c).go('/profile');
    } catch (e) {
      // 설정 누락/취소/오류 모두 사용자에게 안내
      ScaffoldMessenger.of(c).showSnackBar(
        SnackBar(content: Text('로그인 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => _handle(ref, context, (svc) async {
                // iOS 외에서는 UnsupportedError 발생 → 가드 메시지로 안내됨
                await svc.signInWithApple();
              }),
              child: const Text('Continue with Apple'),
            ),
            ElevatedButton(
              onPressed: () => _handle(ref, context, (svc) async {
                await svc.signInWithGoogle();
              }),
              child: const Text('Continue with Google'),
            ),
            ElevatedButton(
              onPressed: () => _handle(ref, context, (svc) async {
                // MVP용 임시 이메일 플로우(없으면 자동 가입 시도)
                await svc.signInWithEmail('test@example.com', 'Passw0rd!');
              }),
              child: const Text('Continue with Email'),
            ),
          ],
        ),
      ),
    );
  }
}
