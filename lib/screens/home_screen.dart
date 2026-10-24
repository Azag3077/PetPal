import 'dart:async';

import 'package:flutter/material.dart';

import '../models/pet.dart';
import '../widgets/play_area.dart';
import '../widgets/stat_bar.dart';
import 'about_screen.dart';

/// The main screen of the app.
/// It owns one Pet object and draws whatever that pet's numbers say.
///
/// The name and colour are not decided here any more — they arrive from the
/// NameScreen, through the constructor.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.petName,
    required this.petColor,
  });

  /// The name the player typed in.
  final String petName;

  /// The colour the player picked.
  final Color petColor;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// As well as showing the pet, this screen now keeps a clock running so time
/// passes even when the player does nothing.
class _HomeScreenState extends State<HomeScreen> {
  /// `late` means "I promise to fill this in before anyone reads it".
  /// We cannot build the pet on this line because we need `widget.petName`,
  /// and `widget` is only ready once `initState` runs.
  late final Pet pet;

  /// Our repeating clock. It may be null before the screen is ready,
  /// which is why the type has a `?` on the end.
  Timer? _clock;

  /// So we only nag the player once per hungry spell, not every three seconds.
  bool _hasWarned = false;

  /// Goes up by one every time we feed the pet. PetView watches this number
  /// and shakes the pet whenever it changes.
  int _shakeCount = 0;

  /// `initState` runs ONCE, right when the screen is created.
  /// It is the place to start things like timers.
  @override
  void initState() {
    super.initState();
    pet = Pet(name: widget.petName);
    // Six seconds per tick. Slow enough that a player can walk over to the
    // stats screen and back without the pet starving while they are away.
    _clock = Timer.periodic(const Duration(seconds: 6), (timer) {
      setState(() => pet.tick());
      _warnIfStarving();
    });
  }

  /// `dispose` runs ONCE, right when the screen is thrown away.
  /// Anything we started in `initState` must be stopped here, or it keeps
  /// running forever in the background. A timer that is never cancelled is
  /// like leaving a tap running.
  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  /// Shows a message at the bottom of the screen when the pet gets too hungry.
  void _warnIfStarving() {
    if (pet.isStarving && !_hasWarned) {
      _hasWarned = true;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${pet.name} is starving! Please feed your pet.'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }

    // Once the pet has been fed we are allowed to warn again later.
    if (!pet.isStarving) {
      _hasWarned = false;
    }
  }

  /// Opens the stats screen and waits to hear what the player chose there.
  ///
  /// `await` means "pause here until that screen closes". The value that comes
  /// back is whatever the other screen passed to `Navigator.pop`.
  Future<void> _openAbout() async {
    final answer = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => AboutScreen(pet: pet, petColor: widget.petColor),
      ),
    );

    // While we were away this screen might have been closed, so we check
    // `mounted` before touching it. Without this check Flutter complains.
    if (!mounted) return;

    if (answer == 'treat') {
      setState(() {
        pet.feed();
        _shakeCount++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${pet.name} loved that treat!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetPal'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _openAbout,
            icon: const Icon(Icons.info_outline),
            tooltip: 'Stats and about',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // The pet now lives on a patch of grass it can be dragged around.
            PlayArea(
              mood: pet.mood,
              baseColor: widget.petColor,
              shakeCount: _shakeCount,
              onPetTapped: () => setState(() => pet.giggle()),
            ),
            const SizedBox(height: 16),
            Text(
              pet.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            StatBar(
              label: 'Hunger',
              value: pet.hunger,
              color: Colors.redAccent,
            ),
            StatBar(
              label: 'Happiness',
              value: pet.happiness,
              color: Colors.green,
            ),
            StatBar(label: 'Energy', value: pet.energy, color: Colors.blue),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  label: 'Feed',
                  icon: Icons.restaurant,
                  // Ask the pet to eat, then redraw the screen.
                  onPressed: () => setState(() {
                    pet.feed();
                    _shakeCount++;
                  }),
                ),
                _ActionButton(
                  label: 'Play',
                  icon: Icons.sports_esports,
                  onPressed: () => setState(() => pet.play()),
                ),
                _ActionButton(
                  label: 'Sleep',
                  icon: Icons.bedtime,
                  onPressed: () => setState(() => pet.sleep()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One of the three buttons at the bottom of the screen.
/// It is told which function to run when it is tapped.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filled(
          iconSize: 32,
          onPressed: onPressed,
          icon: Icon(icon),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
