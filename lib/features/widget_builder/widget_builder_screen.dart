import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:klyx/core/theme/colors.dart';
import 'package:klyx/features/widget_builder/widget_builder_provider.dart';
import 'package:klyx/features/widget_builder/widget_config_model.dart';
import 'package:klyx/features/widget_builder/widget_renderer.dart';
import 'package:klyx/features/widget_builder/widget_size.dart';
import 'package:klyx/features/widget_builder/widget_type.dart';
import 'package:klyx/viewmodels/dashboard_viewmodel.dart';

class WidgetBuilderScreen extends ConsumerStatefulWidget {
  const WidgetBuilderScreen({super.key});

  @override
  ConsumerState<WidgetBuilderScreen> createState() =>
      _WidgetBuilderScreenState();
}

class _WidgetBuilderScreenState extends ConsumerState<WidgetBuilderScreen> {
  @override
  Widget build(BuildContext context) {
    final widgets = ref.watch(widgetBuilderProvider);
    final stats = ref.watch(dashboardViewModelProvider);

    return Scaffold(
      backgroundColor: KlyxColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'WIDGET BUILDER',
          style: TextStyle(
            fontFamily: 'Clash Display',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(widgetBuilderProvider.notifier).resetToDefault();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Layout reset to default',
                      style: TextStyle(fontFamily: 'Clash Display')),
                  backgroundColor: KlyxColors.cardBackground,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: Text(
              'RESET',
              style: TextStyle(
                fontFamily: 'Clash Display',
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: KlyxColors.accentRed.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Top: Live preview grid
          Expanded(
            flex: 3,
            child: DragTarget<WidgetType>(
              onAcceptWithDetails: (details) {
                final type = details.data;
                final config = WidgetConfig(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  type: type,
                  size: WidgetSize.medium,
                  colorAccent: _colorForType(type),
                  showLabel: true,
                );
                ref.read(widgetBuilderProvider.notifier).addWidget(config);
              },
              builder: (context, candidateData, rejectedData) {
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: candidateData.isNotEmpty
                        ? Colors.white.withOpacity(0.03)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: candidateData.isNotEmpty
                          ? KlyxColors.accentGreen.withOpacity(0.3)
                          : Colors.white.withOpacity(0.05),
                      width: candidateData.isNotEmpty ? 2 : 1,
                    ),
                  ),
                  child: widgets.isEmpty
                      ? Center(
                          child: Text(
                            'Drag widgets here',
                            style: TextStyle(
                              fontFamily: 'Clash Display',
                              color: Colors.white.withOpacity(0.2),
                              fontSize: 14,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: StaggeredGrid.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            children: widgets.map((config) {
                              return StaggeredGridTile.count(
                                crossAxisCellCount:
                                    config.size.crossAxisCellCount,
                                mainAxisCellCount:
                                    config.size.mainAxisCellCount,
                                child: GestureDetector(
                                  onTap: () =>
                                      _showConfigPanel(context, config),
                                  onLongPress: () =>
                                      _showDeleteConfirm(context, config),
                                  child: WidgetRenderer(
                                      config: config, stats: stats),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                );
              },
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                    child:
                        Divider(color: Colors.white.withOpacity(0.08))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'AVAILABLE WIDGETS',
                    style: TextStyle(
                      fontFamily: 'Clash Display',
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white.withOpacity(0.3),
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Expanded(
                    child:
                        Divider(color: Colors.white.withOpacity(0.08))),
              ],
            ),
          ),

          // Bottom: Palette of available widgets
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: WidgetType.values.length,
              itemBuilder: (context, index) {
                final type = WidgetType.values[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: LongPressDraggable<WidgetType>(
                    data: type,
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 90,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color(_colorForType(type)).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(_colorForType(type))
                                  .withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            type.shortLabel,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Clash Display',
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: _PaletteTile(type: type),
                    ),
                    child: _PaletteTile(type: type),
                  ),
                );
              },
            ),
          ),

          // Save button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await ref
                      .read(widgetBuilderProvider.notifier)
                      .saveLayout();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Layout saved!',
                            style: TextStyle(fontFamily: 'Clash Display')),
                        backgroundColor: KlyxColors.cardBackground,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'SAVE LAYOUT',
                  style: TextStyle(
                    fontFamily: 'Clash Display',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _colorForType(WidgetType type) {
    switch (type) {
      case WidgetType.githubStreak:
      case WidgetType.commitCount:
      case WidgetType.contributionGrid:
        return KlyxColors.accentGreen.value;
      case WidgetType.leetcodeRating:
      case WidgetType.problemsSolved:
        return KlyxColors.accentYellow.value;
      case WidgetType.codeforcesRating:
        return KlyxColors.accentBlue.value;
      case WidgetType.customStat:
        return KlyxColors.accentRed.value;
    }
  }

  void _showConfigPanel(BuildContext context, WidgetConfig config) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ConfigPanel(config: config),
    );
  }

  void _showDeleteConfirm(BuildContext context, WidgetConfig config) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: KlyxColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Remove Widget?',
          style: TextStyle(
            fontFamily: 'Clash Display',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        content: Text(
          'Remove "${config.type.displayName}" from your layout?',
          style: TextStyle(
            fontFamily: 'Clash Display',
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Clash Display',
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(widgetBuilderProvider.notifier).removeWidget(config.id);
              Navigator.pop(ctx);
            },
            child: const Text(
              'Remove',
              style: TextStyle(
                fontFamily: 'Clash Display',
                color: KlyxColors.accentRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaletteTile extends StatelessWidget {
  final WidgetType type;
  const _PaletteTile({required this.type});

  @override
  Widget build(BuildContext context) {
    final color = _paletteColor(type);
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.widgets_outlined, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            type.shortLabel,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Clash Display',
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _paletteColor(WidgetType type) {
    switch (type) {
      case WidgetType.githubStreak:
      case WidgetType.commitCount:
      case WidgetType.contributionGrid:
        return KlyxColors.accentGreen;
      case WidgetType.leetcodeRating:
      case WidgetType.problemsSolved:
        return KlyxColors.accentYellow;
      case WidgetType.codeforcesRating:
        return KlyxColors.accentBlue;
      case WidgetType.customStat:
        return KlyxColors.accentRed;
    }
  }
}

class _ConfigPanel extends ConsumerStatefulWidget {
  final WidgetConfig config;
  const _ConfigPanel({required this.config});

  @override
  ConsumerState<_ConfigPanel> createState() => _ConfigPanelState();
}

class _ConfigPanelState extends ConsumerState<_ConfigPanel> {
  late WidgetSize _selectedSize;
  late int _selectedColor;
  late bool _showLabel;

  static const _colorSwatches = [
    0xFFEB4335, // Red
    0xFF4BD37B, // Green
    0xFFF7CE46, // Yellow
    0xFF3B3BFF, // Blue
    0xFF9C27B0, // Purple
  ];

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.config.size;
    _selectedColor = widget.config.colorAccent;
    _showLabel = widget.config.showLabel;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: KlyxColors.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.config.type.displayName.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Clash Display',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),

          // Size picker
          Text(
            'SIZE',
            style: TextStyle(
              fontFamily: 'Clash Display',
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: WidgetSize.values.map((size) {
              final isSelected = _selectedSize == size;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedSize = size),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Colors.white.withOpacity(0.3)
                            : Colors.white.withOpacity(0.08),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        size.displayName,
                        style: TextStyle(
                          fontFamily: 'Clash Display',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Color picker
          Text(
            'COLOR',
            style: TextStyle(
              fontFamily: 'Clash Display',
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: _colorSwatches.map((c) {
              final isSelected = _selectedColor == c;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = c),
                child: Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Color(c),
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 2)
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Label toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SHOW LABEL',
                style: TextStyle(
                  fontFamily: 'Clash Display',
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
              Switch(
                value: _showLabel,
                onChanged: (v) => setState(() => _showLabel = v),
                activeColor: KlyxColors.accentGreen,
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                ref.read(widgetBuilderProvider.notifier).updateWidget(
                      widget.config.copyWith(
                        size: _selectedSize,
                        colorAccent: _selectedColor,
                        showLabel: _showLabel,
                      ),
                    );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'APPLY',
                style: TextStyle(
                  fontFamily: 'Clash Display',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
