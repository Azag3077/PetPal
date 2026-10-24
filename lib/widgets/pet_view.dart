import 'dart:math';

import 'package:flutter/material.dart';

import '../models/pet.dart';

/// Draws our pet and makes it move.
///
/// Two kinds of movement happen here:
/// * the colours and the mouth *slide* smoothly from one mood to the next
///   (an "implicit" animation — Flutter does the work);
/// * the pet bounces when it is happy and shakes when it is fed
///   (an "explicit" animation — we drive it ourselves).
class PetView extends StatefulWidget {
  const PetView({super.key, required this.mood, this.shakeCount = 0});

  /// How the pet is feeling right now.
  final Mood mood;

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
  /// exactly like the timer in the last lesson.
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

  /// Picks the body colour for each mood.
  /// A `switch` on an enum is neat: the compiler checks we covered every mood.
  Color get _bodyColor {
    switch (widget.mood) {
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

  /// The pet's face. The outer box is an AnimatedContainer, so when the mood
  /// changes the colour fades instead of snapping.
  Widget _buildBody() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Eye(closed: widget.mood == Mood.sleepy),
              const SizedBox(width: 36),
              _Eye(closed: widget.mood == Mood.sleepy),
            ],
          ),
          const SizedBox(height: 24),
          _Mouth(mood: widget.mood),
        ],
      ),
    );
  }
}

/// One single eye. Open it is a black circle; closed it is a thin line.
/// It is an AnimatedContainer, so the eye closes smoothly like a real blink.
class _Eye extends StatelessWidget {
  const _Eye({required this.closed});

  final bool closed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 26,
      height: closed ? 5 : 26,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(closed ? 3 : 13),
      ),
    );
  }
}

/// The mouth. It is wide and happy, small and flat, or turned down and sad —
/// and it slides between those shapes.
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
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
