import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/viewmodels/dashboard_viewmodel.dart';
import 'package:klyx/ui/widgets/klyx_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:klyx/ui/views/github_view.dart';
import 'package:klyx/ui/views/leaderboard_view.dart';
import 'package:klyx/ui/views/settings_view.dart';
import 'package:klyx/ui/views/connect_stack_view.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  void _onNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          const _DashboardHome(),
          const LeaderboardView(),
          const ConnectStackView(),
          const LeaderboardView(),
          const SettingsView(),
        ],
      ),
      bottomNavigationBar: _KlyxBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class _DashboardHome extends ConsumerWidget {
  const _DashboardHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(dashboardViewModelProvider);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'DASHBOARD',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            
            KlyxCard(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GithubView()),
                );
              },
              color: KlyxColors.accentRed,
              height: 220,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'COMPETITIVE SOLVED',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const Icon(Icons.fireplace, color: Colors.white, size: 24),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    '${stats.totalCompetitiveSolved}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 100,
                      height: 0.9,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'GLOBAL',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'LATEST: IN 0 SEC',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LEETCODE WEEKLY',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '6/7 DAYS',
                  style: GoogleFonts.inter(
                    color: KlyxColors.accentYellow,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
                final isActive = stats.leetcodeWeekly[index];
                return Column(
                  children: [
                    Container(
                      width: 40,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isActive ? KlyxColors.accentYellow : KlyxColors.cardBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      days[index],
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }),
            ),
            
            const SizedBox(height: 20),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _StatCard(
                  title: 'CONTRIBS',
                  value: '${stats.githubContribs}',
                  icon: FontAwesomeIcons.codeBranch,
                  color: KlyxColors.accentGreen,
                ),
                _StatCard(
                  title: 'SOLVED',
                  value: '${stats.leetcodeSolved}',
                  icon: FontAwesomeIcons.terminal,
                  color: KlyxColors.accentYellow,
                ),
                _StatCard(
                  title: 'RATING',
                  value: '${stats.codeforcesRating}',
                  icon: FontAwesomeIcons.trophy,
                  color: KlyxColors.accentBlue,
                ),
                _StatCard(
                  title: 'GH STREAK',
                  value: '${stats.githubStreak}D',
                  icon: FontAwesomeIcons.fire,
                  color: Colors.deepPurpleAccent,
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final dynamic icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return KlyxCard(
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FaIcon(icon, color: Colors.white, size: 20),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.bebasNeue(
              fontSize: 48,
              height: 1,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _KlyxBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _KlyxBottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A).withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavIcon(icon: Icons.bar_chart, isActive: currentIndex == 0, onTap: () => onTap(0)),
          _NavIcon(icon: Icons.emoji_events_outlined, isActive: currentIndex == 1, onTap: () => onTap(1)),
          _NavIcon(icon: Icons.layers_outlined, isActive: currentIndex == 2, onTap: () => onTap(2)),
          _NavIcon(icon: Icons.people_outline, isActive: currentIndex == 3, onTap: () => onTap(3)),
          _NavIcon(icon: Icons.settings_outlined, isActive: currentIndex == 4, onTap: () => onTap(4)),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavIcon({required this.icon, required this.onTap, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: isActive ? BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ) : null,
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }
}
