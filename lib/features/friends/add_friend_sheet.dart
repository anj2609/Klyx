import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/features/friends/friend_model.dart';
import 'package:klyx/features/friends/friends_provider.dart';

class AddFriendSheet extends ConsumerStatefulWidget {
  const AddFriendSheet({super.key});

  @override
  ConsumerState<AddFriendSheet> createState() => _AddFriendSheetState();
}

class _AddFriendSheetState extends ConsumerState<AddFriendSheet> {
  final _nameCtrl = TextEditingController();
  final _lcCtrl = TextEditingController();
  final _ghCtrl = TextEditingController();
  final _cfCtrl = TextEditingController();
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lcCtrl.dispose();
    _ghCtrl.dispose();
    _cfCtrl.dispose();
    super.dispose();
  }

  Future<void> _addFriend() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Display name is required');
      return;
    }

    setState(() {
      _error = null;
      _saving = true;
    });

    final friend = Friend(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      displayName: name,
      leetcodeId: _lcCtrl.text.trim().isEmpty ? null : _lcCtrl.text.trim(),
      githubId: _ghCtrl.text.trim().isEmpty ? null : _ghCtrl.text.trim(),
      codeforcesId: _cfCtrl.text.trim().isEmpty ? null : _cfCtrl.text.trim(),
    );

    await ref.read(friendsNotifierProvider.notifier).addFriend(friend);

    if (mounted) {
      setState(() => _saving = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${friend.displayName} added!',
            style: const TextStyle(fontFamily: 'Clash Display'),
          ),
          backgroundColor: KlyxColors.cardBackground,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: 24 + bottomPadding,
      ),
      decoration: const BoxDecoration(
        color: KlyxColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'ADD FRIEND',
              style: TextStyle(
                fontFamily: 'Clash Display',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 20),

            // Display Name (required)
            _SheetField(
              controller: _nameCtrl,
              hint: 'Display Name *',
              icon: Icons.person_outline,
              accentColor: Colors.white,
              onChanged: (_) => setState(() => _error = null),
            ),
            const SizedBox(height: 12),
            _SheetField(
              controller: _lcCtrl,
              hint: 'LeetCode Username',
              icon: Icons.code,
              accentColor: KlyxColors.accentYellow,
            ),
            const SizedBox(height: 12),
            _SheetField(
              controller: _ghCtrl,
              hint: 'GitHub Username',
              icon: Icons.terminal,
              accentColor: KlyxColors.accentGreen,
            ),
            const SizedBox(height: 12),
            _SheetField(
              controller: _cfCtrl,
              hint: 'Codeforces Handle',
              icon: Icons.emoji_events_outlined,
              accentColor: KlyxColors.accentBlue,
            ),

            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: const TextStyle(
                  fontFamily: 'Clash Display',
                  fontSize: 12,
                  color: KlyxColors.accentRed,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saving ? null : _addFriend,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        'ADD FRIEND',
                        style: TextStyle(
                          fontFamily: 'Clash Display',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Color accentColor;
  final ValueChanged<String>? onChanged;

  const _SheetField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.accentColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KlyxColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 44,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: accentColor.withOpacity(0.7), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(
                fontFamily: 'Clash Display',
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontFamily: 'Clash Display',
                  color: Colors.white.withOpacity(0.2),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
