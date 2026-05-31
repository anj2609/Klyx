import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/viewmodels/dashboard_viewmodel.dart';
import 'package:klyx/ui/widgets/klyx_card.dart';
import 'package:klyx/features/auth/auth_provider.dart';

class CompetitiveView extends ConsumerStatefulWidget {
  const CompetitiveView({super.key});

  @override
  ConsumerState<CompetitiveView> createState() => _CompetitiveViewState();
}

class _CompetitiveViewState extends ConsumerState<CompetitiveView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatTimeAgo(int timestamp) {
    if (timestamp == 0) return 'UNKNOWN';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 30) {
      return '${diff.inDays ~/ 30} MO AGO';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} DAYS AGO';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} HR AGO';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} MIN AGO';
    } else {
      return 'JUST NOW';
    }
  }

  Color _getHeatmapColor(int intensity, bool isLeetcode) {
    if (intensity == 0) return Colors.white.withValues(alpha: 0.05);
    if (isLeetcode) {
      if (intensity == 1) return const Color(0xFF5A4C1C);
      if (intensity == 2) return const Color(0xFF8B751D);
      if (intensity == 3) return const Color(0xFFBA9E1B);
      return KlyxColors.accentYellow;
    } else {
      if (intensity == 1) return const Color(0xFF1E1A5A);
      if (intensity == 2) return const Color(0xFF2C248B);
      if (intensity == 3) return const Color(0xFF3B2FBA);
      return KlyxColors.accentBlue;
    }
  }

  Color _getProblemColor(String name) {
    final colors = [
      Colors.greenAccent,
      Colors.redAccent,
      Colors.blueAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
    ];
    return colors[name.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(dashboardViewModelProvider);
    final authState = ref.watch(authNotifierProvider);
    final profile = authState.value;

    return Scaffold(
      backgroundColor: KlyxColors.background,
      body: SafeArea(
        child: statsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          error: (err, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: KlyxColors.accentRed, size: 48),
                const SizedBox(height: 12),
                Text(
                  'Failed to load stats',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(dashboardViewModelProvider.notifier).refresh(),
                  style: ElevatedButton.styleFrom(backgroundColor: KlyxColors.accentRed),
                  child: const Text('RETRY', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          data: (stats) {
            final isLeetcode = _tabController.index == 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: KlyxColors.cardBackground,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _tabController.animateTo(0),
                            child: Container(
                              decoration: isLeetcode
                                  ? BoxDecoration(
                                      color: KlyxColors.accentYellow,
                                      borderRadius: BorderRadius.circular(28),
                                    )
                                  : null,
                              child: Center(
                                child: Text(
                                  'LEETCODE',
                                  style: TextStyle(
                                    color: isLeetcode ? Colors.black : Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _tabController.animateTo(1),
                            child: Container(
                              decoration: !isLeetcode
                                  ? BoxDecoration(
                                      color: KlyxColors.accentBlue,
                                      borderRadius: BorderRadius.circular(28),
                                    )
                                  : null,
                              child: Center(
                                child: Text(
                                  'CODEFORCES',
                                  style: TextStyle(
                                    color: !isLeetcode ? Colors.white : Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(), // Custom tab bar, so disable swiping or keep it
                    children: [
                      // LEETCODE TAB
                      RefreshIndicator(
                        onRefresh: () => ref.read(dashboardViewModelProvider.notifier).refresh(),
                        color: KlyxColors.accentYellow,
                        backgroundColor: KlyxColors.cardBackground,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'LEETCODE',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Profile Card
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: KlyxColors.accentYellow,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.black,
                                      backgroundImage: stats.leetcodeAvatar.isNotEmpty
                                          ? NetworkImage(stats.leetcodeAvatar)
                                          : null,
                                      child: stats.leetcodeAvatar.isEmpty
                                          ? const Icon(Icons.person, color: Colors.white, size: 40)
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            profile?.leetcodeId?.toUpperCase() ?? 'USER',
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.black,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (stats.leetcodeRealName.isNotEmpty)
                                            Text(
                                              stats.leetcodeRealName.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black.withValues(alpha: 0.6),
                                              ),
                                            ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              'RANK #${stats.leetcodeRank}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Solved Card
                              KlyxCard(
                                color: KlyxColors.cardBackground,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SOLVED',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white.withValues(alpha: 0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        _DifficultyStat(label: 'EASY', value: stats.leetcodeEasy, color: Colors.tealAccent),
                                        _DifficultyStat(label: 'MEDIUM', value: stats.leetcodeMedium, color: Colors.yellowAccent),
                                        _DifficultyStat(label: 'HARD', value: stats.leetcodeHard, color: Colors.redAccent),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Submissions Card
                              KlyxCard(
                                color: KlyxColors.cardBackground,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SUBMISSIONS',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white.withValues(alpha: 0.6),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      height: 7 * 14.0,
                                      child: GridView.builder(
                                        scrollDirection: Axis.horizontal,
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 7,
                                          mainAxisSpacing: 4,
                                          crossAxisSpacing: 4,
                                        ),
                                        itemCount: stats.leetcodeSubmissionsHeatmap.length,
                                        itemBuilder: (c, i) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: _getHeatmapColor(stats.leetcodeSubmissionsHeatmap[i], true),
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Recent Solves Header
                              Text(
                                'RECENT SOLVES',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...stats.leetcodeRecentSolves.map((solve) => Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            solve['title'] ?? 'Unknown',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: KlyxColors.accentYellow,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              (solve['lang'] ?? '').toString().toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      _formatTimeAgo(solve['timestamp'] ?? 0),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              const SizedBox(height: 48),
                            ],
                          ),
                        ),
                      ),
                      
                      // CODEFORCES TAB
                      RefreshIndicator(
                        onRefresh: () => ref.read(dashboardViewModelProvider.notifier).refresh(),
                        color: KlyxColors.accentBlue,
                        backgroundColor: KlyxColors.cardBackground,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'CODEFORCES',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Profile Card
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: KlyxColors.accentBlue,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.black, width: 2),
                                      ),
                                      child: CircleAvatar(
                                        radius: 38,
                                        backgroundColor: Colors.white,
                                        backgroundImage: stats.codeforcesAvatar.isNotEmpty
                                            ? NetworkImage(stats.codeforcesAvatar)
                                            : null,
                                        child: stats.codeforcesAvatar.isEmpty
                                            ? const Icon(Icons.person, color: Colors.grey, size: 40)
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        profile?.codeforcesId?.toUpperCase() ?? 'USER',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // 3 Stats Cards
                              Row(
                                children: [
                                  Expanded(
                                    child: _CfStatCard(
                                      label: 'CURRENT\nRATING',
                                      value: stats.codeforcesRating.toString(),
                                      iconData: Icons.trending_up,
                                      iconColor: Colors.greenAccent,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _CfStatCard(
                                      label: 'PEAK\nRATING',
                                      value: stats.codeforcesMaxRating.toString(),
                                      iconData: Icons.emoji_events,
                                      iconColor: Colors.amberAccent,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _CfStatCard(
                                      label: 'CONTESTS\nPLAYED',
                                      value: stats.codeforcesContestsPlayed.toString(),
                                      iconData: Icons.emoji_events_outlined,
                                      iconColor: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Upcoming Contests
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: KlyxColors.accentBlue,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'UPCOMING CONTESTS',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Icon(Icons.calendar_month, color: Colors.white, size: 20),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    if (stats.codeforcesUpcomingContests.isEmpty)
                                      const Text('No upcoming contests', style: TextStyle(color: Colors.white)),
                                    ...stats.codeforcesUpcomingContests.map((c) {
                                      final dt = DateTime.fromMillisecondsSinceEpoch(c['startTimeSeconds'] * 1000);
                                      final dateStr = '${dt.day} ${_month(dt.month)} ${dt.year} AT ${_formatTime(dt)}';
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (c['name'] ?? '').toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                dateStr,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Recent Solves Header
                              Text(
                                'RECENT SOLVES',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...stats.codeforcesRecentSolves.map((solve) {
                                final name = solve['name'] ?? 'Unknown';
                                final rating = solve['rating'] ?? 0;
                                final lang = solve['lang'] ?? 'Unknown';
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900,
                                                color: _getProblemColor(name),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: KlyxColors.accentBlue,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    lang.toUpperCase(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w900,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    rating.toString(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w900,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        _formatTimeAgo(solve['creationTimeSeconds'] ?? 0),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: 48),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _month(int m) {
    const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    if (m >= 1 && m <= 12) return months[m - 1];
    return '';
  }

  String _formatTime(DateTime dt) {
    int h = dt.hour;
    final ampm = h >= 12 ? 'PM' : 'AM';
    h = h % 12;
    if (h == 0) h = 12;
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m $ampm';
  }
}

class _DifficultyStat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _DifficultyStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

class _CfStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData iconData;
  final Color iconColor;

  const _CfStatCard({
    required this.label,
    required this.value,
    required this.iconData,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: KlyxColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(iconData, color: iconColor, size: 24),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
