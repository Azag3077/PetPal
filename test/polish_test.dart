import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:petpal/models/pet.dart';

import 'helpers.dart';

void main() {
  group('Pet game over', () {
    test('one bad number is not enough to lose the pet', () {
      final pet = Pet(name: 'Bolu', hunger: 100, happiness: 70, energy: 80);

      expect(pet.hasRunAway, isFalse);
    });

    test('all three at their worst means the pet runs away', () {
      final pet = Pet(name: 'Bolu', hunger: 100, happiness: 0, energy: 0);

      expect(pet.hasRunAway, isTrue);
    });

    test('reset() puts every number back to the start', () {
      final pet = Pet(name: 'Bolu', hunger: 100, happiness: 0, energy: 0);

      pet.reset();

      expect(pet.hunger, 40);
      expect(pet.happiness, 70);
      expect(pet.energy, 80);
      expect(pet.hasRunAway, isFalse);
    });
  });

  testWidgets('the reset button asks before it resets', (tester) async {
    useTallScreen(tester);
    await startWithPet(tester);

    // Feed the pet so hunger is 15 instead of 40.
    await tester.tap(find.byIcon(Icons.restaurant));
    await tester.pump();
    expect(find.text('15'), findsOneWidget);

    // Open the reset dialog and say no.
    await tester.tap(find.byIcon(Icons.restart_alt));
    await finishDialog(tester);
    expect(find.text('Start again?'), findsOneWidget);

    await tester.tap(find.text('No, keep playing'));
    await finishDialog(tester);

    // Nothing changed.
    expect(find.text('15'), findsOneWidget);

    // Now say yes.
    await tester.tap(find.byIcon(Icons.restart_alt));
    await finishDialog(tester);
    await tester.tap(find.text('Yes, reset'));
    await finishDialog(tester);

    expect(find.text('40'), findsOneWidget);
    expect(find.text('Bolu feels brand new!'), findsOneWidget);
  });

  testWidgets('a neglected pet runs away, and can be won back',
      (tester) async {
    useTallScreen(tester);
    await startWithPet(tester);

    // Do nothing at all for a long time. Energy starts at 80 and drops by 2
    // a tick, so after 40 ticks every stat is at its worst.
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(seconds: 6));
    }
    await finishDialog(tester);

    expect(find.text('Bolu ran away!'), findsOneWidget);

    await tester.tap(find.text('Start again'));
    await finishDialog(tester);

    // The sad news is gone and the pet is back to its starting numbers.
    expect(find.text('Bolu ran away!'), findsNothing);
    expect(find.text('40'), findsOneWidget);
    expect(find.text('Happy'), findsOneWidget);
  });
}
