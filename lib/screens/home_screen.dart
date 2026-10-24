import 'package:flutter/material.dart';

import '../models/pet.dart';
import '../widgets/pet_view.dart';
import '../widgets/stat_bar.dart';

/// The main screen of the app.
/// It owns one Pet object and draws whatever that pet's numbers say.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// The screen's job is now only two things:
/// 1. show the pet's numbers, and
/// 2. tell the pet when a button was tapped.
/// All the rules about how much hunger changes live inside the Pet class.
class _HomeScreenState extends State<HomeScreen> {
  final Pet pet = Pet(name: 'Bolu');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetPal'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const PetView(),
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
                  onPressed: () => setState(() => pet.feed()),
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
