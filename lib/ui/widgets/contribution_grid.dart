import 'package:flutter/material.dart';
import 'package:klyx/core/theme/colors.dart';

class ContributionGrid extends StatelessWidget {
  final List<int> contributions; // 0 to 4 representing intensity
  final int rows;
  final int columns;

  const ContributionGrid({
    super.key,
    required this.contributions,
    this.rows = 7,
    this.columns = 20,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: rows * columns,
      itemBuilder: (context, index) {
        final intensity = (index < contributions.length) ? contributions[index] : 0;
        return Container(
          decoration: BoxDecoration(
            color: _getColorForIntensity(intensity),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }

  Color _getColorForIntensity(int intensity) {
    switch (intensity) {
      case 0:
        return Colors.white.withOpacity(0.05);
      case 1:
        return KlyxColors.accentGreen.withOpacity(0.2);
      case 2:
        return KlyxColors.accentGreen.withOpacity(0.5);
      case 3:
        return KlyxColors.accentGreen.withOpacity(0.8);
      case 4:
        return KlyxColors.accentGreen;
      default:
        return Colors.white.withOpacity(0.05);
    }
  }
}
