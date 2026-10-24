import 'package:flutter/material.dart';

import '../models/pet.dart';
import '../widgets/pet_view.dart';
import '../widgets/stat_bar.dart';

/// A second screen showing the pet's numbers and a little about the app.
///
/// It can send one piece of information back to the home screen: whether the
/// player decided to give the pet a treat.
class AboutScreen extends StatelessWidget {
  const AboutScreen({
    super.key,
    required this.pet,
    required this.petColor,
  });

  /// The pet we are reporting on. We only *read* it here — the home screen
  /// stays in charge of changing it.
  final Pet pet;

  /// The colour the player chose, so the pet looks the same on both screens.
  final Color petColor;

  /// Turns a mood into a sentence a child can read.
  String get _advice {
    switch (pet.mood) {
      case Mood.happy:
        return '${pet.name} is having a lovely day. Well done!';
      case Mood.okay:
        return '${pet.name} is alright, but a game would help.';
      case Mood.sad:
        return '${pet.name} needs attention. Try food and a cuddle.';
      case Mood.sleepy:
        return '${pet.name} is worn out. Time for a nap.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar puts a back arrow here all by itself, and that arrow
      // calls Navigator.pop for us.
      appBar: AppBar(
        title: Text('All about ${pet.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            PetView(mood: pet.mood, baseColor: petColor),
            const SizedBox(height: 16),
            Text(
              _advice,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            StatBar(label: 'Hunger', value: pet.hunger, color: Colors.redAccent),
            StatBar(
              label: 'Happiness',
              value: pet.happiness,
              color: Colors.green,
            ),
            StatBar(label: 'Energy', value: pet.energy, color: Colors.blue),
            const SizedBox(height: 32),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'PetPal was built one lesson at a time with Flutter. '
                  'Every shape you can see is drawn by code — there are no '
                  'pictures in this app at all.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                // The second thing we give `pop` is the answer we are sending
                // back. The home screen is waiting for it.
                onPressed: () => Navigator.pop(context, 'treat'),
                icon: const Icon(Icons.cake),
                label: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Give a treat', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                // Popping with nothing means "no treat today".
                onPressed: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Back to my pet', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
