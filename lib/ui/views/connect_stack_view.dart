import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/ui/widgets/klyx_card.dart';

class ConnectStackView extends ConsumerStatefulWidget {
  const ConnectStackView({super.key});

  @override
  ConsumerState<ConnectStackView> createState() => _ConnectStackViewState();
}

class _ConnectStackViewState extends ConsumerState<ConnectStackView> {
  final _leetcodeController = TextEditingController();
  final _githubUserController = TextEditingController();
  final _githubTokenController = TextEditingController();
  final _codeforcesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CONNECT',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'YOUR STACK',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: KlyxColors.accentYellow,
                ),
              ),
              const SizedBox(height: 32),
              
              _InputSection(
                title: 'LEETCODE',
                child: _KlyxTextField(
                  controller: _leetcodeController,
                  hintText: 'Username',
                  icon: Icons.person_outline,
                ),
              ),
              
              const SizedBox(height: 24),
              
              _InputSection(
                title: 'GITHUB',
                child: Column(
                  children: [
                    _KlyxTextField(
                      controller: _githubUserController,
                      hintText: 'Username',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 12),
                    _KlyxTextField(
                      controller: _githubTokenController,
                      hintText: 'Personal Access Token',
                      icon: Icons.key_outlined,
                      isPassword: true,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Required for contribution data. Create at GitHub → Settings → Developer Settings → Tokens.',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              _InputSection(
                title: 'CODEFORCES',
                child: _KlyxTextField(
                  controller: _codeforcesController,
                  hintText: 'Handle',
                  icon: Icons.person_outline,
                ),
              ),
              
              const SizedBox(height: 48),
              
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    // Logic to save and navigate
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KlyxColors.accentYellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                  child: const Text('INITIALIZE PROFILE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _InputSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _KlyxTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;

  const _KlyxTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return KlyxCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.2),
            fontWeight: FontWeight.bold,
          ),
          icon: Icon(icon, color: Colors.white.withOpacity(0.4), size: 20),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
