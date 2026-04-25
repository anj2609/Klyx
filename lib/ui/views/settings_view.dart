import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/ui/widgets/klyx_card.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _hapticFeedback = true;

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
                'SETTINGS',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 32),
              
              const _SettingsLabel(text: 'CONNECTED ACCOUNTS'),
              const SizedBox(height: 12),
              KlyxCard(
                child: Column(
                  children: [
                    _AccountRow(
                      icon: Icons.code,
                      name: 'LeetCode',
                      username: 'shreyanshu005',
                      color: KlyxColors.accentYellow,
                    ),
                    const Divider(color: Colors.white10),
                    _AccountRow(
                      icon: Icons.terminal,
                      name: 'GitHub',
                      username: 'shreyanshu005',
                      color: KlyxColors.accentGreen,
                    ),
                    const Divider(color: Colors.white10),
                    _AccountRow(
                      icon: Icons.emoji_events,
                      name: 'Codeforces',
                      username: 'ritiktayal18',
                      color: KlyxColors.accentBlue,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white.withOpacity(0.1)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'EDIT ACCOUNTS',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: KlyxColors.accentGreen,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              const _SettingsLabel(text: 'CONFIGURATION'),
              const SizedBox(height: 12),
              KlyxCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'HAPTIC FEEDBACK',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 12),
                    ),
                    Switch(
                      value: _hapticFeedback,
                      onChanged: (v) => setState(() => _hapticFeedback = v),
                      activeColor: KlyxColors.accentGreen,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              const _SettingsLabel(text: 'DATA & SYSTEM'),
              const SizedBox(height: 12),
              KlyxCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CLEAR CACHE',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            color: KlyxColors.accentRed,
                          ),
                        ),
                        Icon(Icons.delete_outline, color: KlyxColors.accentRed, size: 20),
                      ],
                    ),
                    const Divider(color: Colors.white10, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'VERSION',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 12),
                        ),
                        Text(
                          '1.0',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KlyxColors.accentRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'LOG OUT',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.logout),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsLabel extends StatelessWidget {
  final String text;
  const _SettingsLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(0.4),
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  final IconData icon;
  final String name;
  final String username;
  final Color color;

  const _AccountRow({
    required this.icon,
    required this.name,
    required this.username,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            name,
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const Spacer(),
          Text(
            username,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w900,
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
