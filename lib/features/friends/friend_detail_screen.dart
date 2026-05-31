import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/features/friends/friend_model.dart';
import 'package:klyx/features/friends/friend_stats_model.dart';
import 'package:klyx/features/friends/friends_provider.dart';
import 'package:klyx/viewmodels/dashboard_viewmodel.dart';
import 'package:klyx/models/dashboard_stats.dart';
import 'package:klyx/ui/widgets/klyx_card.dart';

class FriendDetailScreen extends ConsumerWidget {
  final Friend friend;
  const FriendDetailScreen({super.key, required this.friend});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(friendStatsProvider(friend));

    return Scaffold(
      backgroundColor: KlyxColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          friend.displayName.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Clash Display',
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(friendStatsProvider(friend));
        },
        color: KlyxColors.accentGreen,
        backgroundColor: KlyxColors.cardBackground,
        child: statsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          error: (err, _) => Center(
            child: KlyxCard(
              color: KlyxColors.accentRed.withValues(alpha: 0.15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      color: KlyxColors.accentRed, size: 32),
                  const SizedBox(height: 8),
                  const Text(
                    'Failed to load stats',
                    style: TextStyle(
                      fontFamily: 'Clash Display',
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () =>
                        ref.invalidate(friendStatsProvider(friend)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: KlyxColors.accentRed,
                    ),
                    child: const Text('Retry',
                        style: TextStyle(fontFamily: 'Clash Display')),
                  ),
                ],
              ),
            ),
          ),
          data: (stats) => _DetailBody(friend: friend, stats: stats),
        ),
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  final Friend friend;
  final FriendStats stats;
  const _DetailBody({required this.friend, required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Total score
        KlyxCard(
          color: KlyxColors.accentRed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL SCORE',
                style: TextStyle(
                  fontFamily: 'Clash Display',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: stats.totalScore),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (_, val, _) => Text(
                  '$val',
                  style: const TextStyle(
                    fontFamily: 'Clash Display',
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Platform stats grid
        if (friend.hasLeetcode) ...[
          _SectionLabel('LEETCODE', KlyxColors.accentYellow),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'SOLVED',
                  value: '${stats.lcTotalSolved ?? 0}',
                  color: KlyxColors.accentYellow,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: 'EASY',
                  value: '${stats.lcEasy ?? 0}',
                  color: KlyxColors.leetcodeEasy,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: 'MED',
                  value: '${stats.lcMedium ?? 0}',
                  color: KlyxColors.leetcodeMedium,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: 'HARD',
                  value: '${stats.lcHard ?? 0}',
                  color: KlyxColors.leetcodeHard,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],

        if (friend.hasGithub) ...[
          _SectionLabel('GITHUB', KlyxColors.accentGreen),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'CONTRIBS',
                  value: '${stats.ghContribs ?? 0}',
                  color: KlyxColors.accentGreen,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: 'FOLLOWERS',
                  value: '${stats.ghFollowers ?? 0}',
                  color: KlyxColors.accentGreen,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: 'STREAK',
                  value: '${stats.ghStreak ?? 0}D',
                  color: KlyxColors.accentGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],

        if (friend.hasCodeforces) ...[
          _SectionLabel('CODEFORCES', KlyxColors.accentBlue),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'RATING',
                  value: '${stats.cfRating ?? 0}',
                  color: KlyxColors.accentBlue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: 'MAX',
                  value: '${stats.cfMaxRating ?? 0}',
                  color: KlyxColors.accentBlue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MiniStat(
                  label: 'RANK',
                  value: stats.cfRank ?? '--',
                  color: KlyxColors.accentBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],

        const SizedBox(height: 16),

        // Compare button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () => _showComparison(context, ref),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'COMPARE WITH ME',
              style: TextStyle(
                fontFamily: 'Clash Display',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  void _showComparison(BuildContext context, WidgetRef ref) {
    final myStats = ref.read(dashboardViewModelProvider).value ?? DashboardStats.empty();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: KlyxColors.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'COMPARISON',
              style: TextStyle(
                fontFamily: 'Clash Display',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 24),

            // Side by side
            Row(
              children: [
                Expanded(
                  child: _CompareColumn(
                    label: 'YOU',
                    solved: myStats.leetcodeSolved,
                    contribs: myStats.githubContribs,
                    rating: myStats.codeforcesRating,
                  ),
                ),
                Container(
                  width: 1,
                  height: 120,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                Expanded(
                  child: _CompareColumn(
                    label: friend.displayName.toUpperCase(),
                    solved: stats.lcTotalSolved ?? 0,
                    contribs: stats.ghContribs ?? 0,
                    rating: stats.cfRating ?? 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Clash Display',
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: color,
        letterSpacing: 1.5,
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return KlyxCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Clash Display',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Clash Display',
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareColumn extends StatelessWidget {
  final String label;
  final int solved;
  final int contribs;
  final int rating;

  const _CompareColumn({
    required this.label,
    required this.solved,
    required this.contribs,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Clash Display',
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Colors.white.withValues(alpha: 0.5),
            letterSpacing: 1,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        _CompareRow('LC Solved', solved),
        _CompareRow('GH Contribs', contribs),
        _CompareRow('CF Rating', rating),
      ],
    );
  }
}

class _CompareRow extends StatelessWidget {
  final String label;
  final int value;
  const _CompareRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Column(
        children: [
          Text(
            '$value',
            style: const TextStyle(
              fontFamily: 'Clash Display',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Clash Display',
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}
