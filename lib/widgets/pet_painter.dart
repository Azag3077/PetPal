import 'package:flutter/material.dart';

import '../models/pet.dart';

/// Draws the pet by hand, one shape at a time, onto a blank canvas.
///
/// A CustomPainter is like being given a sheet of paper and some crayons.
/// Nothing is there until we draw it: no Containers, no widgets, just shapes.
class PetPainter extends CustomPainter {
  PetPainter({required this.mood, required this.bodyColor});

  /// How the pet is feeling — this decides the shape of the mouth and whether
  /// the eyes are open.
  final Mood mood;

  /// The colour of the body, worked out by PetView.
  final Color bodyColor;

  /// Flutter calls this whenever the pet needs drawing.
  /// `size` is how much space we were given, `canvas` is the paper.
  @override
  void paint(Canvas canvas, Size size) {
    final Offset middle = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2 - 4;

    // A Paint is a crayon: it holds a colour and a style.
    // `fill` colours the whole shape in; `stroke` only draws the outline.
    final body = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    // The outline is just the body colour mixed 40% of the way to black, so
    // it always matches whatever colour the player chose.
    final outline = Paint()
      ..color = Color.lerp(bodyColor, Colors.black, 0.4)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // 1. The round body, then its outline on top.
    canvas.drawCircle(middle, radius, body);
    canvas.drawCircle(middle, radius, outline);

    _drawEyes(canvas, size);
    _drawMouth(canvas, size);
  }

  /// Two eyes: filled circles when awake, short lines when asleep.
  void _drawEyes(Canvas canvas, Size size) {
    final eye = Paint()..color = Colors.black87;

    final double eyeY = size.height * 0.4;
    final double leftX = size.width * 0.35;
    final double rightX = size.width * 0.65;

    if (mood == Mood.sleepy) {
      // A sleeping eye is a flat line, so we draw a line with a thick crayon.
      final closed = Paint()
        ..color = Colors.black87
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        Offset(leftX - 13, eyeY),
        Offset(leftX + 13, eyeY),
        closed,
      );
      canvas.drawLine(
        Offset(rightX - 13, eyeY),
        Offset(rightX + 13, eyeY),
        closed,
      );
      return;
    }

    canvas.drawCircle(Offset(leftX, eyeY), 13, eye);
    canvas.drawCircle(Offset(rightX, eyeY), 13, eye);
  }

  /// The mouth is a curved line. How far the middle of the curve bends up or
  /// down is what makes a smile or a frown.
  void _drawMouth(Canvas canvas, Size size) {
    final mouth = Paint()
      ..color = Colors.brown.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    // A positive number bends the curve downwards (a smile),
    // a negative number bends it upwards (a frown), 0 is a flat line.
    final double bend = switch (mood) {
      Mood.happy => 40,
      Mood.okay => 0,
      Mood.sad => -30,
      Mood.sleepy => 10,
    };

    final double mouthY = size.height * 0.63;
    final double halfWidth = mood == Mood.sleepy ? 20 : 38;

    // A Path is a route for the crayon to follow.
    final path = Path()
      ..moveTo(size.width / 2 - halfWidth, mouthY)
      // quadraticBezierTo pulls the line towards a point without touching it,
      // which is how you make a nice smooth curve from just three numbers.
      ..quadraticBezierTo(
        size.width / 2,
        mouthY + bend,
        size.width / 2 + halfWidth,
        mouthY,
      );

    canvas.drawPath(path, mouth);
  }

  /// Flutter asks: "has anything changed, should I draw again?"
  /// We only say yes when the mood or the colour is different, so we do not
  /// waste time redrawing the same picture.
  @override
  bool shouldRepaint(PetPainter oldDelegate) {
    return oldDelegate.mood != mood || oldDelegate.bodyColor != bodyColor;
  }
}
