import 'package:flutter/material.dart';

import '../models/pet.dart';
import 'pet_view.dart';

/// A green patch of grass that the pet can be dragged around.
///
/// The pet is not in a Column any more — it floats at an exact spot inside a
/// `Stack`, and we remember that spot ourselves.
class PlayArea extends StatefulWidget {
  const PlayArea({
    super.key,
    required this.mood,
    required this.shakeCount,
    required this.onPetTapped,
  });

  /// Passed straight through to the pet.
  final Mood mood;

  /// Passed straight through to the pet.
  final int shakeCount;

  /// What to do when someone taps the pet. The play area does not decide —
  /// it just reports the tap, like our buttons do.
  final VoidCallback onPetTapped;

  @override
  State<PlayArea> createState() => _PlayAreaState();
}

/// Keeps track of where the pet is standing.
class _PlayAreaState extends State<PlayArea> {
  /// How big the pet is, so we can stop it wandering off the grass.
  static const double _petWidth = 200;
  static const double _petHeight = 232;

  /// How far the pet is from the left and the top of the grass.
  Offset _position = const Offset(30, 24);

  /// Moves the pet by however far the finger moved.
  /// `clamp` keeps it on the grass: never less than 0, never past the edge.
  void _movePet(Offset delta, BoxConstraints area) {
    final double furthestRight = (area.maxWidth - _petWidth).clamp(0, 9999);
    final double furthestDown = (area.maxHeight - _petHeight).clamp(0, 9999);

    setState(() {
      _position = Offset(
        (_position.dx + delta.dx).clamp(0, furthestRight),
        (_position.dy + delta.dy).clamp(0, furthestDown),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.lightGreen.shade100,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.lightGreen.shade400, width: 2),
      ),
      // LayoutBuilder tells us how much room we were given, so we know where
      // the edges of the grass are.
      child: LayoutBuilder(
        builder: (context, area) {
          return Stack(
            children: [
              // Positioned only works inside a Stack. It says "put this child
              // exactly this far from the left and this far from the top".
              Positioned(
                left: _position.dx,
                top: _position.dy,
                child: GestureDetector(
                  // onPanUpdate fires over and over while a finger slides.
                  // `details.delta` is how far it moved since last time —
                  // not where it is, just the little step.
                  onPanUpdate: (details) => _movePet(details.delta, area),
                  onTap: widget.onPetTapped,
                  child: PetView(
                    mood: widget.mood,
                    shakeCount: widget.shakeCount,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
