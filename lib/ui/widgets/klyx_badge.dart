import 'package:flutter/material.dart';

class KlyxBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;

  const KlyxBadge({
    super.key,
    required this.label,
    required this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Clash Display',
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: textColor ?? Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
