import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/features/auth/auth_provider.dart';
import 'package:klyx/features/auth/login_screen.dart';
import 'package:klyx/features/widget_builder/widget_builder_screen.dart';
import 'package:klyx/ui/views/dashboard_view.dart';

import 'package:klyx/services/notification_service.dart';

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
        routes: [
          GoRoute(
            path: 'widget-builder',
            builder: (context, state) => const WidgetBuilderScreen(),
          ),
        ],
      ),
    ],
  );
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
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
        fontFamily: 'Clash Display',
        colorScheme: ColorScheme.dark(
          primary: KlyxColors.accentRed,
          surface: KlyxColors.cardBackground,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Clash Display',
        ).copyWith(
          bodyLarge: const TextStyle(fontFamily: 'Clash Display', fontSize: 18),
          bodyMedium: const TextStyle(fontFamily: 'Clash Display', fontSize: 16),
          displayLarge: const TextStyle(
            fontFamily: 'Clash Display',
            fontSize: 56,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
          headlineMedium: const TextStyle(
            fontFamily: 'Clash Display',
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
