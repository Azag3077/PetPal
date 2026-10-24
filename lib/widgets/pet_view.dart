import 'package:flutter/material.dart';

import '../models/pet.dart';

/// Draws our pet using nothing but coloured boxes and circles.
/// The face and the colour change depending on the pet's mood.
class PetView extends StatelessWidget {
  const PetView({super.key, required this.mood});

  /// How the pet is feeling right now.
  final Mood mood;

  /// Picks the body colour for each mood.
  /// A `switch` on an enum is neat: the compiler checks we covered every mood.
  Color get _bodyColor {
    switch (mood) {
      case Mood.happy:
        return Colors.orange.shade200;
      case Mood.okay:
        return Colors.amber.shade100;
      case Mood.sad:
        return Colors.blueGrey.shade200;
      case Mood.sleepy:
        return Colors.indigo.shade100;
    }
  }

  /// A short word to show under the pet.
  String get _moodLabel {
    switch (mood) {
      case Mood.happy:
        return 'Happy';
      case Mood.okay:
        return 'Okay';
      case Mood.sad:
        return 'Sad';
      case Mood.sleepy:
        return 'Sleepy';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: _bodyColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.orange.shade700, width: 4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // When the pet is sleepy the eyes are closed, so we swap in a
              // different widget. This is an `if` choosing a widget.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Eye(closed: mood == Mood.sleepy),
                  const SizedBox(width: 36),
                  _Eye(closed: mood == Mood.sleepy),
                ],
              ),
              const SizedBox(height: 24),
              _Mouth(mood: mood),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _moodLabel,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// One single eye. Open it is a black circle; closed it is a thin line.
class _Eye extends StatelessWidget {
  const _Eye({required this.closed});

  final bool closed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: closed ? 5 : 26,
      decoration: BoxDecoration(
        color: Colors.black87,
        // A closed eye is a flat line, so a circle would look wrong.
        shape: closed ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: closed ? BorderRadius.circular(3) : null,
      ),
    );
  }
}

/// The mouth. It is wide and happy, small and flat, or turned down and sad.
class _Mouth extends StatelessWidget {
  const _Mouth({required this.mood});

  final Mood mood;

  @override
  Widget build(BuildContext context) {
    // How wide the mouth is for each mood.
    final double width = switch (mood) {
      Mood.happy => 80,
      Mood.okay => 60,
      Mood.sad => 40,
      Mood.sleepy => 26,
    };

    return Container(
      width: width,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.brown.shade700,
        // A happy mouth is rounded at the bottom like a smile.
        borderRadius: mood == Mood.happy
            ? const BorderRadius.vertical(bottom: Radius.circular(40))
            : BorderRadius.circular(8),
      ),
    );
  }
}
