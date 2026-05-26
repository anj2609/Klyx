import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/features/auth/auth_model.dart';
import 'package:klyx/features/auth/auth_provider.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _leetcodeCtrl = TextEditingController();
  final _githubCtrl = TextEditingController();
  final _codeforcesCtrl = TextEditingController();
  String? _errorText;
  bool _isLoading = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _leetcodeCtrl.dispose();
    _githubCtrl.dispose();
    _codeforcesCtrl.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleConnect() async {
    final lc = _leetcodeCtrl.text.trim();
    final gh = _githubCtrl.text.trim();
    final cf = _codeforcesCtrl.text.trim();

    if (lc.isEmpty && gh.isEmpty && cf.isEmpty) {
      setState(() => _errorText = 'Enter at least one platform ID to continue');
      return;
    }

    setState(() {
      _errorText = null;
      _isLoading = true;
    });

    final profile = UserProfile(
      leetcodeId: lc.isEmpty ? null : lc,
      githubId: gh.isEmpty ? null : gh,
      codeforcesId: cf.isEmpty ? null : cf,
    );

    await ref.read(authNotifierProvider.notifier).login(profile);

    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/');
    }
  }

  Future<void> _handleSkip() async {
    await ref.read(authNotifierProvider.notifier).skipLogin();
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KlyxColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // Logo / Wordmark
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'KLYX',
                        style: TextStyle(
                          fontFamily: 'Clash Display',
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 8,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'COMPETITIVE CODING DASHBOARD',
                        style: TextStyle(
                          fontFamily: 'Clash Display',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.4),
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 56),

                // Section title
                Text(
                  'CONNECT YOUR PLATFORMS',
                  style: TextStyle(
                    fontFamily: 'Clash Display',
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withOpacity(0.5),
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                // LeetCode field
                _PlatformField(
                  controller: _leetcodeCtrl,
                  hintText: 'LeetCode Username',
                  icon: Icons.code,
                  accentColor: KlyxColors.accentYellow,
                  onChanged: (_) => setState(() => _errorText = null),
                ),

                const SizedBox(height: 16),

                // GitHub field
                _PlatformField(
                  controller: _githubCtrl,
                  hintText: 'GitHub Username',
                  icon: Icons.terminal,
                  accentColor: KlyxColors.accentGreen,
                  onChanged: (_) => setState(() => _errorText = null),
                ),

                const SizedBox(height: 16),

                // Codeforces field
                _PlatformField(
                  controller: _codeforcesCtrl,
                  hintText: 'Codeforces Handle',
                  icon: Icons.emoji_events_outlined,
                  accentColor: KlyxColors.accentBlue,
                  onChanged: (_) => setState(() => _errorText = null),
                ),

                // Inline error
                if (_errorText != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: KlyxColors.accentRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: KlyxColors.accentRed.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: KlyxColors.accentRed, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorText!,
                            style: const TextStyle(
                              fontFamily: 'Clash Display',
                              color: KlyxColors.accentRed,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 40),

                // Connect CTA
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleConnect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'CONNECT & START',
                            style: TextStyle(
                              fontFamily: 'Clash Display',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Skip
                Center(
                  child: TextButton(
                    onPressed: _isLoading ? null : _handleSkip,
                    child: Text(
                      'Skip for now',
                      style: TextStyle(
                        fontFamily: 'Clash Display',
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlatformField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final Color accentColor;
  final ValueChanged<String>? onChanged;

  const _PlatformField({
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.accentColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KlyxColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          // Colored left accent bar
          Container(
            width: 4,
            height: 52,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: accentColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                fontFamily: 'Clash Display',
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  fontFamily: 'Clash Display',
                  color: Colors.white.withOpacity(0.2),
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
