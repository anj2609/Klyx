import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klyx/features/widget_builder/widget_builder_notifier.dart';
import 'package:klyx/features/widget_builder/widget_config_model.dart';

final widgetBuilderProvider =
    NotifierProvider<WidgetBuilderNotifier, List<WidgetConfig>>(
        () => WidgetBuilderNotifier());
