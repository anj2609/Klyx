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
  final _githubTokenCtrl = TextEditingController();
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
    _githubTokenCtrl.dispose();
    _codeforcesCtrl.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleConnect() async {
    final lc = _leetcodeCtrl.text.trim();
    final gh = _githubCtrl.text.trim();
    final ght = _githubTokenCtrl.text.trim();
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
      githubToken: ght.isEmpty ? null : ght,
      codeforcesId: cf.isEmpty ? null : cf,
    );

    await ref.read(authNotifierProvider.notifier).login(profile);

    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/');
    }
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
                const SizedBox(height: 24),

                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/logo.jpg',
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 24),

                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Clash Display',
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: 1.2,
                    ),
                    children: [
                      TextSpan(
                        text: 'CONNECT\n',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'YOUR STACK',
                        style: TextStyle(color: KlyxColors.accentYellow),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                const _SectionTitle(title: 'LEETCODE'),
                const SizedBox(height: 16),
                _PlatformField(
                  controller: _leetcodeCtrl,
                  hintText: 'Username',
                  icon: Icons.person,
                  onChanged: (_) => setState(() => _errorText = null),
                ),

                const SizedBox(height: 32),

                const _SectionTitle(title: 'GITHUB'),
                const SizedBox(height: 16),
                _PlatformField(
                  controller: _githubCtrl,
                  hintText: 'Username',
                  icon: Icons.person,
                  onChanged: (_) => setState(() => _errorText = null),
                ),
                const SizedBox(height: 16),
                _PlatformField(
                  controller: _githubTokenCtrl,
                  hintText: 'Personal Access Token',
                  icon: Icons.vpn_key,
                  obscureText: true,
                  onChanged: (_) => setState(() => _errorText = null),
                ),
                const SizedBox(height: 12),
                Text(
                  'Required for contribution data. Create at GitHub -> Settings -> Developer Settings -> Tokens.',
                  style: TextStyle(
                    fontFamily: 'Clash Display',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: const Color(0x80FFFFFF),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 32),

                const _SectionTitle(title: 'CODEFORCES'),
                const SizedBox(height: 16),
                _PlatformField(
                  controller: _codeforcesCtrl,
                  hintText: 'Handle',
                  icon: Icons.person,
                  onChanged: (_) => setState(() => _errorText = null),
                ),

                if (_errorText != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0x1AEB4335),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0x4DEB4335)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: KlyxColors.accentRed, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorText!,
                            style: const TextStyle(
                              fontFamily: 'Clash Display',
                              color: KlyxColors.accentRed,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 48),

                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleConnect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KlyxColors.accentYellow,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            'INITIALIZE PROFILE',
                            style: TextStyle(
                              fontFamily: 'Clash Display',
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              letterSpacing: 1.2,
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

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Clash Display',
        fontSize: 13,
        fontWeight: FontWeight.w900,
        color: const Color(0xB2FFFFFF),
        letterSpacing: 1.5,
      ),
    );
  }
}

class _PlatformField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const _PlatformField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KlyxColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        style: const TextStyle(
          fontFamily: 'Clash Display',
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 20, right: 12),
            child: Icon(icon, color: const Color(0x66FFFFFF), size: 22),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 54),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontFamily: 'Clash Display',
            color: Color(0x4DFFFFFF),
            fontWeight: FontWeight.w700,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
      ),
    );
  }
}
