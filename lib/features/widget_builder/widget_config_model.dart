import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:klyx/features/widget_builder/widget_type.dart';
import 'package:klyx/features/widget_builder/widget_size.dart';

class WidgetConfig {
  final String id;
  final WidgetType type;
  final WidgetSize size;
  final String? platform;
  final int colorAccent; // store as ARGB int
  final bool showLabel;
  final int order;

  const WidgetConfig({
    required this.id,
    required this.type,
    this.size = WidgetSize.medium,
    this.platform,
    this.colorAccent = 0xFFEB4335,
    this.showLabel = true,
    this.order = 0,
  });

  Color get color => Color(colorAccent);

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'size': size.name,
        'platform': platform,
        'colorAccent': colorAccent,
        'showLabel': showLabel,
        'order': order,
      };

  factory WidgetConfig.fromJson(Map<String, dynamic> json) => WidgetConfig(
        id: json['id'] as String,
        type: WidgetType.values.firstWhere((e) => e.name == json['type']),
        size: WidgetSize.values.firstWhere((e) => e.name == json['size']),
        platform: json['platform'] as String?,
        colorAccent: json['colorAccent'] as int,
        showLabel: json['showLabel'] as bool,
        order: json['order'] as int,
      );

  WidgetConfig copyWith({
    String? id,
    WidgetType? type,
    WidgetSize? size,
    String? platform,
    int? colorAccent,
    bool? showLabel,
    int? order,
  }) =>
      WidgetConfig(
        id: id ?? this.id,
        type: type ?? this.type,
        size: size ?? this.size,
        platform: platform ?? this.platform,
        colorAccent: colorAccent ?? this.colorAccent,
        showLabel: showLabel ?? this.showLabel,
        order: order ?? this.order,
      );

  static List<WidgetConfig> decodeList(String? source) {
    if (source == null || source.isEmpty) return [];
    try {
      final list = jsonDecode(source) as List;
      return list
          .map((e) => WidgetConfig.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static String encodeList(List<WidgetConfig> widgets) =>
      jsonEncode(widgets.map((w) => w.toJson()).toList());

  static List<WidgetConfig> defaultLayout() => [
        const WidgetConfig(
          id: 'default_gh_streak',
          type: WidgetType.githubStreak,
          size: WidgetSize.medium,
          colorAccent: 0xFF4BD37B,
          showLabel: true,
          order: 0,
        ),
        const WidgetConfig(
          id: 'default_lc_solved',
          type: WidgetType.leetcodeRating,
          size: WidgetSize.medium,
          colorAccent: 0xFFF7CE46,
          showLabel: true,
          order: 1,
        ),
      ];
}
