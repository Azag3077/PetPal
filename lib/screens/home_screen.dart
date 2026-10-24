import 'package:flutter/material.dart';

import '../widgets/pet_view.dart';
import '../widgets/stat_bar.dart';

/// The main screen of the app.
/// It is a StatefulWidget because the numbers on it can change
/// while the app is running.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// This is where the screen keeps its three numbers and changes them.
class _HomeScreenState extends State<HomeScreen> {
  // Hunger: 0 means full tummy, 100 means starving.
  int hunger = 40;

  // Happiness and energy: 100 is great, 0 is terrible.
  int happiness = 70;
  int energy = 80;

  /// Keeps a number inside 0 and 100 so the bars never overflow.
  int _clamp(int value) => value.clamp(0, 100);

  /// Feeding fills the tummy (less hunger) and cheers the pet up a little.
  void feed() {
    setState(() {
      hunger = _clamp(hunger - 25);
      happiness = _clamp(happiness + 5);
    });
  }

  /// Playing is fun but tiring, and it makes the pet hungry.
  void play() {
    setState(() {
      happiness = _clamp(happiness + 20);
      energy = _clamp(energy - 15);
      hunger = _clamp(hunger + 10);
    });
  }

  /// Sleeping gives back a lot of energy, but you wake up hungry.
  void sleep() {
    setState(() {
      energy = _clamp(energy + 30);
      hunger = _clamp(hunger + 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetPal'),
        centerTitle: true,
      ),
      // Three bars made the screen taller. On a small phone the content
      // would not fit, so we let it scroll.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const PetView(),
            const SizedBox(height: 16),
            Text(
              'Bolu',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            // The three bars that show how the pet is doing.
            StatBar(label: 'Hunger', value: hunger, color: Colors.redAccent),
            StatBar(
              label: 'Happiness',
              value: happiness,
              color: Colors.green,
            ),
            StatBar(label: 'Energy', value: energy, color: Colors.blue),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  label: 'Feed',
                  icon: Icons.restaurant,
                  onPressed: feed,
                ),
                _ActionButton(
                  label: 'Play',
                  icon: Icons.sports_esports,
                  onPressed: play,
                ),
                _ActionButton(
                  label: 'Sleep',
                  icon: Icons.bedtime,
                  onPressed: sleep,
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

  /// The function this button should run. Buttons do not decide what
  /// happens — the screen does. The button just reports the tap.
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
