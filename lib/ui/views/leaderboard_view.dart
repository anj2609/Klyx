import 'package:flutter/material.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/ui/widgets/klyx_card.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
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
              
              const _LeaderboardItem(
                rank: 1,
                name: 'RITIK',
                solved: 37,
                color: KlyxColors.accentYellow,
              ),
              const SizedBox(height: 12),
              const _LeaderboardItem(
                rank: 2,
                name: 'ANISH',
                solved: 0,
                color: Colors.white,
                opacity: 0.2,
              ),
              const SizedBox(height: 12),
              const _LeaderboardItem(
                rank: 3,
                name: 'DIVYANSH',
                solved: 0,
                color: Colors.white,
                opacity: 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
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
      color: color.withOpacity(opacity == 1.0 ? 1.0 : opacity),
      child: Row(
        children: [
          Text(
            '#$rank',
            style: TextStyle(
              fontFamily: 'Clash Display',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: opacity == 1.0 ? Colors.black : Colors.white.withOpacity(0.4),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Clash Display',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: opacity == 1.0 ? Colors.black : Colors.white.withOpacity(0.6),
                ),
              ),
              Text(
                'SOLVED',
                style: TextStyle(
                  fontFamily: 'Clash Display',
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  color: opacity == 1.0 ? Colors.black.withOpacity(0.4) : KlyxColors.accentGreen,
                ),
              ),
            ],
          ),
          const Spacer(),
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
