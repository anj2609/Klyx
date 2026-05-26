import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/features/widget_builder/widget_builder_provider.dart';
import 'package:klyx/features/widget_builder/widget_renderer.dart';
import 'package:klyx/viewmodels/dashboard_viewmodel.dart';

class HomeGridView extends ConsumerWidget {
  const HomeGridView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgets = ref.watch(widgetBuilderProvider);
    final stats = ref.watch(dashboardViewModelProvider);

    if (widgets.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.widgets_outlined,
                size: 48, color: Colors.white.withOpacity(0.15)),
            const SizedBox(height: 12),
            Text(
              'No widgets configured',
              style: TextStyle(
                fontFamily: 'Clash Display',
                fontSize: 14,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ],
        ),
      );
    }

    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: widgets.map((config) {
        return StaggeredGridTile.count(
          crossAxisCellCount: config.size.crossAxisCellCount,
          mainAxisCellCount: config.size.mainAxisCellCount,
          child: WidgetRenderer(config: config, stats: stats),
        );
      }).toList(),
    );
  }
}

class HomeGridShimmer extends StatelessWidget {
  const HomeGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: KlyxColors.cardBackground,
      highlightColor: Colors.white.withOpacity(0.05),
      child: StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 1,
            child: Container(
              decoration: BoxDecoration(
                color: KlyxColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Container(
              decoration: BoxDecoration(
                color: KlyxColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 1,
            child: Container(
              decoration: BoxDecoration(
                color: KlyxColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
