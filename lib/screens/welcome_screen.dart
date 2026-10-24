import 'package:flutter/material.dart';

import '../models/pet.dart';
import '../widgets/pet_view.dart';
import 'name_screen.dart';

/// The very first screen: a title, a sample pet and a Get Started button.
///
/// It is a StatelessWidget — nothing on it ever changes. It only needs to know
/// how to open the next screen.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                'PetPal',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Feed it. Play with it. Keep it happy.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              const PetView(mood: Mood.happy),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  // Navigator.push puts a new screen ON TOP of this one,
                  // like putting a new sheet of paper on a pile.
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NameScreen(),
                      ),
                    );
                  },
                  // No padding or font size here — the theme handles both.
                  child: const Text('Get started'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
