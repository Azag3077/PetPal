import 'package:flutter/material.dart';

/// Shows one of the pet's stats as a label and a bar that fills up.
/// For example: "Hunger 70".
class StatBar extends StatelessWidget {
  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  /// The name shown on the left, like 'Hunger'.
  final String label;

  /// How full the bar is, from 0 to 100.
  final int value;

  /// The colour of the filled part of the bar.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // A fixed width keeps all three labels lined up neatly.
          SizedBox(
            width: 90,
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                // The bar wants a number between 0.0 and 1.0,
                // so we divide our 0-100 value by 100.
                value: value / 100,
                minHeight: 14,
                color: color,
                backgroundColor: Colors.grey.shade300,
              ),
            ),
          ),
          SizedBox(
            width: 44,
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
