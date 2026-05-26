import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/features/friends/friend_model.dart';
import 'package:klyx/features/friends/friends_provider.dart';
import 'package:klyx/features/friends/add_friend_sheet.dart';
import 'package:klyx/features/friends/friend_detail_screen.dart';
import 'package:klyx/ui/widgets/klyx_card.dart';

class FriendsScreen extends ConsumerWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsNotifierProvider);

    return Scaffold(
      backgroundColor: KlyxColors.background,
      body: SafeArea(
        child: friendsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          error: (err, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                KlyxCard(
                  color: KlyxColors.accentRed.withOpacity(0.15),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline,
                          color: KlyxColors.accentRed, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to load friends',
                        style: TextStyle(
                          fontFamily: 'Clash Display',
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(friendsNotifierProvider.notifier)
                            .refresh(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: KlyxColors.accentRed,
                        ),
                        child: const Text('Retry',
                            style: TextStyle(fontFamily: 'Clash Display')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          data: (friends) => _FriendsBody(friends: friends),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const AddFriendSheet(),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

class _FriendsBody extends ConsumerWidget {
  final List<Friend> friends;
  const _FriendsBody({required this.friends});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (friends.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline,
                size: 64, color: Colors.white.withOpacity(0.15)),
            const SizedBox(height: 16),
            Text(
              'No friends yet',
              style: TextStyle(
                fontFamily: 'Clash Display',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add one to compete!',
              style: TextStyle(
                fontFamily: 'Clash Display',
                fontSize: 12,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(friendsNotifierProvider.notifier).refresh(),
      color: KlyxColors.accentGreen,
      backgroundColor: KlyxColors.cardBackground,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: friends.length + 1, // +1 for header
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'FRIENDS',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            );
          }
          final friend = friends[index - 1];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _FriendCard(friend: friend),
          );
        },
      ),
    );
  }
}

class _FriendCard extends ConsumerWidget {
  final Friend friend;
  const _FriendCard({required this.friend});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(friendStatsProvider(friend));

    return KlyxCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FriendDetailScreen(friend: friend),
          ),
        );
      },
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                friend.displayName.isNotEmpty
                    ? friend.displayName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontFamily: 'Clash Display',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name and badges
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.displayName.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Clash Display',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (friend.hasLeetcode)
                      _PlatformPill(label: 'LC', color: KlyxColors.accentYellow),
                    if (friend.hasGithub)
                      _PlatformPill(label: 'GH', color: KlyxColors.accentGreen),
                    if (friend.hasCodeforces)
                      _PlatformPill(label: 'CF', color: KlyxColors.accentBlue),
                  ],
                ),
              ],
            ),
          ),

          // Score
          statsAsync.when(
            loading: () => const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white24,
              ),
            ),
            error: (_, __) => const Text(
              '--',
              style: TextStyle(
                fontFamily: 'Clash Display',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white24,
              ),
            ),
            data: (stats) => Text(
              '${stats.totalScore}',
              style: const TextStyle(
                fontFamily: 'Clash Display',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlatformPill extends StatelessWidget {
  final String label;
  final Color color;
  const _PlatformPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Clash Display',
          fontSize: 9,
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }
}
