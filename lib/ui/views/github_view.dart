import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/viewmodels/github_viewmodel.dart';
import 'package:klyx/ui/widgets/klyx_card.dart';
import 'package:klyx/ui/widgets/contribution_grid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GithubView extends ConsumerWidget {
  const GithubView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(githubViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FaIcon(FontAwesomeIcons.spider, color: KlyxColors.accentRed, size: 30),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stats.username,
                          style: GoogleFonts.bebasNeue(
                            fontSize: 32,
                            color: Colors.black,
                            height: 1,
                          ),
                        ),
                        Text(
                          stats.bio,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.6),
                          ),
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
                    icon: Icons.fireplace,
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
                  style: GoogleFonts.inter(
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
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text(
              'TOP REPOSITORIES',
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            _RepoCard(name: 'Klyx', stars: 0),
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
        Icon(icon, size: 14, color: Colors.black.withOpacity(0.5)),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w900,
            color: Colors.black.withOpacity(0.8),
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
            style: GoogleFonts.bebasNeue(fontSize: 32, color: Colors.white, height: 1),
          ),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 8,
              fontWeight: FontWeight.w900,
              color: Colors.white.withOpacity(0.4),
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

  const _RepoCard({required this.name, required this.stars});

  @override
  Widget build(BuildContext context) {
    return KlyxCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.code, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 14),
              ),
            ],
          ),
          Row(
            children: [
              Text('$stars', style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withOpacity(0.6))),
              const SizedBox(width: 4),
              const Icon(Icons.star, size: 14, color: Colors.amber),
            ],
          ),
        ],
      ),
    );
  }
}
