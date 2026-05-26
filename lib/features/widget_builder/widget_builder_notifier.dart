import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:klyx/features/widget_builder/widget_config_model.dart';

const _kWidgetLayoutKey = 'klyx_widget_layout';

class WidgetBuilderNotifier extends Notifier<List<WidgetConfig>> {
  @override
  List<WidgetConfig> build() {
    _load();
    return WidgetConfig.defaultLayout();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kWidgetLayoutKey);
    final widgets = WidgetConfig.decodeList(raw);
    state = widgets.isEmpty ? WidgetConfig.defaultLayout() : widgets;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kWidgetLayoutKey, WidgetConfig.encodeList(state));
  }

  void addWidget(WidgetConfig config) {
    final newOrder = state.isEmpty ? 0 : state.last.order + 1;
    state = [...state, config.copyWith(order: newOrder)];
    _persist();
  }

  void removeWidget(String id) {
    state = state.where((w) => w.id != id).toList();
    _persist();
  }

  void updateWidget(WidgetConfig updated) {
    state = [
      for (final w in state)
        if (w.id == updated.id) updated else w,
    ];
    _persist();
  }

  void reorder(int oldIndex, int newIndex) {
    final items = List<WidgetConfig>.from(state);
    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
    state = [
      for (int i = 0; i < items.length; i++) items[i].copyWith(order: i),
    ];
    _persist();
  }

  void resetToDefault() {
    state = WidgetConfig.defaultLayout();
    _persist();
  }

  Future<void> saveLayout() async {
    await _persist();
  }
}
