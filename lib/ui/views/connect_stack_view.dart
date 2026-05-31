import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/features/auth/auth_model.dart';
import 'package:klyx/features/auth/auth_provider.dart';
import 'package:klyx/ui/widgets/klyx_card.dart';
import 'package:klyx/viewmodels/dashboard_viewmodel.dart';

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
  bool _isSaving = false;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing profile data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authNotifierProvider);
      final profile = authState.value;
      if (profile != null) {
        _leetcodeController.text = profile.leetcodeId ?? '';
        _githubUserController.text = profile.githubId ?? '';
        _githubTokenController.text = profile.githubToken ?? '';
        _codeforcesController.text = profile.codeforcesId ?? '';
      }
    });
  }

  @override
  void dispose() {
    _leetcodeController.dispose();
    _githubUserController.dispose();
    _githubTokenController.dispose();
    _codeforcesController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final lc = _leetcodeController.text.trim();
    final gh = _githubUserController.text.trim();
    final ght = _githubTokenController.text.trim();
    final cf = _codeforcesController.text.trim();

    setState(() {
      _isSaving = true;
      _statusMessage = null;
    });

    final profile = UserProfile(
      leetcodeId: lc.isEmpty ? null : lc,
      githubId: gh.isEmpty ? null : gh,
      githubToken: ght.isEmpty ? null : ght,
      codeforcesId: cf.isEmpty ? null : cf,
    );

    await ref.read(authNotifierProvider.notifier).login(profile);

    // Refresh dashboard data with new credentials
    ref.invalidate(dashboardViewModelProvider);

    if (mounted) {
      setState(() {
        _isSaving = false;
        _statusMessage = 'Profile updated successfully!';
      });

      // Show success feedback and pop if navigated here
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
    }
  }

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
                      style: TextStyle(
                        fontFamily: 'Clash Display',
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.4),
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

              if (_statusMessage != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: KlyxColors.accentGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: KlyxColors.accentGreen.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: KlyxColors.accentGreen, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _statusMessage!,
                          style: const TextStyle(
                            fontFamily: 'Clash Display',
                            color: KlyxColors.accentGreen,
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
                height: 60,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KlyxColors.accentYellow,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Clash Display',
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.black,
                          ),
                        )
                      : const Text('SAVE PROFILE'),
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
          style: TextStyle(
            fontFamily: 'Clash Display',
            fontWeight: FontWeight.w900,
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.6),
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
        style: const TextStyle(fontFamily: 'Clash Display', fontWeight: FontWeight.bold, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Clash Display',
            color: Colors.white.withValues(alpha: 0.2),
            fontWeight: FontWeight.bold,
          ),
          icon: Icon(icon, color: Colors.white.withValues(alpha: 0.4), size: 20),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
