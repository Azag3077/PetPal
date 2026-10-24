import 'package:flutter/material.dart';

/// Draws our pet using nothing but coloured boxes and circles.
/// A round body, two eyes and a little mouth.
class PetView extends StatelessWidget {
  const PetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      // A BoxDecoration is how we paint a Container: colour, shape, border.
      decoration: BoxDecoration(
        color: Colors.orange.shade200,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.orange.shade700, width: 4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          // The two eyes sit side by side, so they go in a Row.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Eye(),
              SizedBox(width: 36),
              _Eye(),
            ],
          ),
          SizedBox(height: 24),
          _Mouth(),
        ],
      ),
    );
  }
}

/// One single eye: a small black circle.
class _Eye extends StatelessWidget {
  const _Eye();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: const BoxDecoration(
        color: Colors.black87,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// The mouth: a wide, short box with rounded corners.
class _Mouth extends StatelessWidget {
  const _Mouth();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.brown.shade700,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
