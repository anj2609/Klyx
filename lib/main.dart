import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.bebasNeue(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
          headlineMedium: GoogleFonts.bebasNeue(
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
