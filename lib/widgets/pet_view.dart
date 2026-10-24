import 'dart:math';

import 'package:flutter/material.dart';

import '../models/pet.dart';
import 'pet_painter.dart';

/// Shows the pet and makes it move.
///
/// The pet itself is no longer made of Containers — it is *painted* by
/// [PetPainter]. This widget's job is to pick the colour, run the
/// animations, and hand the painter a canvas to draw on.
class PetView extends StatefulWidget {
  const PetView({
    super.key,
    required this.mood,
    this.baseColor = const Color(0xFFFFCC80),
    this.shakeCount = 0,
  });

  /// How the pet is feeling right now.
  final Mood mood;

  /// The colour the player chose on the name screen. The mood then tints it:
  /// bright when happy, washed out when sad.
  final Color baseColor;

  /// A counter that goes up by one every time the pet is fed.
  /// We do not care about the number — we only care that it *changed*,
  /// because that is our signal to shake.
  final int shakeCount;

  @override
  State<PetView> createState() => _PetViewState();
}

/// The `TickerProviderStateMixin` on the end is what lets this state own
/// animation controllers. A "ticker" is Flutter's heartbeat: about 60 beats
/// a second, and on every beat our animation moves on a little.
class _PetViewState extends State<PetView> with TickerProviderStateMixin {
  /// Up and down, over and over, while the pet is happy.
  late final AnimationController _bounce;

  /// Left and right, once, when the pet is fed.
  late final AnimationController _shake;

  @override
  void initState() {
    super.initState();
    _bounce = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _shake = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _syncBounce();
  }

  /// Runs whenever the screen hands us new information.
  /// We use it to notice two things: a new mood, and a new shake.
  @override
  void didUpdateWidget(PetView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.mood != widget.mood) {
      _syncBounce();
    }

    if (oldWidget.shakeCount != widget.shakeCount) {
      // `from: 0` means "start again from the beginning", so feeding twice
      // quickly shakes twice.
      _shake.forward(from: 0);
    }
  }

  /// Controllers hold on to the ticker, so they must be disposed —
  /// exactly like the timer in lesson 05.
  @override
  void dispose() {
    _bounce.dispose();
    _shake.dispose();
    super.dispose();
  }

  /// Bounce for ever while happy; settle back down otherwise.
  void _syncBounce() {
    if (widget.mood == Mood.happy) {
      // `reverse: true` makes it go up, down, up, down instead of jumping
      // back to the start.
      _bounce.repeat(reverse: true);
    } else {
      _bounce.stop();
      _bounce.animateTo(0, duration: const Duration(milliseconds: 200));
    }
  }

  /// Picks the body colour: the player's colour, tinted by the mood.
  ///
  /// `Color.lerp(a, b, 0.4)` means "mix a and b, 40% of the way towards b".
  /// A `switch` on an enum is neat: the compiler checks we covered every mood.
  Color get _bodyColor {
    switch (widget.mood) {
      case Mood.happy:
        return widget.baseColor;
      case Mood.okay:
        return Color.lerp(widget.baseColor, Colors.white, 0.3)!;
      case Mood.sad:
        return Color.lerp(widget.baseColor, Colors.blueGrey, 0.5)!;
      case Mood.sleepy:
        return Color.lerp(widget.baseColor, Colors.indigo.shade200, 0.4)!;
    }
  }

  /// A short word to show under the pet.
  String get _moodLabel {
    switch (widget.mood) {
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
        // AnimatedBuilder redraws just this little bit of the screen on every
        // beat of the ticker, instead of the whole app.
        AnimatedBuilder(
          animation: Listenable.merge([_bounce, _shake]),
          builder: (context, child) {
            // Up to 12 pixels up when bouncing.
            final double dy = -12 * _bounce.value;

            // sin() swings between -1 and 1, so this wobbles side to side and
            // the `(1 - value)` part makes the wobble die away.
            final double dx =
                sin(_shake.value * pi * 6) * 10 * (1 - _shake.value);

            return Transform.translate(offset: Offset(dx, dy), child: child);
          },
          child: _buildBody(),
        ),
        const SizedBox(height: 8),
        Text(
          _moodLabel,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  /// The painted pet.
  ///
  /// `TweenAnimationBuilder` is the implicit-animation trick from last lesson,
  /// but for a value we use ourselves instead of a widget's property. It hands
  /// us a colour part-way between the old one and the new one, so the body
  /// still fades gently from mood to mood.
  Widget _buildBody() {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: _bodyColor),
      duration: const Duration(milliseconds: 400),
      builder: (context, color, _) {
        return CustomPaint(
          // CustomPaint has no size of its own, so we must give it one.
          size: const Size(200, 200),
          painter: PetPainter(
            mood: widget.mood,
            bodyColor: color ?? _bodyColor,
          ),
        );
      },
    );
  }
}
