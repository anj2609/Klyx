import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:klyx/features/widget_builder/widget_config_model.dart';
import 'package:klyx/features/widget_builder/widget_type.dart';
import 'package:klyx/models/dashboard_stats.dart';
import 'package:klyx/ui/widgets/klyx_card.dart';
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
    switch (config.type) {
      case WidgetType.githubStreak:
        return _buildStatWidget(
          iconWidget: const FaIcon(FontAwesomeIcons.fire, color: Colors.white, size: 18),
          value: '${stats.githubStreak}D',
          label: 'GH STREAK',
        );
      case WidgetType.leetcodeRating:
        return _buildStatWidget(
          iconWidget: const FaIcon(FontAwesomeIcons.terminal, color: Colors.white, size: 18),
          value: '${stats.leetcodeSolved}',
          label: 'LC SOLVED',
        );
      case WidgetType.codeforcesRating:
        return _buildStatWidget(
          iconWidget: const FaIcon(FontAwesomeIcons.trophy, color: Colors.white, size: 18),
          value: '${stats.codeforcesRating}',
          label: 'CF RATING',
        );
      case WidgetType.problemsSolved:
        return _buildStatWidget(
          iconWidget: const FaIcon(FontAwesomeIcons.code, color: Colors.white, size: 18),
          value: '${stats.totalCompetitiveSolved}',
          label: 'TOTAL SOLVED',
        );
      case WidgetType.commitCount:
        return _buildStatWidget(
          iconWidget: const FaIcon(FontAwesomeIcons.codeBranch, color: Colors.white, size: 18),
          value: '${stats.githubContribs}',
          label: 'COMMITS',
        );
      case WidgetType.contributionGrid:
        return _buildContributionGrid();
      case WidgetType.customStat:
        return _buildStatWidget(
          iconWidget: const Icon(Icons.star, color: Colors.white, size: 18),
          value: '--',
          label: 'CUSTOM',
        );
    }
  }

  Widget _buildStatWidget({
    required Widget iconWidget,
    required String value,
    required String label,
  }) {
    return KlyxCard(
      color: config.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          const Spacer(),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (_, animVal, __) => Opacity(
              opacity: animVal,
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'Clash Display',
                  fontSize: config.size.crossAxisCellCount == 2 ? 42 : 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1,
                ),
              ),
            ),
          ),
          if (config.showLabel) ...[
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Clash Display',
                fontSize: 8,
                fontWeight: FontWeight.w900,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContributionGrid() {
    return KlyxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (config.showLabel)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'CONTRIBUTIONS',
                style: TextStyle(
                  fontFamily: 'Clash Display',
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: config.color,
                ),
              ),
            ),
          Expanded(
            child: ContributionGrid(
              contributions: List.generate(
                  140,
                  (i) => (i % 7 == 0 || i % 13 == 0) ? (i % 5) : 0),
            ),
          ),
        ],
      ),
    );
  }
}
