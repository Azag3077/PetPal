import 'package:flutter_test/flutter_test.dart';

import 'package:petpal/models/pet.dart';

void main() {
  // These tests never draw anything. They only check the Pet class's rules,
  // which is why they run in a blink.
  group('Pet', () {
    test('a new pet starts with the numbers we asked for', () {
      final pet = Pet(name: 'Bolu', hunger: 50, happiness: 60, energy: 70);

      expect(pet.name, 'Bolu');
      expect(pet.hunger, 50);
      expect(pet.happiness, 60);
      expect(pet.energy, 70);
    });

    test('feed() makes the pet less hungry and a bit happier', () {
      final pet = Pet(name: 'Bolu', hunger: 50, happiness: 60);

      pet.feed();

      expect(pet.hunger, 25);
      expect(pet.happiness, 65);
    });

    test('play() is fun but tiring', () {
      final pet = Pet(name: 'Bolu', hunger: 20, happiness: 50, energy: 80);

      pet.play();

      expect(pet.happiness, 70);
      expect(pet.energy, 65);
      expect(pet.hunger, 30);
    });

    test('sleep() gives back energy', () {
      final pet = Pet(name: 'Bolu', hunger: 20, energy: 40);

      pet.sleep();

      expect(pet.energy, 70);
      expect(pet.hunger, 30);
    });

    test('numbers never drop below 0 or climb above 100', () {
      final pet = Pet(name: 'Bolu', hunger: 10, happiness: 95, energy: 5);

      pet.feed();
      expect(pet.hunger, 0, reason: 'hunger should stop at 0');

      pet.play();
      expect(pet.happiness, 100, reason: 'happiness should stop at 100');
      expect(pet.energy, 0, reason: 'energy should stop at 0');
    });
  });

  group('Pet mood', () {
    test('a lively, well fed, cheerful pet is happy', () {
      final pet = Pet(name: 'Bolu', hunger: 20, happiness: 80, energy: 90);

      expect(pet.mood, Mood.happy);
    });

    test('a so-so pet is okay', () {
      final pet = Pet(name: 'Bolu', hunger: 40, happiness: 50, energy: 90);

      expect(pet.mood, Mood.okay);
    });

    test('a starving pet is sad', () {
      final pet = Pet(name: 'Bolu', hunger: 90, happiness: 100, energy: 90);

      expect(pet.mood, Mood.sad);
    });

    test('a worn out pet is sleepy, even when it is happy', () {
      final pet = Pet(name: 'Bolu', hunger: 10, happiness: 100, energy: 10);

      expect(pet.mood, Mood.sleepy);
    });
  });
}
