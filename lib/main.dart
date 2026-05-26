import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/features/auth/auth_provider.dart';
import 'package:klyx/features/auth/login_screen.dart';
import 'package:klyx/ui/views/dashboard_view.dart';

final _routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      if (isLoading) return null;

      final profile = authState.value;
      final isOnLogin = state.matchedLocation == '/login';

      if (profile == null && !isOnLogin) return '/login';
      if (profile != null && isOnLogin) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardView(),
      ),
    ],
  );
});

void main() {
  runApp(
    const ProviderScope(
      child: KlyxApp(),
    ),
  );
}

class KlyxApp extends ConsumerWidget {
  const KlyxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(_routerProvider);

    return MaterialApp.router(
      title: 'Klyx',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: KlyxColors.background,
        colorScheme: ColorScheme.dark(
          primary: KlyxColors.accentRed,
          surface: KlyxColors.cardBackground,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Clash Display'),
          bodyMedium: TextStyle(fontFamily: 'Clash Display'),
          displayLarge: TextStyle(
            fontFamily: 'Clash Display',
            fontSize: 48,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Clash Display',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
