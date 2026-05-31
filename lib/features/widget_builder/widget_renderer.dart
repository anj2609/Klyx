import 'package:flutter/material.dart';
import 'package:klyx/features/widget_builder/widget_config_model.dart';
import 'package:klyx/features/widget_builder/widget_type.dart';
import 'package:klyx/models/dashboard_stats.dart';
import 'package:klyx/ui/widgets/contribution_grid.dart';

class WidgetRenderer extends StatelessWidget {
  final WidgetConfig config;
  final DashboardStats stats;

  const WidgetRenderer({
    super.key,
    required this.config,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    // Determine wide or tall
    final isWide = config.size.crossAxisCellCount == 2;
    
    switch (config.type) {
      case WidgetType.githubStreak:
        return _buildHotStreakWidget(context, isWide);
      case WidgetType.contributionGrid:
        return _buildContributionWidget(context, isWide);
      case WidgetType.leetcodeRating:
      case WidgetType.codeforcesRating:
      case WidgetType.problemsSolved:
      case WidgetType.commitCount:
      case WidgetType.customStat:
        return _buildWeeklyProgressWidget(context, isWide);
    }
  }

  Widget _buildHotStreakWidget(BuildContext context, bool isWide) {
    // Combined streak: use github streak as the main displayed value
    final streakDays = stats.githubStreak;

    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B30),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.all(isWide ? 20 : 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'HOT STREAK',
                        style: TextStyle(
                          fontFamily: 'Clash Display',
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$streakDays',
                        style: TextStyle(
                          fontFamily: 'Clash Display',
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: isWide ? 54 : 40,
                          height: 1.0,
                        ),
                      ),
                      const Text(
                        'DAYS',
                        style: TextStyle(
                          fontFamily: 'Clash Display',
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isWide)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildStreakRow('GITHUB', '${stats.githubStreak}'),
                      const SizedBox(height: 12),
                      _buildStreakRow('LC SOLVED', '${stats.leetcodeSolved}'),
                      const SizedBox(height: 12),
                      _buildStreakRow('CF RATING', '${stats.codeforcesRating}'),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Klyx',
          style: TextStyle(
            color: const Color(0xE6FFFFFF),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStreakRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Clash Display',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 11,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 32,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'Clash Display',
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContributionWidget(BuildContext context, bool isWide) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF131313),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isWide ? 'GITHUB' : 'GITHUB',
                      style: const TextStyle(
                        fontFamily: 'Clash Display',
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Icon(Icons.code, color: Colors.white, size: 18),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  height: 80,
                  child: ContributionGrid(
                    rows: 7,
                    columns: isWide ? 20 : 8,
                    contributions: List.generate(
                      140,
                      (i) => i < stats.githubContribs ? 1 : 0,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${stats.githubContribs} CONTRIBS THIS YEAR',
                  style: TextStyle(
                    fontFamily: 'Clash Display',
                    color: const Color(0x80FFFFFF),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Klyx',
          style: TextStyle(
            color: const Color(0xE6FFFFFF),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyProgressWidget(BuildContext context, bool isWide) {
    final activeDays = stats.leetcodeWeekly;
    final activeCount = activeDays.where((d) => d).length;

    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF3B3BFF),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: EdgeInsets.all(isWide ? 20 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isWide ? 'LEETCODE WEEKLY' : 'LEETC...',
                      style: const TextStyle(
                        fontFamily: 'Clash Display',
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      '$activeCount/7',
                      style: const TextStyle(
                        fontFamily: 'Clash Display',
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (index) {
                    final isActive = index < activeDays.length && activeDays[index];
                    final isToday = index == DateTime.now().weekday % 7;
                    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: isWide ? 32 : 14,
                          height: isWide ? 44 : 32,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : const Color(0x33FFFFFF),
                            borderRadius: BorderRadius.circular(isWide ? 8 : 4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          days[index],
                          style: TextStyle(
                            fontFamily: 'Clash Display',
                            color: isToday ? Colors.white : const Color(0x80FFFFFF),
                            fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 16),
                Text(
                  isWide ? '7-Day Progress Tracking' : '7-Day Progress Trac...',
                  style: TextStyle(
                    fontFamily: 'Clash Display',
                    color: const Color(0x99FFFFFF),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Klyx',
          style: TextStyle(
            color: const Color(0xE6FFFFFF),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
