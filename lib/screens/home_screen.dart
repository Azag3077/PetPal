import 'package:flutter/material.dart';

import '../widgets/pet_view.dart';

/// The main screen of the app.
/// For now it just shows the pet, its name and three buttons.
/// The buttons do not do anything yet — that is the next lesson!
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PetPal'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PetView(),
            const SizedBox(height: 24),
            // The pet's name, written in big friendly letters.
            Text(
              'Bolu',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            // Three buttons in a row. They are spaced out evenly.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _ActionButton(label: 'Feed', icon: Icons.restaurant),
                _ActionButton(label: 'Play', icon: Icons.sports_esports),
                _ActionButton(label: 'Sleep', icon: Icons.bedtime),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// One of the three buttons at the bottom of the screen.
/// We made our own widget so all three buttons look exactly the same.
class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filled(
          iconSize: 32,
          // null means "this button is switched off" for now.
          onPressed: null,
          icon: Icon(icon),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
