import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/viewmodels/github_viewmodel.dart';
import 'package:klyx/models/github_stats.dart';
import 'package:klyx/ui/widgets/klyx_card.dart';
import 'package:klyx/ui/widgets/contribution_grid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GithubView extends ConsumerWidget {
  const GithubView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(githubViewModelProvider);

    return Scaffold(
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
                'Failed to load GitHub stats',
                style: TextStyle(
                  fontFamily: 'Clash Display',
                  color: Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(githubViewModelProvider.notifier).refresh(),
                style: ElevatedButton.styleFrom(backgroundColor: KlyxColors.accentGreen),
                child: const Text('RETRY', style: TextStyle(fontFamily: 'Clash Display', fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        data: (stats) => _GithubContent(stats: stats),
      ),
      ),
    );
  }
}

class _GithubContent extends ConsumerWidget {
  final GitHubStats stats;
  const _GithubContent({required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(githubViewModelProvider.notifier).refresh(),
      color: KlyxColors.accentGreen,
      backgroundColor: KlyxColors.cardBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GITHUB',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            
            // Profile Card
            KlyxCard(
              color: KlyxColors.accentGreen,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.black12,
                    backgroundImage: stats.avatarUrl.isNotEmpty
                        ? NetworkImage(stats.avatarUrl)
                        : null,
                    child: stats.avatarUrl.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FaIcon(FontAwesomeIcons.github, color: Colors.black, size: 30),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stats.username.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Clash Display',
                            fontSize: 32,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (stats.bio.isNotEmpty)
                          Text(
                            stats.bio.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Clash Display',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withValues(alpha: 0.6),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _ProfileStat(icon: Icons.people, value: '${stats.followers}'),
                            const SizedBox(width: 12),
                            _ProfileStat(icon: Icons.star, value: '${stats.stars}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Row of stats
            Row(
              children: [
                Expanded(
                  child: _MiniStatCard(
                    title: 'CURRENT\nDAYS',
                    value: '${stats.currentStreak}',
                    icon: Icons.whatshot,
                    color: KlyxColors.cardBackground,
                    accentColor: KlyxColors.accentRed,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniStatCard(
                    title: 'LONGEST\nDAYS',
                    value: '${stats.longestStreak}',
                    icon: Icons.emoji_events,
                    color: KlyxColors.cardBackground,
                    accentColor: KlyxColors.accentYellow,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniStatCard(
                    title: 'CONTRI...\nYEAR',
                    value: '${stats.totalContribs}',
                    icon: Icons.grid_view_rounded,
                    color: KlyxColors.cardBackground,
                    accentColor: KlyxColors.accentBlue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Contributions Heatmap
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CONTRIBUTIONS',
                  style: const TextStyle(
                    fontFamily: 'Clash Display',
                    color: KlyxColors.accentGreen,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            KlyxCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContributionGrid(contributions: stats.heatmap),
                  const SizedBox(height: 12),
                  Text(
                    '${stats.totalContribs} CONTRIBUTIONS',
                    style: TextStyle(
                      fontFamily: 'Clash Display',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            if (stats.repos.isNotEmpty) ...[
              Text(
                'TOP REPOSITORIES',
                style: TextStyle(
                  fontFamily: 'Clash Display',
                  color: Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              ...stats.repos.map((repo) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _RepoCard(
                  name: repo.name,
                  stars: repo.stars,
                  language: repo.language,
                ),
              )),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final IconData icon;
  final String value;

  const _ProfileStat({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.black.withValues(alpha: 0.5)),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Clash Display',
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Colors.black.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color accentColor;

  const _MiniStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return KlyxCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 20),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Clash Display',
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          Text(
            title,
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

class _RepoCard extends StatelessWidget {
  final String name;
  final int stars;
  final String? language;

  const _RepoCard({required this.name, required this.stars, this.language});

  @override
  Widget build(BuildContext context) {
    return KlyxCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.code, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'Clash Display',
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (language != null)
                        Text(
                          language!,
                          style: TextStyle(
                            fontFamily: 'Clash Display',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Text('$stars', style: TextStyle(fontFamily: 'Clash Display', fontSize: 12, color: Colors.white.withValues(alpha: 0.6))),
              const SizedBox(width: 4),
              const Icon(Icons.star, size: 14, color: Colors.amber),
            ],
          ),
        ],
      ),
    );
  }
}
