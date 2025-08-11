import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/onboarding_page.dart';
import '../features/profile/profile_page.dart';
import '../features/feed/feed_page.dart';
import '../features/matches/matches_page.dart';
import '../features/chat/chat_page.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),
    GoRoute(path: '/profile',    builder: (_, __) => const ProfilePage()),
    GoRoute(path: '/feed',       builder: (_, __) => const FeedPage()),
    GoRoute(path: '/matches',    builder: (_, __) => const MatchesPage()),
    GoRoute(path: '/chat',       builder: (_, __) => const ChatPage()),
  ],
  initialLocation: '/onboarding',
);

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text(title)),
  );
}
