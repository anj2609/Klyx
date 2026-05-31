import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/features/friends/friends_provider.dart';
import 'package:klyx/features/friends/friend_model.dart';
import 'package:klyx/ui/widgets/klyx_card.dart';

class LeaderboardView extends ConsumerWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LIVE',
                        style: const TextStyle(
                          fontFamily: 'Clash Display',
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: KlyxColors.accentBlue,
                        ),
                      ),
                      Text(
                        'LEADERBOARD',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: KlyxColors.accentBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              friendsAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
                error: (err, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Text(
                      'Failed to load leaderboard',
                      style: TextStyle(
                        fontFamily: 'Clash Display',
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                data: (friends) {
                  if (friends.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Icon(Icons.emoji_events_outlined,
                                size: 48, color: Colors.white.withValues(alpha: 0.15)),
                            const SizedBox(height: 12),
                            Text(
                              'Add friends to see the leaderboard',
                              style: TextStyle(
                                fontFamily: 'Clash Display',
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return _LeaderboardList(friends: friends);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaderboardList extends ConsumerWidget {
  final List<Friend> friends;
  const _LeaderboardList({required this.friends});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Build a list of entries with stats
    final entries = <_LeaderboardEntry>[];
    
    for (final friend in friends) {
      final statsAsync = ref.watch(friendStatsProvider(friend));
      final stats = statsAsync.value;
      entries.add(_LeaderboardEntry(
        name: friend.displayName.toUpperCase(),
        solved: stats?.totalScore ?? 0,
      ));
    }

    // Sort by solved count descending
    entries.sort((a, b) => b.solved.compareTo(a.solved));

    return Column(
      children: [
        for (int i = 0; i < entries.length; i++) ...[
          _LeaderboardItem(
            rank: i + 1,
            name: entries[i].name,
            solved: entries[i].solved,
            color: i == 0 ? KlyxColors.accentYellow : Colors.white,
            opacity: i == 0 ? 1.0 : (i == 1 ? 0.2 : 0.1),
          ),
          if (i < entries.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _LeaderboardEntry {
  final String name;
  final int solved;
  const _LeaderboardEntry({required this.name, required this.solved});
}

class _LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;
  final int solved;
  final Color color;
  final double opacity;

  const _LeaderboardItem({
    required this.rank,
    required this.name,
    required this.solved,
    required this.color,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return KlyxCard(
      color: color.withValues(alpha: opacity == 1.0 ? 1.0 : opacity),
      child: Row(
        children: [
          Text(
            '#$rank',
            style: TextStyle(
              fontFamily: 'Clash Display',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: opacity == 1.0 ? Colors.black : Colors.white.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Clash Display',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: opacity == 1.0 ? Colors.black : Colors.white.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'SCORE',
                  style: TextStyle(
                    fontFamily: 'Clash Display',
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: opacity == 1.0 ? Colors.black.withValues(alpha: 0.4) : KlyxColors.accentGreen,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$solved',
            style: TextStyle(
              fontFamily: 'Clash Display',
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: opacity == 1.0 ? Colors.black : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
