import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/viewmodels/dashboard_viewmodel.dart';
import 'package:klyx/models/dashboard_stats.dart';
import 'package:klyx/ui/widgets/klyx_card.dart';
import 'package:klyx/ui/views/github_view.dart';
import 'package:klyx/ui/views/competitive_view.dart';
import 'package:klyx/ui/views/settings_view.dart';
import 'package:klyx/features/friends/friends_screen.dart';

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
          const CompetitiveView(),
          const GithubView(),
          const FriendsScreen(),
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
    final statsAsync = ref.watch(dashboardViewModelProvider);

    return SafeArea(
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
                  fontFamily: 'Clash Display',
                  color: Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(dashboardViewModelProvider.notifier).refresh(),
                style: ElevatedButton.styleFrom(backgroundColor: KlyxColors.accentRed),
                child: const Text('RETRY', style: TextStyle(fontFamily: 'Clash Display', fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        data: (stats) => _DashboardContent(stats: stats),
      ),
    );
  }
}

class _DashboardContent extends ConsumerWidget {
  final DashboardStats stats;
  const _DashboardContent({required this.stats});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardViewModelProvider.notifier).refresh(),
      color: KlyxColors.accentGreen,
      backgroundColor: KlyxColors.cardBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                  MaterialPageRoute(builder: (context) => const CompetitiveView()),
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
                        style: const TextStyle(
                          fontFamily: 'Clash Display',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const Icon(Icons.whatshot, color: Colors.white, size: 24),
                    ],
                  ),
                  const Spacer(),
                  TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: stats.totalCompetitiveSolved),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Text(
                        '$value',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 100,
                          height: 0.9,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'GLOBAL',
                    style: const TextStyle(
                      fontFamily: 'Clash Display',
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
                        'LC: ${stats.leetcodeSolved} · CF: ${stats.codeforcesSolved}',
                        style: TextStyle(
                          fontFamily: 'Clash Display',
                          color: Colors.white.withValues(alpha: 0.6),
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
                  style: TextStyle(
                    fontFamily: 'Clash Display',
                    color: Colors.white.withValues(alpha: 0.6),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '${stats.leetcodeWeekly.where((d) => d).length}/7 DAYS',
                  style: const TextStyle(
                    fontFamily: 'Clash Display',
                    color: KlyxColors.accentYellow,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _SequentialBoxes(activeDays: stats.leetcodeWeekly),
            
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: KlyxCard(
                    color: KlyxColors.accentGreen,
                    height: 140,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.code, color: Colors.white, size: 24),
                        const Spacer(),
                        Text('${stats.githubContribs}', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Clash Display')),
                        const SizedBox(height: 2),
                        Text('GH CONTRIBS', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.7), fontFamily: 'Clash Display')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KlyxCard(
                    color: KlyxColors.accentYellow,
                    height: 140,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.terminal, color: Colors.black, size: 24),
                        const Spacer(),
                        Text('${stats.leetcodeSolved}', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Clash Display')),
                        const SizedBox(height: 2),
                        Text('LC SOLVED', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black.withValues(alpha: 0.6), fontFamily: 'Clash Display')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: KlyxCard(
                    color: KlyxColors.accentBlue,
                    height: 140,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.leaderboard, color: Colors.white, size: 24),
                        const Spacer(),
                        Text('${stats.codeforcesSolved}', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Clash Display')),
                        const SizedBox(height: 2),
                        Text('CF SOLVED', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.7), fontFamily: 'Clash Display')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: KlyxCard(
                    color: KlyxColors.cardBackground,
                    height: 140,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${stats.githubStreak}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Clash Display')),
                                Text('GH STREAK', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.54), fontFamily: 'Clash Display')),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${stats.codeforcesRating}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Clash Display')),
                                Text('CF RATING', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.54), fontFamily: 'Clash Display')),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            KlyxCard(
              color: KlyxColors.cardBackground,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TOTAL LEETCODE STREAK', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white.withValues(alpha: 0.54), fontFamily: 'Clash Display')),
                      const SizedBox(height: 4),
                      const Text('ONGOING', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: KlyxColors.accentYellow, fontFamily: 'Clash Display')),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('${stats.leetcodeStreak}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0, fontFamily: 'Clash Display')),
                      const SizedBox(width: 4),
                      Text('DAYS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white.withValues(alpha: 0.54), fontFamily: 'Clash Display')),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            const SizedBox(height: 40),
          ],
        ),
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
      height: 64,
      margin: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
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
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ) : null,
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _SequentialBoxes extends StatefulWidget {
  final List<bool> activeDays;
  const _SequentialBoxes({required this.activeDays});

  @override
  State<_SequentialBoxes> createState() => _SequentialBoxesState();
}

class _SequentialBoxesState extends State<_SequentialBoxes> {
  int _visibleCount = 0;

  @override
  void initState() {
    super.initState();
    _animateBoxes();
  }
  
  @override
  void didUpdateWidget(covariant _SequentialBoxes oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeDays != widget.activeDays) {
      _visibleCount = 0;
      _animateBoxes();
    }
  }

  void _animateBoxes() async {
    for (int i = 0; i < 7; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) setState(() => _visibleCount = i + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final isActive = widget.activeDays[index];
        final isVisible = index < _visibleCount;
        return Column(
          children: [
            AnimatedScale(
              scale: isVisible ? 1.0 : 0.8,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 40,
                height: 48,
                decoration: BoxDecoration(
                  color: isVisible && isActive ? KlyxColors.accentYellow : KlyxColors.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              days[index],
              style: TextStyle(
                fontFamily: 'Clash Display',
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      }),
    );
  }
}
