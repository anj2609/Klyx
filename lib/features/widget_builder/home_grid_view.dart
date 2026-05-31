import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/features/widget_builder/widget_builder_provider.dart';
import 'package:klyx/features/widget_builder/widget_renderer.dart';
import 'package:klyx/viewmodels/dashboard_viewmodel.dart';
import 'package:klyx/models/dashboard_stats.dart';

class HomeGridView extends ConsumerWidget {
  const HomeGridView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final widgets = ref.watch(widgetBuilderProvider);
    final statsAsync = ref.watch(dashboardViewModelProvider);

    if (widgets.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.widgets_outlined,
                  size: 48, color: Colors.white.withValues(alpha: 0.15)),
              const SizedBox(height: 12),
              Text(
                'No widgets configured',
                style: TextStyle(
                  fontFamily: 'Clash Display',
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap CUSTOMIZE to add widgets',
                style: TextStyle(
                  fontFamily: 'Clash Display',
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Get stats, using empty stats if still loading or errored
    final stats = statsAsync.value ?? DashboardStats.empty();

    // Build a simple Column-based grid (2 columns) to avoid StaggeredGrid
    // constraint issues inside SingleChildScrollView.
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final spacing = 12.0;
        final halfWidth = (maxWidth - spacing) / 2;
        final cellHeight = halfWidth * 1.15; // Aspect ratio including label

        final List<Widget> rows = [];
        int i = 0;
        while (i < widgets.length) {
          final config = widgets[i];
          final isWide = config.size.crossAxisCellCount == 2;
          final isTall = config.size.mainAxisCellCount == 2;

          if (isWide) {
            // Full-width widget
            rows.add(
              SizedBox(
                width: maxWidth,
                height: isTall ? cellHeight * 2 + spacing : cellHeight,
                child: WidgetRenderer(config: config, stats: stats),
              ),
            );
            i++;
          } else {
            // Try to pair with next small widget
            Widget? second;
            if (i + 1 < widgets.length &&
                widgets[i + 1].size.crossAxisCellCount == 1) {
              second = SizedBox(
                width: halfWidth,
                height: widgets[i + 1].size.mainAxisCellCount == 2
                    ? cellHeight * 2 + spacing
                    : cellHeight,
                child: WidgetRenderer(
                    config: widgets[i + 1], stats: stats),
              );
            }

            rows.add(
              Row(
                children: [
                  SizedBox(
                    width: halfWidth,
                    height: isTall ? cellHeight * 2 + spacing : cellHeight,
                    child: WidgetRenderer(config: config, stats: stats),
                  ),
                  SizedBox(width: spacing),
                  ?second,
                  if (second == null) SizedBox(width: halfWidth),
                ],
              ),
            );

            i += second != null ? 2 : 1;
          }

          if (i < widgets.length) {
            rows.add(SizedBox(height: spacing));
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows,
        );
      },
    );
  }
}
