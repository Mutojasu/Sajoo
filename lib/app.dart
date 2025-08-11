import 'package:flutter/material.dart';
import 'router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Saju Match',
      theme: ThemeData(useMaterial3: true),
      routerConfig: appRouter,
    );
  }
}
