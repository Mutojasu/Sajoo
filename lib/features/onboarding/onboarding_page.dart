import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/auth_state.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});
  Future<void> _dummyLogin(WidgetRef ref, BuildContext c) async {
    await Future.delayed(const Duration(milliseconds: 800));
    ref.read(authStateProvider.notifier).state = true;
    if (c.mounted) GoRouter.of(c).go('/profile');
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ElevatedButton(onPressed: () => _dummyLogin(ref, context), child: const Text('Continue with Apple')),
          ElevatedButton(onPressed: () => _dummyLogin(ref, context), child: const Text('Continue with Google')),
          ElevatedButton(onPressed: () => _dummyLogin(ref, context), child: const Text('Continue with Email')),
        ]),
      ),
    );
  }
}
