import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/ui/views/dashboard_view.dart';

void main() {
  runApp(
    const ProviderScope(
      child: KlyxApp(),
    ),
  );
}

class KlyxApp extends StatelessWidget {
  const KlyxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klyx',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: KlyxColors.background,
        colorScheme: ColorScheme.dark(
          primary: KlyxColors.accentRed,
          surface: KlyxColors.cardBackground,
          background: KlyxColors.background,
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
      home: const DashboardView(),
    );
  }
}
